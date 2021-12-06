//
//  MyAlamofireManager.swift
//  DGV - Router
//
//  Created by DaHae Kim on 2021/12/06.
//

import Foundation
import Alamofire

final class MyAlamofireManager {
    
    // 싱글톤 적용 : 싱글톤에서 자기자신을 가져올 때는 보통 shared를 사용하는 편
    static let shared = MyAlamofireManager()
    
    // interceptor : 헤더에 추가한다던지 설정가능
    let interceptors = Interceptor(interceptors:
                                    [
                                        BaseInterceptor()
                                    ])
    
    // 로거 설정
    let monitors = [MyLogger(), MyApiStatusLogger()] as [EventMonitor]
    
    // 세션 설정
    var session : Session
    
    // 세션 인스턴스 만들 때 위 항목 넣어줌
    private init() {
        session = Session(
            interceptor: interceptors,
            eventMonitors: monitors
        )
    }
    
}
