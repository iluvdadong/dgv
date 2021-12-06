//
//  MyApiStatusLogger.swift
//  DGV
//
//  Created by DaHae Kim on 2021/12/06.
//

import Foundation
import Alamofire

final class MyApiStatusLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "MyApiStatusLogger")

    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        
        guard let statusCode = request.response?.statusCode else { return }

        print("MyApiStatusLogger - request.statusCode : ]\(statusCode)")
    }
}

