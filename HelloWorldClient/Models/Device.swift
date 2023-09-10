//
//  Device.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-08.
//

import Foundation


struct Device: Identifiable, Decodable {
    let id: Int
    let name: String
    let code: String
    private let latestScanDateString: String?
    
    init(id: Int, name: String, code: String) {
        self.id = id
        self.name = name
        self.code = code
        self.latestScanDateString = "N/A"
    }
    
    var latestScanDate: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let dateString = latestScanDateString,
           let date = dateFormatterGet.date(from: dateString) {
            return dateFormatterPrint.string(from: date)
        } else {
           return "N/A"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, code
        case latestScanDateString = "latestScanDate"
    }
}
