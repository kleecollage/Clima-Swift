//
//  BlockChainModel.swift
//  ByteCoin
//
//  Created by Antonio Hernández Santander on 08/01/26.
//  Copyright © 2026 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let symbol: String
    let bids: [Bid]
    let asks: [Ask]
}

struct Bid: Codable {
    let px: Double
    let qty: Double
    let num: Int
}

struct Ask: Codable {
    let px: Double // This is the one we need
    let qty: Double
    let num: Int
}
