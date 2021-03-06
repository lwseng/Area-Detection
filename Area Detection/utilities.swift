//
//  utilities.swift
//  Area Detection
//
//  Created by 2018MAC04 on 06/09/2021.
//

import Foundation
import CoreLocation
import MapKit
import SystemConfiguration.CaptiveNetwork

func setLocation(cordinate: CLLocationCoordinate2D){
    UserDefaults.standard.setValue(cordinate.longitude, forKey: "longtitude")
    UserDefaults.standard.setValue(cordinate.latitude, forKey: "latitude")
}

func getLongtitude() -> Double{
    if let longtitude = UserDefaults.standard.value(forKey: "longtitude") as? Double{
        return longtitude
    }
    return 999
}

func getLatitude() -> Double{
    if let latitude = UserDefaults.standard.value(forKey: "latitude") as? Double{
        return latitude
    }
    return 999
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

//show map radius overlay
func addRadiusOverlay(mapView: MKMapView, latitude: Double, longtitude: Double, radius: Double) {
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    
    mapView.removeOverlays(mapView.overlays)
    mapView.addOverlay(MKCircle(center: coordinate, radius: radius))
}

//show map annotation
func addMapAnnotation(mapView: MKMapView, latitude: Double, longtitude: Double){
    let pin = MKPointAnnotation()
    pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)

    mapView.removeAnnotations(mapView.annotations)
    mapView.addAnnotation(pin)
}

//store wifi setting info
func setWifiInfo(key: String, data: String){
    if key == "SSID"{
        UserDefaults.standard.setValue(data, forKey: "wifiname")
    }else if key == "BSSID"{
        UserDefaults.standard.setValue(data, forKey: "wifidata")
    }
}


func getWifiInfo(key: String) -> String{
    if key == "SSID"{
        if let wifiName = UserDefaults.standard.value(forKey: "wifiname") as? String{
            return wifiName
        }
    }else if key == "BSSID"{
        if let wifiData = UserDefaults.standard.value(forKey: "wifidata") as? String{
            return wifiData
        }
    }
    return "-"
}

func getDeviceWifiInfo(key: String) -> String{
    guard let interfaces = CNCopySupportedInterfaces() as? [String] else { return "-" }
    for interface in interfaces {
        guard let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as NSDictionary? else { continue }
        return interfaceInfo[key] as? String ?? "No network"
    }
    return "No network"
}
