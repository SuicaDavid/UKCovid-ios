//
//  HomePage.swift
//  UKCovid-ios
//
//  Created by Suica on 13/10/2020.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var citiesVirusData: CitiesVirusData
    @State private var selectedTypeIndex: Int = 0
    private var dataList: [CityData] {
        selectedTypeIndex == 0 ? citiesVirusData.cityCasesRankList : citiesVirusData.cityDeathsRankList
    }
    

    
    private var elementSpan: CGFloat = 10
    
    func getCasesSelectButton(name: String, index: Int, isExtremity: Bool = false, geometry: GeometryProxy) -> some View {
        let edge: [Edge.Set] = [.all]
        var ignoreEdge: [BorderEdge] = [.bottomLeft,.bottomRight,.topRight,.topLeft]
        var radius: CGFloat = 10
        let isSelected = (index == selectedTypeIndex)
        let backgroundColor = (isSelected ? Color.gray : Color.white)
        let borderColor = (isSelected ? Color.blue : Color.gray)
        if isExtremity {
            if index == 0 {
                ignoreEdge = [.topRight, .bottomRight]
            } else if (index == -1) {
                ignoreEdge = [.topLeft, .bottomLeft]
            } else {
                radius = 0
            }
        }
        return HStack {
            Text(name)
                .fontWeight(isSelected ? .bold : .none)
                .frame(maxWidth: geometry.size.width/2)
                .padding(.vertical,elementSpan)
                .border(radius: radius, edges: edge, color: borderColor, notCurveEdges: ignoreEdge, backgroundColor: backgroundColor)
        }
        .onTapGesture {
            selectedTypeIndex = index
        }
    }
    
    func getCityCasesRow(cityDataIndex: Int) -> some View {
        var showingData: Int = 0
        let destination = CityDetail(cityData: dataList[cityDataIndex])
        let areaName = dataList[cityDataIndex].areaName
        if selectedTypeIndex == 0 {
            showingData = dataList[cityDataIndex].cityCasesToday
        } else if selectedTypeIndex == -1 {
            showingData = dataList[cityDataIndex].cityDeathsToday
        }
        return HStack {
            Text("\(cityDataIndex + 1):")
            NavigationLink(destination: destination) {
                HStack {
                    Text("\(areaName)")
                    Spacer()
                    Text("\(showingData)")
                }
                .foregroundColor(.black)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(elementSpan)
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                List {
                    HStack(spacing: 0) {
                        getCasesSelectButton(name: "Daily Cases", index: 0, isExtremity: true, geometry: geometry)
                        getCasesSelectButton(name: "Daily Death", index: -1, isExtremity: true, geometry: geometry)
                    }
                    .padding(elementSpan)
                    ForEach(0..<dataList.count, id: \.self) { index in
                        getCityCasesRow(cityDataIndex: index)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarHidden(true)
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(CitiesVirusData())
    }
}
