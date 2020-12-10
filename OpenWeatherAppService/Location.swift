//
//  Location.swift
//  OpenWeatherAppService
//
//  Created by Curtis Wiseman on 12/9/20.
//

import Foundation
import CoreLocation

struct Location {

    private enum Keys {

        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"

    }

    let name: String
    let latitude: Double
    let longitude: Double

    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    var asDictionary: [String: Any] {
        return [ Keys.name: name,
                 Keys.latitude : latitude,
                 Keys.longitude: longitude ]
    }

}
