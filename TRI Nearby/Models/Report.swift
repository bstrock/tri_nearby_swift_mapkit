//
//  Report.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/16/21.
//
import Foundation

// data structure for displaying reports

struct Report: Hashable, Codable {
    let reportId: String
    let siteId: String
    let reportType: String
    let message: String?
    let emissionType: String?
    let activityType: String?
    let unusuedType: String?
    let timestamp: Date?
}
