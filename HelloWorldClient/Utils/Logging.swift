//
//  Logging.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-08.
//

import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!
    static let networking = Logger(subsystem: subsystem, category: "networking")
}
