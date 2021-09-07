//
//  utilities.swift
//  Area Detection
//
//  Created by 2018MAC04 on 06/09/2021.
//

import Foundation
import CoreLocation

func setLocation(cordinate: CLLocationCoordinate2D){
    UserDefaults.standard.setValue(cordinate.longitude, forKey: "longtitude")
    UserDefaults.standard.setValue(cordinate.latitude, forKey: "latitude")
}

func getLongtitude() -> Double{
    if let longtitude = UserDefaults.standard.value(forKey: "longtitude") as? Double{
        return longtitude
    }
    return -1
}

func getLatitude() -> Double{
    if let latitude = UserDefaults.standard.value(forKey: "latitude") as? Double{
        return latitude
    }
    return -1
}

func setRadius(radius: Double){
    UserDefaults.standard.setValue(radius, forKey: "radius")
}

func getRadius() -> Double{
    if let radius = UserDefaults.standard.value(forKey: "radius") as? Double{
        return radius
    }
    return 100
}
