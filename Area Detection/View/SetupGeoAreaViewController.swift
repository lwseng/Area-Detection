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
    var touchCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var settingRadius = getRadius()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Setup Geofence Area"
        
        setupView()
        setupLocation()
        setupMap()
    }
    
    func setupView(){
        radiusTextField.text = String(getRadius())
        radiusTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dimissKeyboard))
        self.view.addGestureRecognizer(tap)
        btnSave.addTarget(self, action: #selector(doBtnSave), for: .touchUpInside)
    }
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
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
    
    func setupMap(){
        mapView.delegate = self
        mapView.showsUserLocation = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doPointGeofenceArea))
        mapView.addGestureRecognizer(tap)
        
        //first time entry get user current location
        if getLongtitude() == -1 || getLatitude() == -1{
            if let coordinate = locationManager.location?.coordinate{
                setupRegion(latitude: coordinate.latitude, longtitude: coordinate.longitude, radius: getRadius())
                touchCoordinate = coordinate
            }
        }else{ //get setting coordinate
            setupRegion(latitude: getLatitude(), longtitude: getLongtitude(), radius: getRadius())
            touchCoordinate = CLLocationCoordinate2D(latitude: getLatitude(), longitude: getLongtitude())
        }
        addRadiusOverlay(mapView: mapView, latitude: getLatitude(), longtitude: getLongtitude(), radius: getRadius())
    }
    
    //show area in map
    func setupRegion(latitude: Double, longtitude: Double, radius: Double){
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: radius, longitudinalMeters: radius * 15)
        mapView.setRegion(region, animated: true)
    }
        
    //MARK:- Event Action
    @objc func dimissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func doPointGeofenceArea(gestureRecognizer: UIGestureRecognizer){
        let touchLocation = gestureRecognizer.location(in: mapView)
        touchCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        addMapAnnotation(mapView: mapView, latitude: touchCoordinate.latitude, longtitude: touchCoordinate.longitude)
        addRadiusOverlay(mapView: mapView, latitude: touchCoordinate.latitude, longtitude: touchCoordinate.longitude, radius: settingRadius)
    }
    
    @objc func doBtnSave(){
        setLocation(cordinate: touchCoordinate)
        setRadius(radius: settingRadius)
        
        let alertController = UIAlertController(
            title: "", message: "Setting Updated",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            (action) in
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
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

//MARK:- UITextFieldDelegate
extension SetupGeoAreaViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if let text = textField.text{
            guard let radius = Double(text) else { return }
            
            settingRadius = radius
            addRadiusOverlay(mapView: mapView, latitude: touchCoordinate.latitude, longtitude: touchCoordinate.longitude, radius: settingRadius)
            setupRegion(latitude: touchCoordinate.latitude, longtitude: touchCoordinate.longitude, radius: settingRadius)
        }
    }
}
