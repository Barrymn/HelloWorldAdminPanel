//
//  DataProvider.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-10.
//

import Foundation
import Combine

protocol DataProvider {
    func getDevices(atPage page: Int) -> AnyPublisher<DevicesResponse, APIError>
}
