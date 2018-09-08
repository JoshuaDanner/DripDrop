//
//  WeatherViewController.swift
//  DripDrop
//
//  Created by Joshua Danner on 9/8/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    var currentLocation: CLLocation? {
        didSet {
            fetchWeather()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherController.shared.dailyWeathers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell
        let dailyWeather = WeatherController.shared.dailyWeathers?[indexPath.row]
        cell?.dailyWeather = dailyWeather
        return cell ?? UICollectionViewCell()
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            fetchWeather()
            
            WeatherController.shared.locationmanager.delegate = self
            WeatherController.shared.locationmanager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        }
    }
    
    func updatecurrentWeather() {
        cityLabel.text = "Salt Lake city"
        summaryLabel.text = WeatherController.shared.currentWeather?.summary
        temperatureLabel.text = "\(WeatherController.shared.currentWeather?.temperature ?? 0)"
    }
    func fetchWeather() {  // Part 1 gives us an array of DailyWeather  from our copletion handler, then part two
        //       guard let latitude = currentLocation?.coordinate.latitude,
        //        let longitude = currentLocation?.coordinate.longitude else { return }
        
        WeatherController.shared.fetchWeeklyWeather(latitude: 40.7608, longitude: -111.891) { (_) in
            DispatchQueue.main.async {
                
                self.weatherCollectionView.reloadData() // we add the self because it is in a closure
                self.updatecurrentWeather()
            }
        }
    }
    
    func locationManager( manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
