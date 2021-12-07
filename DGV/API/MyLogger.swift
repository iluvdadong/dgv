//
//  MyLogger.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/06.
//

import Foundation
import Alamofire

final class MyLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "MyLogger")
    
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume")
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request.didParseResponse")
        debugPrint(request)
    }
}
