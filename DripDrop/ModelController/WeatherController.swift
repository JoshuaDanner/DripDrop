//
//  WeatherController.swift
//  DripDrop
//
//  Created by Joshua Danner on 9/8/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherController {
    
    static let shared = WeatherController()
    private init() {}
    
    var dailyWeathers: [DailyWeather]?
    var currentWeather: CurrentWeather?
    var locationmanager = CLLocationManager()
    let baseURL = URL(string: "https://api.darksky.net/forecast/")
    let apiSecret = "e5eced4e1dcea1092692c4b9984d9a25"
    
    func fetchWeeklyWeather(latitude: Double, longitude: Double, completion: @escaping (([DailyWeather]?) -> Void))   {
        
        
        // Somewhere the user can write code after a function is done doing what it does (completion handeler) completion handler is like a return, it defines what you
        // A completin hander is: its just some space that you can write code later when the code is done running.  It is a function taking in another function as a parameter. It will be written in later
        
        // Two steps to fetching data
        // 1) Getting your URL right (putting it together)
        guard let baseUrl = baseURL else {completion(nil) ; return }
        var url = baseUrl.appendingPathComponent(apiSecret)
        url.appendPathComponent("\(latitude), \(longitude)")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "exclude", value: "[minutely,hourly,alerts,flags]")]
        
        guard let finishedUrl = components?.url else {completion(nil) ; return }
        
        print(finishedUrl.absoluteString) // This prints the entire complete URL
        
        // 2) Calling the DataTask step 2.5(Decoding your data)
        
         // After you fetch the data from the url the completion handler says what we need to do with the data
        URLSession.shared.dataTask(with: url) { (data, response, error) in // The "response" is like the 404 error
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                    completion(nil)
                    return
                    }
            
            print("\(response ?? URLResponse())")
            
            guard let data = data else { completion(nil) ; return }
            
            let decoder = JSONDecoder()
            do {
                let weatherService = try decoder.decode(WeatherService.self, from: data)
                let dailyWeathers = weatherService.weeklyWeatherData.data  // One way
                self.currentWeather = weatherService.currently
                self.dailyWeathers = dailyWeathers  // The other way (they both work, Trevor just wanted to show us both)
                completion(dailyWeathers)
                
            } catch {
                print("There was an error in \(#function) : \(error) \(error.localizedDescription)")
                completion(nil) // Always call this
            }
        }.resume()
    }
}







// Append path component actually changes the baseURL we need the appendingPathComponent to append to the base url

// URLSESSION is a huge interview question: How do you do a network call?  The answer is URLSessions!!
// Suite of methods used for networking
// Read the URLSession overview in Dash to get good for interview questions








