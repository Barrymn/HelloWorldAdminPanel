//
//  APIError.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-10.
//

import Foundation

enum APIError: Error {
    case transportError(Error)
    case serverSideError(Int)
    case invalidJson(String)
    case invalidURL

    public var description: String {
        switch self {
        case .transportError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .serverSideError(let statusCode):
            return "Server-side error \(statusCode) occured."
        case .invalidJson(let type):
            return "Invalid JSON for type: \(type)"
        case .invalidURL:
            return "Invalid URL"
        }
    }
}
