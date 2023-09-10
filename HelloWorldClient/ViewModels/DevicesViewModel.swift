//
//  DevicesViewModel.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-08.
//

import Foundation
import Combine
import OSLog

class DevicesViewModel: ObservableObject {
    let dataProvider: DataProvider
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var devices: [Device] = []
    @Published private(set) var isLoading = false
    @Published var hasError = false
    
    private var currentPage = 0
    private var totalPages = 0
    private(set) var errorMessage = ""
    
    var canLoadMore: Bool {
        currentPage < totalPages
    }
    
    lazy var adminName: String = {
        String(cString: get_name())
    }()
    
    init(dataProvider: DataProvider = DevicesService()) {
        self.dataProvider = dataProvider
    }
    
    func loadMoreDevices() {
        currentPage += 1
        getDevices(atPage: currentPage)
    }
    
    func getDevices(atPage page: Int) {
        isLoading = true
        
        dataProvider.getDevices(atPage: page)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] result in
                self?.isLoading = false
                
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.description
                    self?.hasError = true
                    self?.currentPage -= 1
                }
            }, receiveValue: { [weak self] (devicesResponse: DevicesResponse) in
                Logger.networking.info("✅ Devices fetched successfully")
                self?.isLoading = false
                self?.devices += devicesResponse.devices
                self?.totalPages = devicesResponse.totalPages
            })
            .store(in: &self.cancellables)
    }
}
