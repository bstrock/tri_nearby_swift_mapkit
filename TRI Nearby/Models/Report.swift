//
//  Report.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/16/21.
//
import Foundation

// data structure for displaying reports

struct Report: Hashable, Codable {
    let reportId: String?
    let siteId: String
    let reportType: String
    var message: String?
    var emissionType: String?
    var activityType: String?
    var unusuedType: String?
    
    func jsonDictionary() -> [String: String?] {
            return [
                "report_id": reportId,
                "site_id": siteId,
                "report_type": reportType,
                "message": message,
                "emission_type": emissionType,
                "activity_type": activityType,
                "unused_type": unusuedType
            ]
        }
    }

