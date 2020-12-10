//
//  AddLocationViewModel.swift
//  OpenWeatherAppService
//
//  Created by Curtis Wiseman on 12/9/20.
//

import CoreLocation
import Foundation

final class AddLocationViewModel {

    // MARK: - Properties

    var querying: ((Bool) -> Void)? = nil
    var receiveWeatherData: ((WeatherDataViewModel?) -> Void)?
    
    var searchQuery: String? {
        didSet {
            geocode(queryString: searchQuery)
        }
    }
    
    private var weatherViewModel: WeatherDataViewModel? {
        didSet {
            if let completion = receiveWeatherData {
                return completion(weatherViewModel)
            }
        }
    }
    
    private lazy var dataManager: DataManager = {
        let dataManager = DataManager(baseURL: API.BaseURL)
        return dataManager
    }()

    private lazy var geocoder = CLGeocoder()

    init() {
    }

    // MARK: - Helper Methods

    private func geocode(queryString: String?) {
        guard let addressString = queryString, !addressString.isEmpty else {
            weatherViewModel = nil
            return
        }

        querying?(true)
        
        let locationCompletion: ((CLPlacemark?, Error?) -> Void) = { [weak self] placeMark, error in
            if let _ = error {
                self?.weatherViewModel = nil
            } else if let placeMark = placeMark, let cityName = placeMark.locality, let location = placeMark.location {
                self?.fetchLocationTemperature(
                    latitue: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                ) { [weak self] result, error in
                    DispatchQueue.main.async {
                        self?.querying?(false)
                        self?.weatherViewModel = WeatherDataViewModel(temperature: result?.current.temp, city: cityName)
                    }
                }
            }
        }

        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if let error = error {
                print("Unable to Forward Geocode Address (\(error))")
                locationCompletion(nil, error)

            } else if let _placemarks = placemarks?.first {
                locationCompletion(_placemarks, nil)
            }
        }
    }
    
    private func fetchLocationTemperature(
        latitue: Double,
        longitude: Double,
        completionsHandler: @escaping ((WeatherData?, RequestError?) -> ())
    ) {
        dataManager.weatherDataForLocation(
            latitude: latitue,
            longitude: longitude,
            completion: completionsHandler
        )
    }
}
