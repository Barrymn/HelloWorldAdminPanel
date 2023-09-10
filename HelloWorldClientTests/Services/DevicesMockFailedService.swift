//
//  DevicesMockFailedService.swift
//  HelloWorldClientTests
//
//  Created by Barry Ma on 2023-09-10.
//

import Foundation
import Combine
@testable import HelloWorldClient

struct DevicesMockFailedService: DataProvider {
    func getDevices(atPage page: Int) -> AnyPublisher<DevicesResponse, APIError> {
        return Fail(error: APIError.serverSideError(500)).eraseToAnyPublisher()
    }
}
