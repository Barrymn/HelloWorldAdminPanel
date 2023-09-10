//
//  AuthManager.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-09.
//

import Foundation
import Combine

class AuthManager {
    func getToken() -> Future<String, Never> {
        return Future { promise in
            promise(.success("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJBdXRoZW50aWNhdGlvbiIsImlzcyI6ImlWZXJpZnkiLCJ1c2VySWQiOjYyLCJleHAiOjE3MjUxMjg5Mjl9.Vzy-WfuNVplsuv9yuSgPQQNivRWmtywM144j4BcScPs"))
        }
    }
}
