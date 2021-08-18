//
//  SiteAnnotation.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/17/21.
//

import Foundation
import MapKit

class SiteAnnotation: NSObject, MKAnnotation {
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var site: TRISite
    var identifier = "TRI Site"
    //
    init(site: TRISite){

        self.coordinate = site.coordinates
        self.title = site.name
        self.subtitle = "\(site.address), \(site.city)"
        self.site = site
    }
}
