//
//  releaseTypesEnum.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/19/21.
//

import Foundation

//just a basic enum
enum ReleaseTypesEnum: String, CaseIterable {
    static var stringArray: [String] {
        [ANY.rawValue, AIR.rawValue, WATER.rawValue, LAND.rawValue]
    }
    case
            ANY = "Any Release Type",
            AIR = "Air",
            WATER = "Water",
            LAND = "Land"
}

