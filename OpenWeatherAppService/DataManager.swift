//
//  Resource.swift
//  OpenWeatherAppService
//
//  Created by Curtis Wiseman on 12/9/20.
//

import Foundation

enum RequestError: Error {
    case networkFailure
    case invalidReturnedJSON
    case unknownError
}

final class DataManager {
    typealias WeatherDataCompletion = (WeatherData?, RequestError?) -> ()

    // MARK: - Properties

    private let baseURL: URL

    // MARK: - Initialization

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    // MARK: - Requesting Data

    func weatherDataForLocation(latitude: Double, longitude: Double, completion: @escaping WeatherDataCompletion) {
        var parameters: [String: Any] {
            return [
                "lat": latitude,
                "lon": longitude,
                "exclude": "minutely,hourly,daily,alerts",
                "units": "imperial",
                "appid": API.APIKey
            ]
        }
        var urlComponent = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponent?.queryItems = parameters.map {
            return URLQueryItem(name: $0.key, value: "\($0.value)")
        }

        // Create Data Task
        URLSession.shared.dataTask(with: urlComponent!.url!) { (data, response, error) in
            DispatchQueue.main.async {
                self.didFetchWeatherData(data: data, response: response, error: error, completion: completion)
            }
        }.resume()
    }

    // MARK: - Helper Methods

    private func didFetchWeatherData(data: Data?, response: URLResponse?, error: Error?, completion: WeatherDataCompletion) {
        if let _ = error {
            completion(nil, .networkFailure)

        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    // Decode JSON
                    let weatherData: WeatherData = try JSONDecoder().decode(WeatherData.self, from: data)

                    // Invoke Completion Handler
                    completion(weatherData, nil)

                } catch {
                    // Invoke Completion Handler
                    completion(nil, .invalidReturnedJSON)
                }

            } else {
                completion(nil, .unknownError)
            }

        } else {
            completion(nil, .unknownError)
        }
    }
}
//https://api.openweathermap.org/data/2.5/onecall?lat={lat}&lon={lon}&exclude={part}&"appid"={API key}
