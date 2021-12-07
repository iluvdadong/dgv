//
//  MySearchRouter.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/07.
//

import Foundation
import Alamofire

// 검색 관련 API
enum MySearchRouter: URLRequestConvertible {
    // API 분기처리
    case searchMovies(term: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL +  "v1/search/")!
    }
    
    var method: HTTPMethod {
        return .get
//        switch self {
//            // seatchMovies 호출 시 http 방식 get으로 받음(분기처리 필요할 때 http method 나누는 부분)
//        case .searchMovies(term: <#T##String#>): return .get
//        }
    }
    
    // EndPoint 라우팅
    var endPoint: String {
        return "movie.json"
//        switch self {
//        case .get: return "get"
//        case .post: return "post"
//        }
    }
    
    var parameters : [String : String] {
        switch self {
        case let .searchMovies(term):
            return ["query" : term]
        }
    }
    
    // 실제 url 호출하면 발동되는 부분
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
        
        print("MySearchRouter - asURLRequest() called url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
        return request
    }
}
