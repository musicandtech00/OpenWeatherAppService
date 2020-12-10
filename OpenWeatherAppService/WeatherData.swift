//
//  WeatherData.swift
//  OpenWeatherAppService
//
//  Created by Curtis Wiseman on 12/9/20.
//

import Foundation

struct WeatherData: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temp: Double
}

struct WeatherDataViewModel {
    let temperature: Double?
    let city: String?
}
