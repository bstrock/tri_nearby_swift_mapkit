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
    init(site: TRISite) {

        coordinate = site.coordinates
        title = site.name
        subtitle = "\(site.address), \(site.city)"
        self.site = site
    }
}
