//
//  BaseInterceptor.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/06.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("BaseInterceptor - adapt() called")
        
        var request = urlRequest
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        request.addValue(API.CLIENT_ID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(API.CLIENT_SECRET, forHTTPHeaderField: "X-Naver-Client-Secret")
        
//        // 공통 파라미터 추가
//        var dictionary = [String : String]()
//        dictionary.updateValue(API.CLIENT_ID, forKey: "client_id")
//
//        do {
//            request = URLEncodedFormParameterEncoder().encode(dictionary, into: request)
//        } catch {
//            print(error)
//        }
//
        completion(.success(request))
    }
    
    // 호출시 정상적으로 작동이 안됐을 때 여기서 핸들링 가능
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
       
        print("BaseInterceptor - retry() called")
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        let data = ["statusCode" : statusCode]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL ), object: nil, userInfo: data)
        
        completion(.doNotRetry)

    }
}
