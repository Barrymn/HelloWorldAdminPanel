//
//  Devices.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-09.
//

import Foundation

struct DevicesResponse: Decodable {
    let devices: [Device]
    let totalPages: Int
}
