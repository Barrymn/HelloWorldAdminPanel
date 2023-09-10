//
//  DevicesAPI.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-08.
//

import Foundation

enum DevicesAPI: API {
    case getDevices(page: Int)

    var scheme: HTTPScheme { return .https }

    var baseURL: String { return "hiring.iverify.io" }

    var path: String { return "/api/devices" }

    var parameters: [URLQueryItem] {
        switch self {
        case .getDevices(let page):
            return [URLQueryItem(name: "page", value: String(page)),
                    URLQueryItem(name: "pageSize", value: "1000")]
        }
    }

    var method: HTTPMethod { return .get }
}
