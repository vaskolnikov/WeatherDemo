//
//  ViewController.swift
//  WeatherDemo
//
//  Created by Adem Özsayın on 26.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import CoreLocation
import JGProgressHUD

class WeatherViewController: UIViewController {

    var networkManager: NetworkManager!
    var city: City?
    var data: [List] = []
    
    let hud = JGProgressHUD(style: .dark)
 
    
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
        toggleTheme()
        setupUI()
        addStatusBarBackground()
        //print(view.frame.height)
    }
    
    private func setupUI() {
        
        var height:CGFloat = 0
        if view.frame.height < 668 {
            height = 250
        } else {
            height = 200
        }
        topView = TopView(frame: CGRect(x: 0, y:0, width: view.frame.width, height: view.frame.height - height))
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
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)

        networkManager.getWeather(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude)) { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let result = result {
                //print(result)
                if let city = result.city {
                    self.city = city
                    self.topView.city = self.city?.name ?? "No city"
                }
                self.data = result.data
                self.topView.degree = self.data[0].main.getDegree()
                
                self.filterData(data: self.data)
                DispatchQueue.main.async {
                    self.bottomView.setData(data: self.data)
                    self.hud.dismiss(afterDelay: 0.83)
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
        return barHeight
    }
}

extension WeatherViewController: BottomViewDelegate {
    func reload(data: List) {
        
        let filteredItems = self.data.filter { $0.getDate() == data.getDate() }
        self.topView.list = filteredItems
        self.topView.degree = filteredItems[0].main.getDegree()
    }
}

