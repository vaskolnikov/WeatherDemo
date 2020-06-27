//
//  Extension.swift
//  WeatherDemo
//
//  Created by Adem Özsayın on 26.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation
import  UIKit


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

struct App {
    static let normal = UIColor.black.withAlphaComponent(1.0)
    static let faded = UIColor.black.withAlphaComponent(0.5)
    static let fadedTwo = UIColor.white.withAlphaComponent(0.5)
    static let appColor = UIColor.init(hexString: "ebcb62")
    static let darkAppColor = UIColor.init(hexString: "17174e")//
    static let darkFaded = UIColor.init(hexString: "17174e").withAlphaComponent(0.7)
    static let selected = UIColor.init(hexString: "2a285b")//
    static let darkHourBgColor = UIColor.init(hexString: "866b3f")
    //
}


extension UIViewController {
    func theme() ->Bool{
      
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        let s1 = f.string(from: Date())
        let s2 = "21:00"
        return f.date(from: s1)! > f.date(from: s2)!  // true
        
    }
    
    func toggleTheme() {
        if !theme(){
            view.backgroundColor = SPNativeColors.customGray
        } else {
            view.backgroundColor = App.darkAppColor
        }
    }
}
//
extension UICollectionView {
    func themed() ->Bool{
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        let s1 = f.string(from: Date())
        let s2 = "21:00"
        return f.date(from: s1)! > f.date(from: s2)!  // true

    }

    func toggleThemed() {
        if !themed(){
            self.backgroundColor = SPNativeColors.customGray
        } else {
            self.backgroundColor = App.darkAppColor
        }
    }
}
//
//extension UIColor {
//    func darked() -> Bool {
//        let f = DateFormatter()
//        f.dateFormat = "HH:mm"
//        let s1 = f.string(from: Date())
//        let s2 = "21:00"
//        return f.date(from: s1)! > f.date(from: s2)!  // true
//    }
//
//    func toggleTheme() {
//        if !darked(){
//
//        } else {
//
//        }
//    }
//
//}

extension TopView {
    func theme() ->Bool{
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        let s1 = f.string(from: Date())
        let s2 = "21:00"
        return f.date(from: s1)! > f.date(from: s2)!  // true
        
    }
    
    func toggleTheme() {
        if !theme(){
            self.backgroundColor = SPNativeColors.customGray
            self.cityLabel.textColor = App.normal
            self.dateLabel.textColor = App.normal
            self.degreeLabel.textColor = App.normal
        } else {
            self.backgroundColor = App.darkAppColor
            self.cityLabel.textColor = SPNativeColors.white
            self.dateLabel.textColor = SPNativeColors.white
            self.degreeLabel.textColor = SPNativeColors.white
        }
    }
}

extension WeatherCell {
    
    func darked() ->Bool{
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        let s1 = f.string(from: Date())
        let s2 = "21:00"
        return f.date(from: s1)! < f.date(from: s2)!  // true

    }
    
    func toggleThemed(isSelected: Bool) {
        if darked(){
            self.layer.cornerRadius = 30
            self.alpha = 1.0
            self.hourView.backgroundColor = App.appColor
            self.degreeLabel.textColor = UIColor.black
            self.hourLbael.textColor = UIColor.black
            if isSelected {
                self.backgroundColor = SPNativeColors.white
                self.iconColor = SPNativeColors.black

            } else {
                self.backgroundColor = SPNativeColors.customGray
                self.iconColor = App.faded
            }
            
        } else {
            
            self.layer.cornerRadius = 30
            self.alpha = 1.0
 
            self.hourView.backgroundColor = App.darkHourBgColor
            self.degreeLabel.textColor = UIColor.white
            self.hourLbael.textColor = UIColor.white
            
            if isSelected {
                self.backgroundColor = App.selected
                self.iconColor = SPNativeColors.white
            } else {
                self.backgroundColor = App.darkAppColor
                self.iconColor = App.fadedTwo
            }

        }
    }
}

