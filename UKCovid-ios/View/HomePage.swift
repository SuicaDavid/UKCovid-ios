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
    
    func getCasesSelectButton(name: String, index: Int, isExtremity: Bool = false, geometry: GeometryProxy) -> some View {
        var edge: [Edge.Set] = [.all]
        var ignoreEdge: [BorderEdge] = [.bottomLeft,.bottomRight,.topRight,.topLeft]
        var radius: CGFloat = 10
        if isExtremity {
            if index == 0 {
                edge = [.vertical, .leading, .trailing]
                ignoreEdge = [.topRight, .bottomRight]
            } else if (index == -1) {
                edge = [.vertical, .trailing]
                ignoreEdge = [.topLeft, .bottomLeft]
            } else {
                edge = []
                radius = 0
            }
        }
        return HStack {
            Text("Daily Cases")
                .frame(maxWidth: geometry.size.width/2)
                .padding(.vertical,elementSpan)
                .border(radius: radius, edges: edge, notCurveEdges: ignoreEdge)
        }
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
        GeometryReader { geometry in
            List {
                HStack(spacing: 0) {
                    getCasesSelectButton(name: "Daily Cases", index: 0, isExtremity: true, geometry: geometry)
                    getCasesSelectButton(name: "Daily Death", index: -1, isExtremity: true, geometry: geometry)
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
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(CitiesVirusData())
    }
}
