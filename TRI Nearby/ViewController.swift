//
//  ViewController.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/16/21.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 25, longitude: -90),
                span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 160)
        )
    
    // MARK: Actions
    @IBOutlet weak var ShowSiteList: UIButton!
    
    @IBOutlet weak var FilterSites: UIButton!
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.region = region
        
        let testQuery = Query(latitude: 45,
                              longitude: -96,
                              accessToken: ProcessInfo.processInfo.environment["ACCESS_TOKEN"]!,
                              radius: 1000,
                              releaseType: nil,
                              carcinogen: nil,
                              sectors: nil)
        
        fetchSitesJsonData(query: testQuery) { (sites) in
            // this is where we'll initialize the pins and shit
            print(sites[0])
        }
        
        
        
    }


}

