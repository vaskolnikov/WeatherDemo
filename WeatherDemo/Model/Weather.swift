//
//  Weather.swift
//  WeatherDemo
//
//  Created by Adem Özsayın on 26.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import Foundation

struct WeatherApiResponse {
    let cod: String
    let message: Int
    let cnt: Int
    let data: [List]
    let city: City?
}

extension WeatherApiResponse: Decodable {
    
    private enum WeatherApiResponseCodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case data = "list"
        case city = "city"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WeatherApiResponseCodingKeys.self)
        
        cod = try container.decode(String.self, forKey: .cod)
        message = try container.decode(Int.self, forKey: .message)
        cnt = try container.decode(Int.self, forKey: .cnt)
        data = try container.decode([List].self, forKey: .data)
        city = try container.decodeIfPresent(City.self, forKey: .city)
    }
}

struct City:Decodable {
    let id: Int?
    let name: String?
    //let coord: Coord
    let country: String?
    //let population, timezone, sunrise, sunset: Int
}

//struct Coord {
//    let lat, lon: Double
//}

struct List:Decodable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    //let clouds: Clouds
    //let wind: Wind
    //let sys: Sys
    let dateTime: String
    //let rain: Rain?

    
    private enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main =  "main"
        case weather = "weather"

        case dateTime = "dt_txt"

    }
    
    init(dt: Int,main: MainClass, weather: [Weather], dateTime: String ) {
        self.dt = dt
        self.main = main
        self.weather = weather
        self.dateTime = dateTime

     }
    
    static func == (lhs: List, rhs: List) -> Bool {
           return lhs.dt == rhs.dt
       }

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dt = try container.decode(Int.self, forKey: .dt)
        main = try container.decode(MainClass.self, forKey: .main)
        weather = try container.decode([Weather].self, forKey: .weather)
        dateTime = try container.decode(String.self, forKey: .dateTime)
    }
    
    func getMonthWithName() -> String {
        return convertToFormat(date: self.dateTime, dateFormat: "MMM d, yyyy EEEE")
    }
    
    func getHour() -> String {
        return convertToFormat(date: self.dateTime, dateFormat: "HH:mm")
    }
    
    func getDate() -> String {
        return convertToFormat(date: self.dateTime, dateFormat: "yyyy-MM-dd")
    }
    
    func getDay() -> String {
        return convertToFormat(date: self.dateTime, dateFormat: "E")
    }
    
    func convertToFormat(date: String, dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         let date1 = formatter.date(from: date)
         formatter.dateFormat = dateFormat
         let date2 = formatter.string(from: date1!)
         let date3 = formatter.date(from: date2)
         let date4 = formatter.string(from: date3!)
        return date4
    }
}

func ==(l: List, r: List) -> Bool {
    return l.dt == r.dt
}


// MARK: - Clouds
//struct Clouds {
//    let all: Int
//}

// MARK: - MainClass
struct MainClass: Decodable {
//    let temp, feelsLike, tempMin, tempMax: Double
//    let pressure, seaLevel, grndLevel, humidity: Int
//    let tempKf: Double
    let temp: Double
    
    func getDegree() -> String {
        
        if let kelvinTemp = self.temp as? Double {
            let celsiusTemp = Int(kelvinTemp - 273.15)
            let mf = MeasurementFormatter()
            let temp = Measurement(value: Double(celsiusTemp), unit: UnitTemperature.celsius)
            mf.locale = Locale(identifier: "fr_FR")
            return  mf.string(from: temp) //(mf.string(from: temp))
        }
        return ""
    }
}

//
//// MARK: - Rain
//struct Rain {
//    let the3H: Double
//}
//
//
//// MARK: - Sys
//struct Sys {
//    let pod: Pod
//}
//
//
//enum Pod {
//    case d
//    case n
//}

// MARK: - Weather
struct Weather:Decodable {
    let id: Int
    let main: WeatherStatus
    //let weatherDescription: Description
    //let icon: Icon
    
    func getImage(color: UIColor) -> UIImage {
        var icon: UIImage!
        switch main {
        case .clear:
            //icon = "weather_status_sunny"
            icon = UIImage.fontAwesomeIcon(name: .sun, style: .solid, textColor: color, size: CGSize(width: 30, height: 30))

        case .clouds:
            //icon = "weather_status_cloudy"
            icon = UIImage.fontAwesomeIcon(name: .cloudSun, style: .solid, textColor: color, size: CGSize(width: 30, height: 30))

        case .rain :
            //icon = "weather_status_rain"
            icon = UIImage.fontAwesomeIcon(name: .cloudShowersHeavy, style: .solid, textColor: color, size: CGSize(width: 30, height: 30))

        default:
            //icon = "weather_status_partly_cloudy"
            icon = UIImage.fontAwesomeIcon(name: .sun, style: .solid, textColor: color, size: CGSize(width: 30, height: 30))
        }
        return icon

    }
        
}


//enum Icon {
//    case the01D
//    case the01N
//    case the02D
//    case the03D
//    case the10D
//}


enum WeatherStatus: String {
    case clear = "Clear", clouds = "Clouds", rain = "Rain", unknown = "unknown"
}

extension WeatherStatus: Decodable {
    public init(from decoder: Decoder) throws {
        self = try WeatherStatus(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}


//enum MainEnum: Decodable{
//    init(from decoder: Decoder) throws {
//        <#code#>
//    }
//
//    case clear
//    case clouds
//    case rain
//}


//enum Description {
//    case clearSky
//    case fewClouds
//    case lightRain
//    case scatteredClouds
//}
//
//struct Wind {
//    let speed: Double
//    let deg: Int
//}
