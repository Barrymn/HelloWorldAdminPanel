//
//  DevicesService.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-10.
//

import Foundation
import Combine

struct DevicesService: DataProvider {
    func getDevices(atPage page: Int) -> AnyPublisher<DevicesResponse, APIError> {
        return APIManager.shared.request(endpoint: DevicesAPI.getDevices(page: page))
    }
}
