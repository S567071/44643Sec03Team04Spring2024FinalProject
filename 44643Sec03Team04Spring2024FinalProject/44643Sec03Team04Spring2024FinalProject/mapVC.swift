//
//  mapVC.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Pranathi Reddy Jeedipally on 4/18/24.
//

import UIKit
import CoreLocation
import MapKit

class mapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var locMV: MKMapView!
    
    @IBOutlet weak var locationLBL: UILabel!
    
    var locationManager = CLLocationManager()
    var productLocation: String?
    var productCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupMapView()
        setupProductLocation()
    }
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func setupMapView() {
        locMV.delegate = self
    }
    
    func setupProductLocation() {
        guard let productLocation = productLocation else {
            print("Product location is nil")
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(productLocation) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first, let coordinates = placemark.location?.coordinate {
                self.productCoordinates = coordinates
//                self.centerMapOnLocation(coordinates)
                self.addPinAnnotation(coordinates)
                self.updateLocationLabel(placemark)
            } else {
                print("No coordinates found for the provided address")
            }
        }
    }
    
//    func centerMapOnLocation(_ coordinates: CLLocationCoordinate2D) {
//        let regionRadius: CLLocationDistance = 10000// Adjust as needed
//        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//        locMV.setRegion(region, animated: true)
//    }
    
    func addPinAnnotation(_ coordinates: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        locMV.addAnnotation(annotation)
    }
    
    func updateLocationLabel(_ placemark: CLPlacemark) {
        let distanceInMiles = self.calculateDistanceInMiles(userLocation: nil)
        print("Distance: \(distanceInMiles)") // Add this line for debugging
        self.locationLBL.text = "\(placemark.name ?? "")"
    }
    
    
    func calculateDistanceInMiles(userLocation: CLLocation?) -> String {
        guard let userLocation = userLocation ?? locationManager.location, let productCoordinates = self.productCoordinates else { return "" }
        let productLocation = CLLocation(latitude: productCoordinates.latitude, longitude: productCoordinates.longitude)
        let distance = userLocation.distance(from: productLocation)
        let distanceInMiles = Measurement(value: distance / 1609.34, unit: UnitLength.miles)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        return formatter.string(from: distanceInMiles)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        
        // Calculate distance from user's current location to product location
        let distanceInMiles = self.calculateDistanceInMiles(userLocation: userLocation)
        
        // Only update the label if the distance has changed significantly
        if let currentText = self.locationLBL.text, !currentText.contains(distanceInMiles) {
            self.locationLBL.text = "\(currentText) - \(distanceInMiles) away"
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let coordinate = view.annotation?.coordinate {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            mapItem.name = "Destination"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
}
