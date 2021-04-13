//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Kuliza-277 on 12/04/21.
//  Copyright © 2021 Pratice. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: WeatherMainData
    let weather : [Weather]
}
struct WeatherMainData: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
