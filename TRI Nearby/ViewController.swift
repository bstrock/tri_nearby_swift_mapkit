//
//  ViewController.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/16/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    
    
    var sites = [TRISite]()
    var locationManager = CLLocationManager()
    
    // MARK: Properties
    var userLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    let region = MKCoordinateRegion()
    
    
    func addSearchRadiusOverlay(center: CLLocationCoordinate2D, radius: Int){
        let searchRadiusMeters:Double = Double(radius) * 1609.34
        let circle = MKCircle(center: center, radius: searchRadiusMeters)
        
        mapView.addOverlay(circle)
        
    }
    
    
    // MARK: Actions
    @IBOutlet weak var ShowSiteList: UIButton!
    
    @IBOutlet weak var FilterSites: UIButton!
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("OVERLAY", overlay)
        var circleRenderer = MKCircleRenderer()
        if let overlay = overlay as? MKCircle {
            
            circleRenderer = MKCircleRenderer(circle: overlay)
            circleRenderer.strokeColor = .black
            circleRenderer.lineWidth = 1.5
            circleRenderer.alpha = 0.2
            circleRenderer.fillColor = .gray
        }
        return circleRenderer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        mapView.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.854, longitude: -93.47),
            span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
            )
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        let testQuery = Query(latitude: mapView.region.center.latitude,
                              longitude: mapView.region.center.longitude,
                              accessToken: ProcessInfo.processInfo.environment["ACCESS_TOKEN"]!,
                              radius: 5,
                              releaseType: nil,
                              carcinogen: nil,
                              sectors: nil)
        
        addSearchRadiusOverlay(center: mapView.centerCoordinate, radius: testQuery.radius)
        
        fetchSitesJsonData(query: testQuery) { (incomingSites) in
            // this is where we'll initialize the pins and shit
            
            
            self.sites = incomingSites
            print ("RETURNED COUNT: \(self.sites.count)")
            for site in self.sites {
                self.mapView.addAnnotation(SiteAnnotation(site: site))
                self.mapView.register(SiteAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            }
        }
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        if let location = locations.first {
            
            userLocation = location.coordinate
            print(userLocation)
            // Handle location update
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to get users location.")
       }
    
   
    }




