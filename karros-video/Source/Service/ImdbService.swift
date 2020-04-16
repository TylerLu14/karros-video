//
//  ImdbService.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

import Foundation

public enum ServiceError: Error {
    case cannotParseData
    case serverResponseError(data: [String:Any])
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotParseData: return "Cannot parse data"
        case .serverResponseError(let data):
            guard let statusCode = data["status_code"] as? String, let message = data["status_message"] as? String else {
                return ""
            }
            return "Server Error - Status Code:\(statusCode) - Message: \(message)"
        }
        
    }
}


class NetworkManager: SessionDelegate {
    static let sharedManager = NetworkManager()
    let alamofireSession: Session
    
    init() {
        let alamofireConfig = URLSessionConfiguration.default
        alamofireConfig.httpShouldSetCookies = true
        alamofireConfig.httpCookieAcceptPolicy = .always
        alamofireConfig.requestCachePolicy = .reloadRevalidatingCacheData
        alamofireConfig.timeoutIntervalForRequest = 5
        
        alamofireSession = Session(configuration: alamofireConfig)
    }
}



class NetworkService {
    let networkManager = NetworkManager.sharedManager
    
    func request(urlRequest: URLRequestConvertible) -> Single<[String:Any]> {
        return Single<[String:Any]>.create{ single in
            let request = self.networkManager.alamofireSession.request(urlRequest)
            request.responseJSON{ response in
                if let error = response.error {
                    single(.error(error))
                }
                
                switch response.result {
                case .failure(let error):
                    single(.error(error))
                case .success(let json):
                    guard let json = json as? [String:Any] else {
                        single(.error(ServiceError.cannotParseData))
                        break
                    }
                    single(.success(json))
                }
            }
            
            return Disposables.create{ request.cancel() }
        }
    }
}

protocol IImdbService {
    func getMovies(router: ImdbRouter) -> Single<[Movie]>
}

class ImdbService: NetworkService, IImdbService {
    func getMovies(router: ImdbRouter) -> Single<[Movie]> {
        return request(urlRequest: router)
            .map{ json in
                guard let results = json["results"] as? [[String:Any]] else {
                    return []
                }
                return results.compactMap{ Movie(JSON: $0) }
            }
    }
}
