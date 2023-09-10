//
//  HelloWorldClientApp.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-08.
//

import SwiftUI

@main
struct HelloWorldClientApp: App {
    var body: some Scene {
        WindowGroup {
            DevicesView(viewModel: DevicesViewModel())
        }
    }
}
