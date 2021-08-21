//
//  SiteAnnotationView.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/17/21.
//

import Foundation
import MapKit
import SwiftUI

final class SiteAnnotationView: MKMarkerAnnotationView {

    // MARK: Initialization
    override var annotation: MKAnnotation? {didSet {addCalloutToMarkers(for: annotation)}}
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SiteAnnotationView {
     
    
    func addCalloutToMarkers(for annotation: MKAnnotation?) {
        guard let annotation = annotation as? SiteAnnotation else { return }
        
        canShowCallout = true
        animatesWhenAdded = true
        let site:TRISite = annotation.site
    
        let info = UILabel()
        info.numberOfLines = 0
        info.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        var releasesText:String = ""
        var carcinogenText:String = ""
        
        if site.totalReleases == 0.0 {
            releasesText = "No releases reported– use info button to file report"
        } else {
            releasesText = String("Total Annual Releases: \(site.totalReleases.rounded()) Pounds")
        }
        
        if site.carcinogen == true {
            carcinogenText = "Yes"
        } else {
            carcinogenText = "No"
        }
        
        var releaseTypeText = ""
        
        info.text = "\(site.address), \(site.city), \(site.state) \(site.zip)\n\nIndustry Sector: \(site.sector)\n\(releasesText)\nReleases Carcinogens: \(carcinogenText)"
        
        
        markerTintColor = .white
        // determine which marker icon to use and color to use
        // Also format release types for textual representation
        // two factors to consider: how many items, and which combination
        
        if site.releaseTypes[0] != nil {
            // the release type is known
            
            // check length of array- will be 1, 2, or 3
            switch site.releaseTypes.count {
                case 1:  // one item- figure out which one
                    
                    let releaseType = site.releaseTypes[0]
                    if releaseType == "AIR" {
                            glyphImage = UIImage(named: "air")
                            markerTintColor = .lightGray
                            releaseTypeText = "Air"
                    } else if releaseType == "WATER" {
                            glyphImage = UIImage(named: "water")
                            markerTintColor = .cyan
                            releaseTypeText = "Water"
                    }
                    else if releaseType == "LAND"{
                            glyphImage = UIImage(named: "land")
                            markerTintColor = .green
                            releaseTypeText = "Land"
                    }
                case 2:  // two items- figure out which is missing
                    
                    if !site.releaseTypes.contains("AIR") {
                        glyphImage = UIImage(named: "water")
                        markerTintColor = .green
                        releaseTypeText = "Water, Land"
                    } else if !site.releaseTypes.contains("WATER") {
                        glyphImage = UIImage(named: "air")
                        markerTintColor = .green
                        releaseTypeText = "Air, Land"
                    } else if !site.releaseTypes.contains("LAND") {
                        glyphImage = UIImage(named: "air")
                        markerTintColor = .cyan
                        releaseTypeText = "Air, Water"
                    }
                case 3: // all 3 items
                    
                    glyphImage = UIImage(named: "all")!
                    markerTintColor = .red
                    releaseTypeText = "Air, Water, Land"
            default:
                releaseTypeText = "Not Reported"
            }
        } else {
            releaseTypeText = "Not Reported"  // the case that this is uknown
        }
        
        if site.releaseTypes.count == 1 {
            info.text! += "\nRelease Type: \(releaseTypeText)"
        } else if site.releaseTypes.count > 1 {
            info.text! += "\nRelease Types: \(releaseTypeText)"
        }
        
        detailCalloutAccessoryView = info
        let button = UIButton(type: .infoDark)
        rightCalloutAccessoryView = button
        
    }
}
