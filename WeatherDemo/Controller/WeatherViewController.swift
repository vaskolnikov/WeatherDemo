//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Adem Özsayın on 26.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    lazy var loader: UIActivityIndicatorView = {
       let l = UIActivityIndicatorView()
        l.center = view.center
        l.style = .gray
        l.color = .black
        l.backgroundColor = SPNativeColors.purple
        return l
    }()

    var networkManager: NetworkManager!
    var city: City?
    var data: [List] = []
    
    var topView: TopView!
    var bottomView: BottomView!
    
    init(networkManager: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.networkManager = networkManager
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = SPNativeColors.customGray
     
         
         view.addSubview(loader)

//        LocationManager.shared.locationDelegate = self
//        LocationManager.shared.getLocation()
//        
        setupUI()
        addStatusBarBackground()
    }
    
    private func setupUI() {
        topView = TopView(frame: CGRect(x: 0, y:0, width: view.frame.width, height: view.frame.height - 200))
        //topView.backgroundColor = UIColor.black
        bottomView = BottomView(frame: CGRect(x: 0, y: view.frame.height - 220, width: view.frame.width, height: 200))
        bottomView.delegate = self
        view.addSubview(topView)
        view.addSubview(bottomView)

        
    }
    
    private func addStatusBarBackground () {
        
        if #available(iOS 13, *){
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor.init(hexString: "ebcb62")
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
           let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
           if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.init(hexString: "ebcb62")
           }
        }
    }
    
    func fethcWeather(_ location:CLLocation){
        loader.startAnimating()

        networkManager.getWeather(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude)) { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let result = result {
                //print(result)
                if let city = result.city {
                    self.city = city
                    self.topView.city = self.city?.name
                }
                self.data = result.data
                self.topView.degree = self.data[0].main.getDegree()
                
                self.filterData(data: self.data)
                DispatchQueue.main.async {
                    self.bottomView.setData(data: self.data)
                    self.loader.stopAnimating()
                }
            }
        }
    }
    
    func filterData(data: [List] ) {

        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let nowString = formatter.string(from: Date())
        let results = data.filter { $0.getDate() == nowString }

        self.topView.list = results
    }
    
    
    
    func getStatusBarHeight() ->CGFloat {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
       // let displayWidth: CGFloat = self.view.frame.width
        //let displayHeight: CGFloat = self.view.frame.height
        return barHeight
    }


}

//extension WeatherViewController : locationFetched {
//    
//    @objc func locationAddressString(locationFetched: String, lat: CLLocationDegrees, lon: CLLocationDegrees) {
//        if let location = LocationManager.shared.currentLocation,  LocationManager.shared.currentLocation != nil {
//            fethcWeather(location)
//        }
//    }
//}


extension WeatherViewController: BottomViewDelegate {
    func reload(data: List) {
        
        let filteredItems = self.data.filter { $0.getDate() == data.getDate() }
        self.topView.list = filteredItems
        self.topView.degree = filteredItems[0].main.getDegree()
        
    }
    
}

