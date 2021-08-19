//
//  releaseTypesEnum.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/19/21.
//

import Foundation

enum ReleaseTypesEnum: String, CaseIterable {
    static var stringArray: [String] {
        return [self.ANY.rawValue, self.AIR.rawValue, self.WATER.rawValue, self.LAND.rawValue]
    }
    
    case
         ANY = "Any Release Type",
         AIR = "Air",
         WATER = "Water",
         LAND = "Land"
    }

