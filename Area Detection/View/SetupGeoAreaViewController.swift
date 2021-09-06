//
//  SetupGeoAreaViewController.swift
//  Area Detection
//
//  Created by 2018MAC04 on 04/09/2021.
//

import UIKit
import MapKit
import CoreLocation

class SetupGeoAreaViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusTextField: UITextField!
    
    @IBOutlet weak var wifiLabel: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Setup Geofence Area"
        
        setupLocation()
        setupMap()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func setupMap(){
        mapView.delegate = self
        mapView.showsUserLocation = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doPointGeofenceArea))
        mapView.addGestureRecognizer(tap)
        
        if getLongtitude() == -1 || getLatitude() == -1{
            if let coordinate = locationManager.location?.coordinate{
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200000, longitudinalMeters: 200000)
                mapView.setRegion(region, animated: true)
            }
        }else{
            let coordinate = CLLocationCoordinate2D(latitude: getLatitude(), longitude: getLongtitude())
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200000, longitudinalMeters: 200000)
            mapView.setRegion(region, animated: true)
        }
        addRadiusOverlay(latitude: getLatitude(), longtitude: getLongtitude())
    }
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    func addMapAnnotation(latitude: Double, longtitude: Double){
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)

        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(pin)
    }
    
    func addRadiusOverlay(latitude: Double, longtitude: Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        
        mapView.removeOverlays(mapView.overlays)
        mapView.addOverlay(MKCircle(center: coordinate, radius: 10000))
    }
    
    func checkLocationPermission(status: CLAuthorizationStatus){
        switch status{
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            let alertController = UIAlertController(
                title: "Location Permission Denied", message: "This app need permission for detect your location",
                preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                (action) in
            })
            alertController.addAction(cancelAction
            )
            self.present(alertController, animated: true, completion: nil)
            
        @unknown default:
            break
        }
    }
    
    //MARK:- Event Action
    @objc func dimissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func doPointGeofenceArea(gestureRecognizer: UIGestureRecognizer){
        let touchLocation = gestureRecognizer.location(in: mapView)
        let touchCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
//        setLocation(cordinate: touchCoordinate)
        addMapAnnotation(latitude: touchCoordinate.latitude, longtitude: touchCoordinate.longitude)
        addRadiusOverlay(latitude: touchCoordinate.latitude, longtitude: touchCoordinate.longitude)
    }
}

//MARK:- MKMapViewDelegate
extension SetupGeoAreaViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.lineWidth = 1.0
        renderer.strokeColor = .magenta
        renderer.fillColor = UIColor.magenta.withAlphaComponent(0.4)
        return renderer
    }
}

//MARK:- CLLocationManagerDelegate
extension SetupGeoAreaViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: getLatitude(), longitude: getLongtitude())

        let pin = MKPointAnnotation()
        pin.coordinate = location
        
        mapView.addAnnotation(pin)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
