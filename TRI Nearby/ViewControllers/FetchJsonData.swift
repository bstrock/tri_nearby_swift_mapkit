//
//  FetchJsonData.swift
//  TRI Nearby
//
//  Created by Brian Strock on 8/16/21.
//

import Foundation

func fetchSitesJsonData(
    query: Query,
    completion: @escaping ([TRISite]) -> Void
    ) {
    
    // build the url from the query components and API path
    var component = URLComponents()
    component.scheme = "https"
    component.host = "tri-nearby-db.herokuapp.com"
    component.path = "/query"
    let queryItems:[URLQueryItem] = query.getQueryItems()
    component.queryItems = queryItems
    
    // storage object
    var sites:[TRISite] = []
    
    // api call starts here
    guard let url = component.url else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else { return } // checks data integrity; null responses from api fail here
        
        let decoder = JSONDecoder()  // decodes the json
        decoder.keyDecodingStrategy = .convertFromSnakeCase  // makes this_stuff into thisStuff
        decoder.dateDecodingStrategy = .secondsSince1970  // unix timestamp decoder
        sites = try! decoder.decode([TRISite].self, from: data)  // attempt to decode json from api
                    DispatchQueue.main.async {  // async dispatch happens here
                        completion(sites)  // returns closure containing sites to function call
                }
        }.resume()  // async functionality breaks without this
}

func postReportJsonData(
    report: Report,
    completion: @escaping (Report) -> Void
) {
    var component = URLComponents()
    component.scheme = "https"
    component.host = "tri-nearby-db.herokuapp.com"
    component.path = "/submit"
    
    let url = component.url!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: report.jsonDictionary(), options: .prettyPrinted)
    } catch {
        print("NO!   YOU FAIL")
    }
    print(report.jsonDictionary())
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else { return } // checks data integrity; null responses from api fail here
        let decoder = JSONDecoder()  // decodes the json
        decoder.keyDecodingStrategy = .convertFromSnakeCase  // makes this_stuff into thisStuff
        decoder.dateDecodingStrategy = .secondsSince1970  // unix timestamp decoder
        let reportBack = try! decoder.decode(Report.self, from: data)  // attempt to decode json from api
                    DispatchQueue.main.async {  // async dispatch happens here
                        print(reportBack)
                        completion(reportBack)  // returns closure containing sites to function call
                }
        }.resume()  // async functionality breaks without this
    }


