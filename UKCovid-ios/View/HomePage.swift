//
//  HomePage.swift
//  UKCovid-ios
//
//  Created by Suica on 13/10/2020.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var citiesVirusData: CitiesVirusData
    @State private var cityRankList: [CasesResult] = [CasesResult]()
    @State private var selectedData: Int = 0
    
    private var elementSpan: CGFloat = 10
    
    func getCasesSelectButton(name: String, selectedIndex: Int, isExtremity: Bool = false) -> some View {
        var edge: [Edge.Set] = [.all]
        var radius = elementSpan
        if isExtremity {
            if selectedIndex == 0 {
                edge = [.leading]
            } else if (selectedIndex == -1) {
                edge = [.trailing]
            } else {
                edge = []
                radius = 0
            }
        }
        return Text("Daily Cases")
            .padding(elementSpan)
            .border(edges: edge, radius: radius)
    }
    
    func getCityCasesRow(cityDataIndex: Int) -> some View {
        HStack {
            Text("\(cityDataIndex + 1):")
            HStack {
                Text("\(cityRankList[cityDataIndex].areaName)")
                Spacer()
                Text("\(cityRankList[cityDataIndex].newCases ?? 0)")
            }
        }
        .padding(elementSpan)
    }
    var body: some View {
        List {
            HStack {
                getCasesSelectButton(name: "Daily Cases", selectedIndex: 0, isExtremity: true)
                getCasesSelectButton(name: "Daily Cases", selectedIndex: 1, isExtremity: false)
                getCasesSelectButton(name: "Daily Death", selectedIndex: -1, isExtremity: true)
            }
            .padding(elementSpan)
            ForEach(0..<cityRankList.count, id: \.self) { index in
                getCityCasesRow(cityDataIndex: index)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear {
            citiesVirusData.fetchCasesRank { rank in
                cityRankList = rank
            }
        }
        .navigationBarHidden(true)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(CitiesVirusData())
    }
}
