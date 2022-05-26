//
//  Stock.swift
//  InAccessibility
//
//  Created by Jordi Bruin on 19/05/2022.
//

import Foundation

struct Stock: Identifiable {
    let id = UUID()
    let name: String
    let stockPrice: Double
    let shortName: String
    let goingUp: Bool
    let favorite: Bool
    let change: Double
    
    
    init(name: String, shortName: String, favorite: Bool) {
        self.name = name
        self.shortName = shortName
        self.favorite = favorite
        
        let price = Double.random(in: 45.13...759.24)
        self.stockPrice = price
        
        let goingUp = Bool.random()
        self.goingUp = goingUp
        
        self.change = goingUp ? Double.random(in: 3.12...149.44) : -Double.random(in: 3.00...149.34)
        
    }
    
    static func example() -> Stock {
        Stock(name: "Apple", shortName: "AAPL", favorite: false)
    }
    
    static func favorites() -> [Stock] {
        [
            Stock(name: "Apple", shortName: "AAPL", favorite: true),
            Stock(name: "Google", shortName: "GOOG", favorite: true),
            Stock(name: "Nintendo", shortName: "NNTD", favorite: true),
            Stock(name: "Vivid", shortName: "VVID", favorite: true),
            Stock(name: "Oil Co", shortName: "OILC", favorite: true),
        ]
    }
    
    static func all() -> [Stock] {
        [
            Stock(name: "Meta", shortName: "FB", favorite: false),
            Stock(name: "Snapchat", shortName: "SNAP", favorite: false),
            Stock(name: "Uber", shortName: "UBER", favorite: false),
            Stock(name: "Twitter", shortName: "TWTR", favorite: false),
            Stock(name: "Amazon", shortName: "AMZN", favorite: false),
            Stock(name: "Spotify", shortName: "SPOT", favorite: false),
            Stock(name: "Disney", shortName: "DIS", favorite: false),
            Stock(name: "Microsoft", shortName: "MSFT", favorite: false),
            Stock(name: "Netflix", shortName: "NFLX", favorite: false),
            Stock(name: "Zoom", shortName: "ZM", favorite: false),
        ]
    }
}
