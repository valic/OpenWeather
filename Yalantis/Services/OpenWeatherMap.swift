//
//  OpenWeatherMap.swift
//  Yalantis
//
//  Created by Valentyn Mialin on 10/12/18.
//  Copyright © 2018 Valentyn Mialin. All rights reserved.
//

import Foundation
import Alamofire

struct OpenWeatherMap {
    enum Response<T: Codable> {
        case failure(error: Error)
        case success(T)
    }
    
    static private let scheme = "https"
    static private let host = "api.openweathermap.org"
    static private let apiVersion = "2.5"
    static private let apiID = "5dc62ac0baf9fbd81c64676523e5b679"
    
    /**
     Another useful function
     - parameter cityID: city ID
     - parameter beta: Describe the beta param
     */
    public static func getDailyForecast(cnt: Int, cityID id: String, response: ((_ r: Response<Forecast>) -> Void)?) {

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/data/\(apiVersion)/forecast/daily"
        
        let queryApiID = URLQueryItem(name: "APPID", value: apiID)
        let queryCityID = URLQueryItem(name: "id", value: id)
        let queryLanguageCode = URLQueryItem(name: "lang", value: Locale.current.languageCode)
        let units = Locale.current.usesMetricSystem ? "metric" : "imperial"
        let queryUnitsFormat = URLQueryItem(name: "units", value: units)
        let queryNumberOfDay = URLQueryItem(name: "cnt", value: String(cnt))
        urlComponents.queryItems = [queryApiID, queryCityID, queryLanguageCode, queryUnitsFormat, queryNumberOfDay]
        
        guard let url = urlComponents.url else { return }
        
        Alamofire.request(url).responseForecast { r in
            switch r.result {
            case .success(let forecast):
                response?(Response.success(forecast))
            case .failure(let error):
                response?(Response.failure(error: error))
            }
        }
        
    }
}
