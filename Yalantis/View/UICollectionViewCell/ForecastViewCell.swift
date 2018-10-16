//
//  ForecastViewCell.swift
//  Yalantis
//
//  Created by Valentyn Mialin on 10/12/18.
//  Copyright © 2018 Valentyn Mialin. All rights reserved.
//

import UIKit
import AlamofireImage
class ForecastViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherConditionsImageView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func settingCell(list: List) {
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView = blurEffectView
        backgroundView?.layer.cornerRadius = 10
        backgroundView?.layer.masksToBounds = true
        
        dataLabel?.text = list.dateToString
        
        let icon = list.weather.first?.icon ?? ""
        let url = URL(string: "https://openweathermap.org/img/w/\(icon).png")!
        weatherConditionsImageView.af_setImage(withURL: url)
        
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 0
        let units:UnitTemperature = Locale.current.usesMetricSystem ? .celsius : .fahrenheit
        let measurement = Measurement(value: list.temp.day, unit: units)

        tempLabel?.text = formatter.string(from: measurement)
        descriptionLabel?.text = list.weather.first?.description ?? ""
    }
}
