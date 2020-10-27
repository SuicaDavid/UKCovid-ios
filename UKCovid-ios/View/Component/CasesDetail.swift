//
//  CasesDetail.swift
//  UKCovid-ios
//
//  Created by Suica on 22/10/2020.
//

import SwiftUI

struct CasesDetail: View {
    @Binding var cityData: CityData
    @State var hasMoreDetail: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300)),
        GridItem(.adaptive(minimum: 200, maximum: 300))
    ]
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }
    
    func getCaseDataRow(caseName: String, caseNumber: Int) -> some View {
        return VStack {
            Text("\(caseName)")
                .padding(.horizontal)
                .padding(.bottom, 5)
                .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top)
                            .foregroundColor(Color.gray), alignment: .bottom)
            Text("\(caseNumber)")
        }
        .padding()
    }
    func getCaseDataRow(caseName: String, caseNumber: Double) -> some View {
        return VStack {
            Text("\(caseName)")
                .padding(.horizontal)
                .padding(.bottom, 5)
                .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top)
                            .foregroundColor(Color.gray), alignment: .bottom)
            Text("\(numberFormatter.string(from: NSNumber(value: caseNumber))!)")
        }
        .padding()
    }
    
    
    var body: some View {
        VStack {
            Text("\(cityData.areaName)")
                .padding(.top)
            LazyVGrid(columns: columns) {
                ForEach(cityData.cases, id: \.self) { item in
                    getCaseDataRow(caseName: item.caseName, caseNumber: item.caseNumber)
                }
                
                if hasMoreDetail {
                    getCaseDataRow(caseName: "Total Mortality", caseNumber: Double(cityData.cityTotalDeaths)/Double(cityData.cityTotalCases))
                    getCaseDataRow(caseName: "Daily Mortality", caseNumber: Double(cityData.cityDeathsToday)/Double(cityData.cityCasesToday))
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
                                                    "W2 3DR", cityCasesToday: 100, cityDeathsToday: 10, cityTotalCases: 1000, cityTotalDeaths: 100)), hasMoreDetail: true)
    }
}
