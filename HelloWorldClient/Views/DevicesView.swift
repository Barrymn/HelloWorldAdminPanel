//
//  ContentView.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-08.
//

import SwiftUI

struct DevicesView: View {
    @ObservedObject var viewModel: DevicesViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Admin: \(viewModel.adminName)")
                Spacer()
            }
            
            ZStack {
                if !viewModel.devices.isEmpty {
                    DeviceList(devices: viewModel.devices,
                               canLoadMore: viewModel.canLoadMore,
                               isLoading: viewModel.isLoading,
                               onLoadMoreTapped: {
                        viewModel.loadMoreDevices()
                    })
                } else {
                    ProgressView()
                        .frame(width: 50, height: 50, alignment: .center)
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("Something Went Wrong"),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("Retry")) {
                viewModel.loadMoreDevices()
            })
        }
        .onAppear {
            viewModel.loadMoreDevices()
        }
    }
}
