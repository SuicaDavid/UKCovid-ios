//
//  Api.swift
//  UKCovid-ios
//
//  Created by Suica on 18/10/2020.
//

import SwiftUI

class Api {
    enum path: String {
        case newCases = "/newcases"
    }
    public static let newCases = ServerURL + path.newCases.rawValue
    public static let searchCases = ServerURL + path.newCases.rawValue
}
