//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://api.blockchain.com/v3/exchange/l2/BTC-"
    let apiKey = "17b03302-437a-446f-afce-a521380555ba"
    
    let currencyArray2 = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencyArray = ["EUR","GBP","USD"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        perfomRequest(with: urlString)
    }
    
    func perfomRequest(with urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        delegate?.didUpdatePrice(self, coinModel: coin)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ blockChainData: Data) -> CoinModel? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(CoinData.self, from: blockChainData)
            let price = decodedData.asks[0].px
            let currency = decodedData.symbol.split(separator: "-").last!
            let coinModel = CoinModel(price: price, currency: String(currency))
            return coinModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
