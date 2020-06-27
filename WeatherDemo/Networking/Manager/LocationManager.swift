//
// LocationManager.swift
// WeatherDemo
//
//  Created by Adem Özsayın on 26.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//
import UIKit
import CoreLocation


protocol locationFetched : class{
    func locationAddressString(locationFetched:String, lat: CLLocationDegrees, lon: CLLocationDegrees)
    func locationManagerStatus(status: CLAuthorizationStatus)
}

class LocationManager: NSObject {
    
    //typealias JSONDictionary = [String:Any]
    @objc static let shared = LocationManager()
    static var locationCoordinates : CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    var locationDelegate : locationFetched?
    var currentLocation : CLLocation!
    
}

extension LocationManager : CLLocationManagerDelegate{

    func getLocation(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.requestLocation()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else{
            #if DEBUG
                print("not enabled locstion services")
            #endif
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationManager.stopUpdatingLocation()
        self.currentLocation = locationManager.location
        if self.currentLocation != nil {
            self.getAdress { (jsonDict, error) in
                if error != nil {

                } else {
                    //let classObj = LocationOrganizer(jsonDict: jsonDict!)
                    let classObj = LocationOrganizer(str: jsonDict!)

                    self.locationDelegate?.locationAddressString(locationFetched: classObj.locationString, lat: self.currentLocation.coordinate.latitude, lon: self.currentLocation.coordinate.longitude)
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if DEBUG
            print(" locationManager location \(error.localizedDescription)")
        #endif
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           switch status {
           case .restricted:
               print("Location access was restricted.")
               self.locationDelegate?.locationManagerStatus(status: status)
           case .denied:
                     print("User denied access to location.")
                     self.locationDelegate?.locationManagerStatus(status: status)
           case .notDetermined:
               print("Location status not determined.")
            self.locationDelegate?.locationManagerStatus(status: status)
           case .authorizedAlways: fallthrough
           case .authorizedWhenInUse:
               print(" case authorizedWhenInUse")
           @unknown default:
            fatalError()
        }
       }
    


    func getAdress(completion: @escaping (_ address: String?, _ error: Error?) -> ()){
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(self.currentLocation) { placemarks, error in

                if let e = error{
                    completion(nil, e)
                } else {
                    let placeArray = placemarks
                    var placemark: CLPlacemark!
                    placemark = placeArray?[0]
//
                    let street = placemark.thoroughfare != nil ? placemark.thoroughfare!  : ""
                    let city =  placemark.subAdministrativeArea != nil  ?  placemark.subAdministrativeArea! : ""
                    let state = placemark.administrativeArea != nil ? placemark.administrativeArea! : ""
                    let zip =  placemark.isoCountryCode != nil ? placemark.administrativeArea! : ""
                    let country = placemark.country != nil ? placemark.administrativeArea! : ""
//
                    let address = "\(street) \(city) \(state)  \(zip) \(country) "
                    completion(address, nil)
                }
            }
        }
    }

class LocationOrganizer {
    var locationString : String!

    init(str: String) {
         self.locationString = str
     }
   

}

