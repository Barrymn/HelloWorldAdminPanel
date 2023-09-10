//
//  MockDevicesService.swift
//  HelloWorldClientTests
//
//  Created by Barry Ma on 2023-09-10.
//

import Foundation
import Combine
@testable import HelloWorldClient

struct DevicesMockService: DataProvider {
    func getDevices(atPage page: Int) -> AnyPublisher<DevicesResponse, APIError> {
        let device = Device(id: 1111, name: "Barry", code: "ABCDEF")
        let devices = Array(repeating: device, count: 100)
        let devicesResponse = DevicesResponse(devices: devices, totalPages: 10)
        
        return Just(devicesResponse)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
