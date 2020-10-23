//
//  CitiesVirusData.swift
//  UKCovid-ios
//
//  Created by Suica on 18/10/2020.
//

import SwiftUI

class  CitiesVirusData: ObservableObject {
    @Published var cityRankList = [CityData]()
    @Published var currentCityData: CityData?
    
    public func fetchCasesRank(callback: @escaping ([CasesResult])->Void) {
        guard let url = URL(string: Api.newCases + "?sortby=\("new_cases")&order=\(1)&numperpage=\(15)&pageno=\(1)") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, err in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedResponse = try decoder.decode([CasesResult].self, from: data)
                    print("response \(decodedResponse)")
                    DispatchQueue.main.async {
                        self.cityRankList = decodedResponse.map { casesResult in
                            CityData(
                                areaName: casesResult.areaName,
                                areaCode: casesResult.areaCode,
                                cityCasesToday: casesResult.newCases ?? 0,
                                cityDeathsToday: casesResult.newDeaths ?? 0,
                                cityTotalCases: casesResult.cumCases ?? 0,
                                cityTotalDeaths: casesResult.cumDeaths ?? 0
                            )
                        }
                        callback(decodedResponse)
                    }
                } catch let decodeError {
                    print("Decode error: \(decodeError)")
                }
            }
        }.resume()
    }
    
    public func fetchCaseByPostcode(postcode: String, callback: @escaping (CityData)->Void) {
        let originUrl = Api.searchCases + "?postcode=\(postcode)"
        let escapedString = originUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        guard let url = URL(string: escapedString!) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, err in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedResponse = try decoder.decode([CasesResult].self, from: data)
                    print("response \(decodedResponse)")
                    let data = decodedResponse[0]
                    DispatchQueue.main.async {
                        self.currentCityData = CityData(
                            areaName: data.areaName,
                            areaCode: data.areaCode,
                            cityCasesToday: data.newCases ?? 0,
                            cityDeathsToday: data.newDeaths ?? 0,
                            cityTotalCases: data.cumCases ?? 0,
                            cityTotalDeaths: data.cumDeaths ?? 0
                        )
                        callback(self.currentCityData!)
                    }
                } catch let decodeError {
                    print("Decode error: \(decodeError)")
                }
            }
        }.resume()
    }
}
