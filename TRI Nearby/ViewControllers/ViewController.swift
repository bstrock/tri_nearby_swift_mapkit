//
//  ViewController.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/16/21.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import SwiftUI

class ViewController: UIViewController {
    
    var sites = [TRISite]()
    @IBOutlet weak var siteListButton: UIButton!
    var locationManager = CLLocationManager()
    var selectedAnnotation:SiteAnnotation?
    var filterParams:[String: Any?] = ["radius": 5,
                                      "sectors": 0,
                                      "releaseType": 0,
                                      "carcinogen": nil]

    
    // MARK: Properties
    var userLocation:CLLocationCoordinate2D? = CLLocationCoordinate2D()
    let region = MKCoordinateRegion()

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ShowSiteList: UIButton!
    
    @IBOutlet weak var filterSites: UIButton!
    
    @IBOutlet weak var filterSitesForm: UIView!
    
    // MARK: Actions
    @IBAction func filterSites(_ sender: Any) {
        
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    //MKMapviewDelegate implementations
    
    // MARK: VIEW DID LOAD FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createSpinnerView()
        // MARK: locationManager config
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        do {
            sleep(2)
        }
        // MARK: Configure filter button
        
        let latitude = (locationManager.location?.coordinate.latitude)!
        let longitude = (locationManager.location?.coordinate.longitude)!
        
        filterSites.layer.cornerRadius = 8
        siteListButton.layer.cornerRadius = 8
        
        // default map configuration
        mapView.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
            )
        
        // MARK:  MapView config
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        
        
        print("PRE QUERY", locationManager.location?.coordinate)

        
        // MARK: intial map state query config
        
        let initQuery = Query(latitude: latitude,
                              longitude: longitude,
                              accessToken: ProcessInfo.processInfo.environment["ACCESS_TOKEN"]!,
                              radius: 5,
                              releaseType: nil,
                              carcinogen: nil,
                              sectors: nil)
        
        // this adds the search radius to the map
        addSearchRadiusOverlay(center: mapView.centerCoordinate, radius: initQuery.radius)
        
        // this adds the pins to the map
        fetchSitesJsonData(query: initQuery) { (incomingSites) in
            // MARK: initialize pins from query results
            
            self.sites = incomingSites
            self.siteListButton.setTitle("Sites in Filter: \(self.sites.count)", for: self.siteListButton.state)
            
            for site in self.sites {
                self.mapView.addAnnotation(SiteAnnotation(site: site))  // convert query result into annotation object
                self.mapView.register(SiteAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)  // register annotation
            }
        }
    }
}

// VIEW CONTROLLER DELEGATE IMPLEMENTATION
extension ViewController: CLLocationManagerDelegate {
    // implements user location checking
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        userLocation = locations.first?.coordinate
        
        print(userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to get users location.")
       }
    }

extension ViewController: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        // implements rendering of the search radius circle overlays
        
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selectedAnnotation = view.annotation as! SiteAnnotation
        print(selectedAnnotation)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "annotationDetailViewController")
        
        self.present(vc, animated: true)
        
    }
    
    func addSearchRadiusOverlay(center: CLLocationCoordinate2D, radius: Int){
        // call this function to add a radius overlay to the map
        let searchRadiusMeters:Double = Double(radius) * 1609.34
        let circle = MKCircle(center: center, radius: searchRadiusMeters)
        mapView.addOverlay(circle)
    }
}
