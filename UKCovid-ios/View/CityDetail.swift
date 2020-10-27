//
//  CityDetail.swift
//  UKCovid-ios
//
//  Created by Suica on 22/10/2020.
//

import SwiftUI

struct CityDetail: View {
    @State var cityData: CityData
    
    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300)),
        GridItem(.adaptive(minimum: 200, maximum: 300))
    ]
    var body: some View {
        VStack {
            CasesDetail(cityData: $cityData, hasMoreDetail: true)
            Spacer()
        }
    }
}

struct CityDetail_Previews: PreviewProvider {
    static var previews: some View {
        CityDetail(cityData: CityData(areaName: "London", areaCode:
                                                    "W2 3DR", cityCasesToday: 100, cityDeathsToday: 10, cityTotalCases: 1000, cityTotalDeaths: 100))
    }
}
