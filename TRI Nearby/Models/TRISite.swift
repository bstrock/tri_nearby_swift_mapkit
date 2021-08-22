//
//  Sites.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/16/21.
//

import Foundation
import SwiftUI
import MapKit

struct TRISite: Hashable, Codable {
    let siteId: String
    let name: String
    let address: String
    let city: String
    let state: String
    let zip: Int
    let latitude: Double
    let longitude: Double
    let sector: String
    let carcinogen: Bool
    let chemicals: Dictionary<String, Chemical>
    let releaseTypes: [String?]
    let totalReleases: Double
    let reports: [Report?]
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Chemical: Hashable, Codable {
    let unit: String?
    let total: Float?
}

struct Sites: Decodable {
    let sites: [TRISite]
}
