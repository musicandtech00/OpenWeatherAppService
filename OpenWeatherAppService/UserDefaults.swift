//
//  UserDefaults.swift
//  OpenWeatherAppService
//
//  Created by Curtis Wiseman on 12/9/20.
//

import Foundation

struct UserDefaultsKeys {
    static let temperatureKey = "temperatureKey"
    static let cityKey = "cityKey"
}

extension UserDefaults {
    static func temperatureNotation() -> Double? {
        let storedValue = UserDefaults.standard.double(forKey: UserDefaultsKeys.temperatureKey)
        guard !storedValue.isZero else { return nil }
        return storedValue
    }

    static func setTemperatureNotation(temperature: Double) {
        UserDefaults.standard.set(temperature, forKey: UserDefaultsKeys.temperatureKey)
    }
    
    static func cityNotation() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.cityKey)
    }
    
    static func setCityNotation(city: String) {
        UserDefaults.standard.setValue(city, forKey: UserDefaultsKeys.cityKey)
    }
}
