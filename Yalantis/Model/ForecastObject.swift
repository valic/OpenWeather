//
//  ForecastObject.swift
//  Yalantis
//
//  Created by Valentyn Mialin on 10/13/18.
//  Copyright © 2018 Valentyn Mialin. All rights reserved.
//

import RealmSwift

class ForecastObject : Object {
    
    @objc private dynamic var structData:Data? = nil
    
    var forecast : Forecast? {
        get {
            if let data = structData {
                return try? JSONDecoder().decode(Forecast.self, from: data)
            }
            return nil
        }
        set {
            structData = try? JSONEncoder().encode(newValue)
        }
    }
}
