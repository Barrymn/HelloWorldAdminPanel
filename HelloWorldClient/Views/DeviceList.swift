//
//  DeviceList.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-09.
//

import SwiftUI

struct DeviceList: View {
    let devices: [Device]
    let canLoadMore: Bool
    let isLoading: Bool
    var onLoadMoreTapped: () -> Void
    
    /// Search
    @State private var searchQuery = ""
    var filteredDevices: [Device] {
        guard !searchQuery.isEmpty else {
            return devices
        }
        return devices.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredDevices) { device in
                    HStack {
                        Text(String(device.id))
                            .frame(width: 50, alignment: .leading)
                        Spacer()
                        Text(device.name)
                            .frame(width: 300, alignment: .leading)
                        Spacer()
                        Text(device.latestScanDate)
                            .frame(width: 200, alignment: .leading)
                        Spacer()
                        Text(device.code)
                            .frame(width: 100, alignment: .leading)
                    }
                    .font(.system(size: 16))
                }
                
                HStack {
                    Spacer()
                    if isLoading {
                        ProgressView()
                            .frame(width: 25, height: 25, alignment: .center)
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(0.75, anchor: .center)
                    } else {
                        if canLoadMore {
                            Button(action: loadMore) {
                                Text("Load more")
                            }
                        } else {
                            Text("No more devices")
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
            }
            .searchable(text: $searchQuery, placement: .automatic, prompt: "Search name")
        }
    }
    
    private func loadMore() {
        onLoadMoreTapped()
    }
}
