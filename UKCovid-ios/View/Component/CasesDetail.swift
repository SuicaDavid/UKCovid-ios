//
//  CasesDetail.swift
//  UKCovid-ios
//
//  Created by Suica on 22/10/2020.
//

import SwiftUI

struct CasesDetail: View {
    @Binding var cityData: CityData
    
    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300)),
        GridItem(.adaptive(minimum: 200, maximum: 300))
    ]
    
    
    var body: some View {
        VStack {
            Text("\(cityData.areaName)")
                .padding(.top)
            LazyVGrid(columns: columns) {
                ForEach(cityData.cases, id: \.self) { item in
                    VStack {
                        Text("\(item.caseName)")
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top)
                                        .foregroundColor(Color.gray), alignment: .bottom)
                        Text("\(item.caseNumber)")
                    }
                    .padding()
                }
            }
        }
        .border(radius: 10, edges: [.vertical])
        .padding()
    }
}


struct CasesDetail_Previews: PreviewProvider {
    static var previews: some View {
        CasesDetail(cityData: .constant(CityData(areaName: "London", areaCode:
                                                    "W2 3DR", cityCasesToday: 100, cityDeathsToday: 10, cityTotalCases: 1000, cityTotalDeaths: 100)))
    }
}
