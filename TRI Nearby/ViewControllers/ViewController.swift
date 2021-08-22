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

    // main view controller for map view, controls form report and filter query views
    // ALL VIEWS RETURN TO HERE

    // MARK:  Constants
    var sites = [TRISite]()  // may refactor this out
    var locationManager = CLLocationManager()  // manages user locations
    var selectedAnnotation: SiteAnnotation?  // records selected annotation when user taps to submit report
    var userLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D()
    let region = MKCoordinateRegion()

    // persistent state object to track state of user's filter selections
    var filterParams: [String: Any?] = ["radius": 5,
                                        "sectors": 0,
                                        "releaseType": 0,
                                        "carcinogen": nil]

    // MARK: Outlets
    @IBOutlet weak var siteListButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var ShowSiteList: UIButton!
    @IBOutlet weak var filterSites: UIButton!
    @IBOutlet weak var filterSitesForm: UIView!

    // MARK: Actions
    @IBAction func filterSites(_ sender: Any) {
        // TODO: disconnect from storyboard adn remove
    }

    func createSpinnerView() {
        // it's just a spinner

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
        createSpinnerView()  // show spinner while location is being accessed

        // MARK: locationManager config
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        do {
            // this is admittedly janky, but it takes ~2 seconds for the location request function to return a result
            // without the sleep in place or better async response handling, the view doesn't assess user location
            sleep(2)
        }

        // USER LOCATION
        let latitude = (locationManager.location?.coordinate.latitude)!
        let longitude = (locationManager.location?.coordinate.longitude)!

        // MARK: Configure button styles
        filterSites.layer.cornerRadius = 8
        siteListButton.layer.cornerRadius = 8

        // MARK:  MapView config
        mapView.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        )

        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsBuildings = true

        // MARK: initial map state query

        let initQuery = Query(
                latitude: latitude,
                longitude: longitude,
                accessToken: ProcessInfo.processInfo.environment["ACCESS_TOKEN"]!,
                radius: 5,
                releaseType: nil,
                carcinogen: nil,
                sectors: nil
        )

        // this adds the search radius to the map
        addSearchRadiusOverlay(center: mapView.centerCoordinate, radius: initQuery.radius)

        // this adds the pins to the map
        fetchSitesJsonData(query: initQuery) { (incomingSites) in
            // MARK: initialize pins from query results

            self.sites = incomingSites  // TODO:  refactor this out
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first?.coordinate
        // TODO:  need to implement this function to get location, but it currently doesn't do anything
        // TODO:  better async handling in this function would eliminate the need for the thread sleep in ViewDidLoad()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // THIS FUNC IS REQUIRED FOR didUpdateLocations TO WORK, DO NOT REMOVE
        print("Failed to get users location.")
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // implements rendering of the search radius circle overlays
        var circleRenderer = MKCircleRenderer()

        // circle style properties defined here
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
        // this implements the callout button tapped response
        // TODO:  can expand this interaction to present a richer site view which then connects to the report form
        selectedAnnotation = view.annotation as! SiteAnnotation

        // get main storyboard, make an annnotation detail view from it, and present
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "annotationDetailViewController")
        present(vc, animated: true)
    }

    func addSearchRadiusOverlay(center: CLLocationCoordinate2D, radius: Int) {
        // call this function to add a radius overlay to the map
        let searchRadiusMeters: Double = Double(radius) * 1609.34
        let circle = MKCircle(center: center, radius: searchRadiusMeters)
        mapView.addOverlay(circle)
    }
}
