//
//  Case.swift
//  UKCovid-ios
//
//  Created by Suica on 14/10/2020.
//

import Foundation

struct CityData: Identifiable {
    var id: String
    var cityCasesToday: Int
    var cityDeathsToday: Int
    var cityTotalCases: Int
    var cityTotalDeaths: Int
    var cityCasesRecord: [DailyCases]
    var cityDeathsRecord: [DailyCases]
}

struct DailyCases {
    var date: Date
    var cases: Int
    
}
