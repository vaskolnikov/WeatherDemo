//
//  SplashViewController.swift
//  WeatherDemo
//
//  Created by Adem Özsayın on 27.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import CoreLocation

class SplashViewController: UIViewController {
    
    var networkManager: NetworkManager!
    var loader: UIActivityIndicatorView!
    var userLocation: CLLocation?

    init(networkManager: NetworkManager) {
          super.init(nibName: nil, bundle: nil)
          self.networkManager = networkManager
      }

      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = App.appColor
        loader = UIActivityIndicatorView()
        loader.center = view.center
        loader.style = .gray
        loader.color = .black
        loader.startAnimating()
        
        view.addSubview(loader)

        LocationManager.shared.locationDelegate = self
        LocationManager.shared.getLocation()
        
    }
    
    func showAlert() {
      let alert = UIAlertController(title: "Konum ayarlarini ac", message:"", preferredStyle: .alert)

        alert.addAction(title: "Evet") {
            SPApp.open(app: .setting)
        }
        alert.addAction(UIAlertAction(title: "Hayir", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    func goDashBoard(location: CLLocation) {
        delay(0.5) {
            self.loader.stopAnimating()
            let vc  = WeatherViewController(networkManager:self.networkManager)
            vc.fethcWeather(location)
            self.navigationController?.pushViewController(vc, animated: true)
            //return

         }

    }
}

extension SplashViewController : locationFetched {
     @objc func locationManagerStatus(status: CLAuthorizationStatus) {
        
        if (status == .authorizedAlways)  || ( status == .authorizedWhenInUse ) {
            //goDashBoard(location: userLocation!)

        } else {
            showAlert()
        }
    }

    
    @objc func locationAddressString(locationFetched: String, lat: CLLocationDegrees, lon: CLLocationDegrees) {
        if let location = LocationManager.shared.currentLocation,  LocationManager.shared.currentLocation != nil {
            self.userLocation = location
            goDashBoard(location: location)
            return

        }
    }
}
