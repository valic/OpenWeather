//
//  Forecast.swift
//  Yalantis
//
//  Created by Valentyn Mialin on 10/12/18.
//  Copyright © 2018 Valentyn Mialin. All rights reserved.
//

import Foundation
import Alamofire

struct Forecast: Codable {
    let city: City
    let cod: String
    let message: Double
    let cnt: Int
    let list: [List]
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct List: Codable {
    let dt: Date
    let temp: Temp
    let pressure: Double
    let humidity: Int
    let weather: [Weather]
    let speed: Double
    let deg, clouds: Int
    let rain: Double?
    
    var dateToString: String {
        get{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            formatter.locale = Locale.current
            return formatter.string(from: dt as Date)
        }
    }
}

struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .secondsSince1970
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .secondsSince1970
    }
    return encoder
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseForecast(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Forecast>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
