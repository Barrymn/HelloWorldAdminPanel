//
//  HelloWorldClientTests.swift
//  HelloWorldClientTests
//
//  Created by Barry Ma on 2023-09-08.
//

import XCTest
import Combine
@testable import HelloWorldClient

final class DevicesViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()

    override func tearDownWithError() throws {
        cancellables = []
    }

    func testDataAssignments() throws {
        let viewModel = DevicesViewModel(dataProvider: DevicesMockService())
        XCTAssertEqual(viewModel.devices.count, 0)
        viewModel.loadMoreDevices()
        
        let promise = expectation(description: "fetch 100 devices")
        viewModel.$devices
            .sink { completion in
            XCTFail()
        } receiveValue: { devices in
            if devices.count == 100 {
                promise.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [promise], timeout: 0.1)
    }
    
    func testServerFailure() throws {
        let viewModel = DevicesViewModel(dataProvider: DevicesMockFailedService())
        XCTAssertFalse(viewModel.hasError)
        XCTAssertEqual(viewModel.errorMessage, "")
        viewModel.loadMoreDevices()
        
        let promise = expectation(description: "Server error is captured and displayed")
        viewModel.$hasError
            .sink { completion in
            XCTFail()
        } receiveValue: { hasError in
            if hasError && viewModel.errorMessage == "Server-side error 500 occured." {
                promise.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [promise], timeout: 0.1)
    }
}
