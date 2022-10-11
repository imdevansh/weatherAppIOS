//
//  WeatherData.swift
//  Clima
//
//  Created by GGS-BKS on 29/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData: Decodable{
    let name: String
    let main: Main
    let weather: [Weather]
    let wind:Wind
}
struct Weather:Decodable{
    let description: String
    let id: Int
    
}
struct Wind:Decodable {
    let speed: Double
    let deg: Double
}

struct Main: Decodable{
    let temp: Double
}
