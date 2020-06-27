//
//  WeatherCell.swift
//  WeatherDemo
//
//  Created by Adem Özsayın on 26.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import FontAwesome_swift

class WeatherCell: UICollectionViewCell{

    var hourView = SPView()
    var hourLbael = SPLabel()
    var dateLabel = SPLabel()
    var degreeLabel = SPLabel()
    var imageView = SPImageView()
    
    var iconColor: UIColor!


    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()

   }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup() {
        hourView = SPView()
        hourView.frame = CGRect(x: (self.frame.width/2) - 40 , y: 20, width: 80, height: 40)
        hourView.addCornerRadiusAnimation(to: 20, duration: 0.3)
        hourView.backgroundColor = UIColor.init(hexString: "ebcb62")
        
        hourLbael = SPLabel()
        hourLbael.frame = CGRect(x: 10, y: 5, width: hourView.frame.width - 20, height: 30)
        hourLbael.textAlignment = .center
        hourLbael.font = UIFont.system(weight: .light, size: 12)
        
        degreeLabel = SPLabel()
        degreeLabel.textAlignment = .center
        degreeLabel.font = UIFont.system(weight: .light, size: 13)

        imageView = SPImageView()
            
        
        self.addSubview(hourView)
        hourView.addSubview(hourLbael)
        self.addSubview(degreeLabel)
        self.addSubview(imageView)

    }
    
    func setData(data: List) {
        //print(data)
        DispatchQueue.main.async {
            self.hourLbael.text = data.getHour()
            self.degreeLabel.text = data.main.getDegree()
            //self.imageView.image =  UIImage.fontAwesomeIcon(name: .sun, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
            //self.imageView.image = data.weather[0].getImage(color: .black)

        }
    }

}
