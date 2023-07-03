//
//  LocationViewModel.swift
//  amazing_world
//
//  Created by 冯天宇 on 2023/6/28.
//

import Foundation
import CoreLocation
import RxRelay

class LocationInfoViewModel: NSObject {
    
    var angleChangedRelay: BehaviorRelay<Double> = BehaviorRelay(value: 0.0)
    var altitudeRelay: BehaviorRelay<Double> = BehaviorRelay(value: 0.0)
    var coordinateRelay: BehaviorRelay<(String, String)> = BehaviorRelay(value: ("", ""))
    var addressRelay = BehaviorRelay(value: (""))
    
    private let locationManager =  CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 1 // 移动1米之后触发回调
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        locationManager.allowsBackgroundLocationUpdates = true // 允许后台更新
    }
    
    func startRequest() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationInfoViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("地理北极：\(newHeading.trueHeading)  地磁北极：\(newHeading.magneticHeading)")
        let angle = newHeading.magneticHeading
        angleChangedRelay.accept(angle)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        
        // 获取海拔信息
        let altitude = currentLocation.altitude
        print("海拔 \(altitude)")
        altitudeRelay.accept(altitude)
        
        let longitude = currentLocation.coordinate.longitude
        let longitudeValue = String(format: "N%.1f", longitude)
        let latitude = currentLocation.coordinate.latitude
        let latitudeValue = String(format: "E%.1f", latitude)
        coordinateRelay.accept((longitudeValue, latitudeValue))
        print("经纬 \(longitudeValue) \(latitudeValue)")
        
        parseAddress(location: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error)")
    }
    
    func parseAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, err in
            guard let placemark = placemarks?.first else {
                return
            }
            let city = placemark.locality ?? ""
            let area = placemark.subLocality ?? ""
            let street = placemark.thoroughfare ?? ""
            let address = city + area + street
            self?.addressRelay.accept(address)
        }
    }
    
}
