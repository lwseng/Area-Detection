//
//  AreaDetectionViewController.swift
//  Area Detection
//
//  Created by 2018MAC04 on 04/09/2021.
//

import UIKit
import MapKit

class AreaDetectionViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var geoLatitudeLabel: UILabel!
    @IBOutlet weak var geoLatitudeData: UILabel!
    
    @IBOutlet weak var geoLongtitudeLabel: UILabel!
    @IBOutlet weak var geoLongtitudeData: UILabel!
    
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusData: UILabel!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var latitudeData: UILabel!
    
    @IBOutlet weak var longtitudeLabel: UILabel!
    @IBOutlet weak var longtitudeData: UILabel!
    
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var wifiData: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusData: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupInfo()
        addMapAnnotation(mapView: mapView, latitude: getLatitude(), longtitude: getLongtitude())
    }
    
    func setupView(){
        let topRightButton = UIButton()
        topRightButton.setImage(UIImage(named: "icn-setting"), for: .normal)
        topRightButton.addTarget(self, action: #selector(doBtnSetupGeoArea), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: topRightButton)
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    func setupInfo(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        if let coordinate = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: getRadius(), longitudinalMeters: 150000)
            mapView.setRegion(region, animated: true)
            mapView.delegate = self
            
            latitudeData.text = String(coordinate.latitude)
            longtitudeData.text = String(coordinate.longitude)
        }
        addRadiusOverlay(mapView: mapView, latitude: getLatitude(), longtitude: getLongtitude(), radius: getRadius())
        
        geoLatitudeData.text = String(getLatitude())
        geoLongtitudeData.text = String(getLongtitude())
        radiusData.text = String(getRadius())
        statusData.text = checkStatus()
        statusData.textColor = checkStatus() == "Inside Area" ? UIColor.green : checkStatus() == "Outside Area" ? UIColor.red : UIColor.brown
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
    
    func checkStatus() -> String{
        let coordinate = CLLocationCoordinate2D(latitude: getLatitude(), longitude: getLongtitude())
        let region = CLCircularRegion(center: coordinate, radius: getRadius(), identifier: "")
        
        if let coordinate = locationManager.location?.coordinate {
            if region.contains(coordinate) {
                return "Inside Area"
            }else{
                return "Outside Area"
            }
        }else{
            return "Location Permission Denied"
        }
    }
    
    @objc func doBtnSetupGeoArea(){
        let vc = SetupGeoAreaViewController(nibName: "SetupGeoAreaViewController", bundle: nil)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AreaDetectionViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.lineWidth = 1.0
        renderer.strokeColor = .magenta
        renderer.fillColor = UIColor.magenta.withAlphaComponent(0.4)
        return renderer
    }
}

//MARK:- CLLocationManagerDelegate
extension AreaDetectionViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationPermission(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
