//
//  Created by Adem Özsayın on 26.06.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import Foundation

enum WeatherNetworkEnvironment {
    case qa
    case production
    case staging
}

public enum WeatherApi {

    case getWeather(latitude:Double, longitude: Double)

}

extension WeatherApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.openweathermap.org/data/2.5/" //production // live
        case .qa: return "https://api.openweathermap.org/data/2.5/" //Quality Assurance
        case .staging: return "https://api.openweathermap.org/data/2.5/" //test
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        
        case .getWeather:
            return "forecast"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getWeather:
            return .get
        default:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getWeather(let latitude, let longitude):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["lat": latitude, "lon": longitude, "appid": NetworkManager.appId ])

        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


