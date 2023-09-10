//
//  API.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-08.
//

import Foundation

protocol API {
    var scheme: HTTPScheme { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }
}

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
 }

enum HTTPScheme: String {
    case http
    case https
}
