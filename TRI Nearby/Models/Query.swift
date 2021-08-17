//
//  Query.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/16/21.
//

import Foundation

// data structure for queries
// contains method to return url components from structure instance

struct Query: Hashable, Codable {
    let latitude: Double
    let longitude: Double
    let accessToken: String
    let radius: Int
    let releaseType: String?
    let carcinogen: Bool?
    let sectors: [String]?
    
    func getQueryItems() -> [URLQueryItem] {
        
        // when a query is executed, this converts user query parameters to url parameters, then returns them as an array of parameters
        
        
        var queryItems:[URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "latitude", value: latitude.description))
        queryItems.append(URLQueryItem(name: "longitude", value: longitude.description))
        queryItems.append(URLQueryItem(name: "radius", value: radius.description))
        queryItems.append(URLQueryItem(name: "access_token", value: accessToken))
        var optionals:Dictionary<String, String> = [:]
        
        if let releaseType = releaseType {
            optionals["release_type"] = releaseType
        } else {
            optionals["release_type"] = nil
        }
        
        if let carcinogen = carcinogen {
            optionals["carcinogen"] = carcinogen.description
        } else {
            optionals["carcinogen"] = nil
        }
        
        if let sectors = sectors {
            optionals["sectors"] = sectors.description
        } else {
            optionals["sectors"] = nil
        }
        
        for key in optionals.keys{
            queryItems.append(URLQueryItem(name: key, value: optionals[key]))
        }
        print(queryItems)
        return queryItems
    }
}
