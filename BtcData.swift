//
//  BtcData.swift
//  btc
//
//  Created by Hasan onur Can on 15.02.2022.
//

import Foundation
struct BtcData: Codable{
    let data: [Dataa]
}
struct Dataa: Codable{
    let id: Int
    let symbol: String
    let quote: Quote
    struct Quote: Codable {
        let usd: Usd

        enum CodingKeys: String, CodingKey {
            case usd = "USD"
        }
    }
    struct Usd: Codable {
        let price: Double
        let percent_change_24h: Double?
        
       

    }
}
