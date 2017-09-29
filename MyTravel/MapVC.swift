//
//  MapVC.swift
//  MyTravel
//
//  Created by user22 on 2017/9/29.
//  Copyright © 2017年 Brad Big Company. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    let app = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\(app.nowLat):\(app.nowLng)")
        
//        let latString = "123.321"
//        let latDouble = Double(latString)
        
        // 產生中心點
        let center = CLLocation(latitude: app.nowLat, longitude: app.nowLng)
        centerLocation(location: center, mapView: mapView)

        // 插針
        let ann = MKPointAnnotation()
        ann.coordinate = CLLocationCoordinate2DMake(app.nowLat, app.nowLng)
        mapView.addAnnotation(ann)
        
        
        
    }
    
    // 定位及縮放
    private func centerLocation(location: CLLocation, mapView:MKMapView) {
        let dis:CLLocationDistance = 5*1000 // 以公尺計
        let cooordRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, dis,  dis)
        mapView.setRegion(cooordRegion, animated: true)
    }

}
