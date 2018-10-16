//
//  ViewController.swift
//  Yalantis
//
//  Created by Valentyn Mialin on 10/12/18.
//  Copyright © 2018 Valentyn Mialin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftChart
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chart: Chart!
    
    var forecast: Forecast?{
        didSet{
            cityNameLabel?.text = forecast?.city.name
            collectionView.reloadData()
            chartView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameLabel?.text = ""
        
        chart.delegate = self
        chart.hideHighlightLineOnTouchEnd = true
        
        queryRealm()
        getForecast()
    }
    
    fileprivate func queryRealm() {
        let realm = try! Realm()
        let forecastObject = realm.objects(ForecastObject.self)
        if let forecast = forecastObject.first?.forecast {
            self.forecast = forecast
        }
    }
    
    fileprivate func writeRealm(forecast: Forecast) {
        DispatchQueue(label: "background").async {
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
                let forecastObject = ForecastObject()
                forecastObject.forecast = forecast
                realm.add(forecastObject)
            }
        }
    }
    
    fileprivate func getForecast() {
        OpenWeatherMap.getDailyForecast(cnt: 16, cityID: "703448") {  [weak self] (response) in
            DispatchQueue.main.async() {
                switch response {
                case .success(let forecast):
                    self?.writeRealm(forecast: forecast)
                    self?.forecast = forecast
                case .failure(let error):
                    self?.errorAlert(error: error)
                }
            }
        }
    }
    
    fileprivate func chartView() {
        guard let forecast = self.forecast else { return }
        chart.removeAllSeries()
        
        let tempArray = forecast.list.map({$0.temp.day})
        let series = ChartSeries(tempArray)
        series.area = true
        series.colors = (
            above: ChartColors.redColor(),
            below: ChartColors.blueColor(),
            zeroLevel: Locale.current.usesMetricSystem ? 0 : 32
        )
        chart.add(series)

        // Format x-axis, e.g. with units
        chart.xLabelsFormatter = { forecast.list[Int($1)].dateToString }
        chart.xLabelsTextAlignment = .center
        chart.xLabelsSkipLast = true
        chart.xLabelsOrientation = .vertical
        // Format y-axis, e.g. with units
        chart.yLabelsFormatter = { String(Int($1)) + (Locale.current.usesMetricSystem ? "ºC" : "ºF") }
    }
    
    fileprivate func errorAlert(error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastViewCell", for: indexPath) as! ForecastViewCell
        
        cell.settingCell(list: forecast!.list[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = collectionView.frame.width
        return CGSize(width: (size/3)-8, height: (size/3)-8)
    }
}

extension ViewController: ChartDelegate {
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        guard let index = indexes.first,
            index != nil else { return }
        let indexPath = IndexPath(item: index!, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically,   .centeredHorizontally], animated: true)
       // chart.valueForSeries(index!, atIndex: index)
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
    }
    
    func didEndTouchingChart(_ chart: Chart) {
    }
}



