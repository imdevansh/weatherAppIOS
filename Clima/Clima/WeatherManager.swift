//
//  WeatherManager.swift
//  Clima
//
//  Created by GGS-BKS on 26/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=efd40219e4d2b72531b33183547bdaf6&units=metric"
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    var delegate: WeatherManagerDelegate?
    func performRequest(urlString: String){
        //1 Create the url
        if  let url = URL(string: urlString){
            
            //Step=2 Create Url session
            let session = URLSession(configuration: .default)
            //Step=3 Give session a task
            
            let task = session.dataTask(with: url) { data, response, error in // closure
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                    
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(weather:weather)
                    }
                    
                }
            }
            // Step4: start the task
            task.resume()
            
            
        }
    }
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = (decodedData.weather[0].id)
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, city: name, temperature: temp)
            
            print(weather.conditionName)
            print(weather.temperatureString)
            return weather
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

