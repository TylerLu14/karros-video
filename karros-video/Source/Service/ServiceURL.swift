
//
//  Service URL.swift
//  karros-video
//
//  Created by Hoang Lu on 4/16/20.
//  Copyright © 2020 Hoang Lu. All rights reserved.
//

import Foundation
import Alamofire

enum ImdbRouter: URLRequestConvertible {
    static let baseURLString = "https://api.themoviedb.org/3/movie/"
    static let apiKey = "a7b3c9975791294647265c71224a88ad"
    
    case getNowPlaying(page: Int)
    case getPopular(page: Int)
    case getTopRated(page: Int)
    case getUpcoming(page: Int)
    
    var path: String {
        switch self {
        case .getNowPlaying: return "now_playing"
        case .getPopular: return "popular"
        case .getTopRated: return "top_rated"
        case .getUpcoming: return "upcoming"
        }
    }
    
    var page: Int {
        switch self {
        case .getNowPlaying(let page): return page
        case .getPopular(let page): return page
        case .getTopRated(let page): return page
        case .getUpcoming(let page): return page
        }
    }
    
    var url: URL {
        URL(string: ImdbRouter.baseURLString)!.appendingPathComponent(path)
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.method = .get
        
        let parameters: Parameters = [
            "api_key": ImdbRouter.apiKey,
            "page": page,
            "language": "en-US"
        ]
        
        let encoding = URLEncoding.queryString
        return try encoding.encode(request, with: parameters)
    }
}
