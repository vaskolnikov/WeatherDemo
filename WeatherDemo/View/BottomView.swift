//
//  BottomView.swift
//  WeatherDemo
//
//  Created by Adem Özsayın on 26.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol BottomViewDelegate:class  {
    func reload(data: List )
}

class BottomView : UIView {
    
    weak var delegate: BottomViewDelegate? = nil
    
    var mainView =  SPView()
    var titleLabel = SPLabel()
    var nextDaysView = SPView()
    
    let startingTag = 100
    var nextDaysData: [List] = []
    var sorted: [List] = []

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //setup()
    }
    
    private func setup(){
        mainView = SPView()
        mainView.frame = CGRect(x: 10, y: 10, width: self.frame.width - 20 , height: self.frame.height - 20)
        mainView.backgroundColor = UIColor.init(hexString: "ebcb62")
        mainView.addCornerRadiusAnimation(to: 20, duration: 1)
        
        titleLabel = SPLabel()
        titleLabel.frame = CGRect(x: 30, y: 20, width: self.frame.width - 40, height: 20)
        titleLabel.text = "Forecast (next 5 days)"
        titleLabel.font = UIFont.system(weight: .medium, size: 12)
        
        nextDaysView = SPView()
        nextDaysView.frame = CGRect(x: 20, y: 60, width: self.frame.width - 60 , height: self.frame.height - 100)
        //nextDaysView.backgroundColor = SPNativeColors.purple
        nextDaysView.addCornerRadiusAnimation(to: 2, duration: 1)

        self.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(nextDaysView)
 
    }
    
    func setData(data: [List]) {
      
        self.nextDaysData = data
        var filteredDays: [List] = []
        
        filteredDays = Dictionary(grouping: data,
                          by: { Calendar.current.startOfDay(for: Date(timeIntervalSince1970: TimeInterval($0.dt))) })
        .compactMap { $0.value.first }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"

        sorted = filteredDays.sorted(by: { dateFormatter.date(from:$0.getDate())!.compare(dateFormatter.date(from:$1.getDate())!) == .orderedAscending })
        
        sorted.remove(at: 0)
        let w = self.nextDaysView.frame.width / 5

        let count = sorted.count > 5 ? 5 : sorted.count
        
        for i in 0...count - 1 {
                        
            let weekDay = SPLabel()
            let degree = SPLabel()
            let imageView = SPImageView()
            let button = SPButton()
            
            weekDay.frame = CGRect(x: w * CGFloat((i)), y: 10, width:  self.nextDaysView.frame.width / 5, height: 20)
            weekDay.textAlignment  = .center
            weekDay.font = UIFont.system(weight: .regular, size: 12)
            weekDay.text = sorted[i].getDay()
            //weekDay.backgroundColor = SPNativeColors.midGray
            
            imageView.frame = CGRect(x: w * CGFloat((i)) + (w / 3), y: 35, width:  30, height: 30) // w/2 -15
//
//            var icon: UIImage!
//            switch sorted[i].weather[0].main {
//            case .clear:
//                //icon = "weather_status_sunny"
//                icon = UIImage.fontAwesomeIcon(name: .sun, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
//
//            case .clouds:
//                //icon = "weather_status_cloudy"
//                icon = UIImage.fontAwesomeIcon(name: .cloudSun, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
//
//            case .rain :
//                //icon = "weather_status_rain"
//                icon = UIImage.fontAwesomeIcon(name: .cloudShowersHeavy, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
//
//            default:
//                //icon = "weather_status_partly_cloudy"
//                icon = UIImage.fontAwesomeIcon(name: .sun, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
//            }

            //imageView.image = icon//
            imageView.image = sorted[i].weather[0].getImage(color: .black)


            degree.frame = CGRect(x: w * CGFloat((i )), y: nextDaysView.frame.height - 30, width: self.nextDaysView.frame.width / 5, height: 20)
            degree.textAlignment  = .center
            degree.text = sorted[i].main.getDegree()
            degree.font = UIFont.system(weight: .regular, size: 12)
           // degree.backgroundColor = SPNativeColors.green
            
            button.frame = CGRect(x: w * CGFloat((i)), y: 10, width: self.nextDaysView.frame.width / 5, height: 90)
            button.tag = i
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchDown)

            DispatchQueue.main.async {
        
                self.nextDaysView.addSubview(weekDay)
                self.nextDaysView.addSubview(imageView)
                self.nextDaysView.addSubview(degree)
                self.nextDaysView.addSubview(button)

            }
        }
    }
    
    @objc func buttonAction(_ sender:UIButton) {

        SPVibration.impact(.light)
        let index = sender.tag
        let dataToPass = self.sorted[index]
        print(dataToPass)
        delegate?.reload(data: dataToPass)

    }


    
//    func toggleTheme() {
//        
//    }
}


