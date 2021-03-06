//
//  CitiesVirusData.swift
//  UKCovid-ios
//
//  Created by Suica on 18/10/2020.
//

import SwiftUI

class  CitiesVirusData: ObservableObject {
    @Published var cityCasesRankList = [CityData]()
    @Published var cityCasesLastUpdateTime: Date?
    @Published var cityDeathsRankList = [CityData]()
    @Published var cityDeathLastUpdateTime: Date?
    @Published var currentCityData: CityData?
    @ObservedObject var locationManager = LocationManager()
    
    public func initCitiesVirusData() {
        self.getGeolocation()
    }
    
    
    
    public func fetchCasesRank(success: @escaping ([CasesResult])->Void, failure: @escaping((_ error:NSError) -> Void)) {
        guard let url = URL(string: Api.newCases + "?sortby=\("new_cases")&order=\(1)&numperpage=\(15)&pageno=\(1)") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(5)
        configuration.timeoutIntervalForResource = TimeInterval(5)
        let session = URLSession(configuration: configuration)
        session.dataTask(with: request) { data, response, err in
            if let err = err { // timeout
                failure(err as NSError)
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedResponse = try decoder.decode([CasesResult].self, from: data)
                    print("response \(decodedResponse)")
                    DispatchQueue.main.async {
                        self.cityCasesRankList = decodedResponse.map { casesResult in
                            CityData(
                                areaName: casesResult.areaName,
                                areaCode: casesResult.areaCode,
                                cityCasesToday: casesResult.newCases ?? 0,
                                cityDeathsToday: casesResult.newDeaths ?? 0,
                                cityTotalCases: casesResult.cumCases ?? 0,
                                cityTotalDeaths: casesResult.cumDeaths ?? 0
                            )
                        }
                        self.cityCasesLastUpdateTime = Date()
                        success(decodedResponse)
                    }
                } catch let decodeError {
                    print("Decode error: \(decodeError)")
                    failure(decodeError as NSError)
                }
            }
        }.resume()
    }
    
    public func fetchDeathsRank(success: @escaping ([CasesResult])->Void, failure: @escaping((_ error:NSError) -> Void)) {
        guard let url = URL(string: Api.newCases + "?sortby=\("new_deaths")&order=\(1)&numperpage=\(15)&pageno=\(1)") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(5)
        configuration.timeoutIntervalForResource = TimeInterval(5)
        let session = URLSession(configuration: configuration)
        session.dataTask(with: request) { data, response, err in
            if let err = err { // timeout
                failure(err as NSError)
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedResponse = try decoder.decode([CasesResult].self, from: data)
                    print("response \(decodedResponse)")
                    DispatchQueue.main.async {
                        self.cityDeathsRankList = decodedResponse.map { casesResult in
                            return CityData(
                                areaName: casesResult.areaName,
                                areaCode: casesResult.areaCode,
                                cityCasesToday: casesResult.newCases ?? 0,
                                cityDeathsToday: casesResult.newDeaths ?? 0,
                                cityTotalCases: casesResult.cumCases ?? 0,
                                cityTotalDeaths: casesResult.cumDeaths ?? 0
                            )
                        }
                        self.cityDeathLastUpdateTime = Date()
                        success(decodedResponse)
                    }
                } catch let decodeError {
                    print("Decode error: \(decodeError)")
                    failure(decodeError as NSError)
                }
            }
        }.resume()
    }
    
    public func fetchCaseByPostcode(postcode: String, callback: @escaping ()->Void) {
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
                    if decodedResponse.count > 0 {
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
                            callback()
                        }
                    } else {
                        print("no result")
                        callback()
                    }
                } catch let decodeError {
                    print("Decode error: \(decodeError)")
                    callback()
                }
            }
        }.resume()
    }
    
    func getGeolocation() {
        locationManager.getPostcodeFromLocation { _ in
            if let postcode = self.locationManager.getPostcode() {
                self.fetchCaseByPostcode(postcode: postcode) {
                    print("current data received")
                }
            }
        }
    }
}
