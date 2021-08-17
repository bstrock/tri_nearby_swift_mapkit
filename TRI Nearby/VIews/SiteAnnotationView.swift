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
    //override var annotation: MKAnnotation? {didSet {markerStyleCheck(for: annotation)}}
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        canShowCallout = true
        //setupUI()
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension SiteAnnotationView {
    func markerStyleCheck(for annotation: MKAnnotation?) {
        guard let annotation = annotation as? MKAnnotation else { return }
        let title:String? = annotation.title!
        
        canShowCallout = true
//        switch checkType {
//                case "DAMAGE:":
//                    markerTintColor = UIColor.red
//                    glyphImage = UIImage(named: "damage")
//                case "DONATION:":
//                    markerTintColor = UIColor.purple
//                    glyphImage = UIImage(named: "donation")
//                case "REQUEST:":
//                    markerTintColor = UIColor.blue
//                    glyphImage = UIImage(named: "request")
//        default:
//            markerTintColor = .black
//        }
//        let rightButton = UIButton(type: .detailDisclosure)
//        rightCalloutAccessoryView = rightButton
        
    }
}

