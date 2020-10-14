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
}
