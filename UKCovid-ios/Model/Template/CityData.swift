//
//  Case.swift
//  UKCovid-ios
//
//  Created by Suica on 14/10/2020.
//

import Foundation

struct CityData: Identifiable {
    var id: String { areaCode }
    var areaName: String
    var areaCode: String
    var cityCasesToday: Int
    var cityDeathsToday: Int
    var cityTotalCases: Int
    var cityTotalDeaths: Int
    var cityCasesRecord: [DailyCases] = [DailyCases]()
    var cityDeathsRecord: [DailyCases] = [DailyCases]()
    
    var cases: [caseData] {
        [
            caseData(caseName: "Daily Cases", caseNumber: cityCasesToday),
            caseData(caseName: "Total Cases", caseNumber: cityTotalCases),
            caseData(caseName: "Daily Deaths", caseNumber: cityDeathsToday),
            caseData(caseName: "Total Deaths", caseNumber: cityTotalDeaths)
        ]
    }
}

struct caseData: Hashable {
    var caseName: String
    var caseNumber: Int
}

struct DailyCases {
    var date: Date
    var cases: Int
    
}
