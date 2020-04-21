
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
    case getMovieDetail(id: Int)
    case getCredits(id: Int)
    case getReccomends(fromId: Int, page: Int)
    case getReviews(id: Int, page: Int)
    
    var path: String {
        switch self {
        case .getNowPlaying: return "now_playing"
        case .getPopular: return "popular"
        case .getTopRated: return "top_rated"
        case .getUpcoming: return "upcoming"
        case .getMovieDetail(let id): return "\(id)"
        case .getCredits(let id): return "\(id)/credits"
        case .getReccomends(let id, _): return "\(id)/recommendations"
        case .getReviews(let id, _): return "\(id)/reviews"
        }
    }
    
    var parameters: Parameters {
        var parameters: Parameters = [
            "api_key": ImdbRouter.apiKey,
            "language": "en-US",
        ]
        
        switch self {
        case .getNowPlaying(let page), .getPopular(let page), .getTopRated(let page), .getUpcoming(let page), .getReccomends( _, let page), .getReviews(_, let page):
            parameters["page"] = page
        case .getMovieDetail, .getCredits:
            break
        }
        
        return parameters
    }
    
    var url: URL {
        URL(string: ImdbRouter.baseURLString)!.appendingPathComponent(path)
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        request.method = .get
        return try URLEncoding.queryString.encode(request, with: parameters)
    }
}
