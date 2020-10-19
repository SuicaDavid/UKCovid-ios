//
//  CasesRankRequest.swift
//  UKCovid-ios
//
//  Created by Suica on 19/10/2020.
//

import Foundation

enum SortBy: String {
    case newCase = "new_cases"
}
struct CasesRequestFormat{
    var sortby: SortBy
    var order: Int
    var numperpage: Int
    var pageno: Int
}
struct CasesResult: Codable, Identifiable {
    var id: String { areaCode }
    
    var areaCode: String
    var areaName: String
    var date: String
    var cumCases: Int?
    var cumDeaths: Int?
    var newCases: Int?
    var newDeaths: Int?
}
