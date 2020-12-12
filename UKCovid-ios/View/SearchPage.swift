//
//  SearchPage.swift
//  UKCovid-ios
//
//  Created by Suica on 16/10/2020.
//

import MapKit
import SwiftUI


struct SearchPage: View {
    @EnvironmentObject var citiesVirusData: CitiesVirusData
    @Namespace private var animation
    @State private var isZommed: Bool = false
    @State private var searchText: String = ""
    @State private var isDisplaying: Bool = false
    @State private var isLoading: Bool = false
    private var defaultPadding: CGFloat = 10
    private var frameWidth: CGFloat {
        isZommed ? .infinity : 300
    }
    private var searchLineHeight: CGFloat {
        isZommed ? 52 : 44
    }
    private var searchButtonIcon: String {
        isZommed ? "magnifyingglass.circle.fill" : "magnifyingglass.circle"
    }
    private var searchBarBgColor: Color = Color.input
    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300)),
        GridItem(.adaptive(minimum: 200, maximum: 300))
    ]
    private func getElementWidth(geometryWidth: CGFloat) -> CGFloat {
        return max(frameWidth, geometryWidth - defaultPadding)
    }
    
    private func getPostcodeData(postcode: String, success: (()->Void)?) {
        self.isLoading.toggle()
        citiesVirusData.fetchCaseByPostcode(postcode: postcode) {
            self.isLoading.toggle()
            success?()
        }
    }
    
    
    
    private func getSearchBar() -> some View {
        return HStack {
            TextField("Input the city postcode", text: $searchText)
//                .disabled(!isZommed)
                .frame(height: searchLineHeight)
                .padding(.leading)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: searchText, perform: { value in
                    print("searching \(value)")
                })
                .matchedGeometryEffect(id: "searching bar text field", in: animation)
            Image(systemName: searchButtonIcon)
                .frame(width: searchLineHeight, height: searchLineHeight)
                .matchedGeometryEffect(id: "searching bar icon", in: animation)
                .onTapGesture {
                    getPostcodeData(postcode: self.searchText.trimmingCharacters(in: .whitespacesAndNewlines)) {
                        if citiesVirusData.currentCityData != nil {
                            self.isDisplaying.toggle()
                        }
                    }
                }
        }
        .foregroundColor(.text)
        .background(searchBarBgColor)
        .border(radius: 10)
        .matchedGeometryEffect(id: "searching bar", in: animation)
        .padding()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isZommed {
                    VStack {
                        getSearchBar()
                            .onTapGesture {
                                print("click bar")
                            }
                        Spacer()
                    }
                    .frame(width: geometry.size.width)
                    .background(
                        Rectangle()
                            .fill(Color.background)
                            .edgesIgnoringSafeArea(.all)
                    )
                    .onTapGesture {
                        print("Click")
                        withAnimation(.spring()) {
                            self.isZommed.toggle()
                        }
                    }
                    .zIndex(2.0)
                    
                    Spacer()
                } else {
                    VStack {
                        HStack(alignment: .center) {
                            getSearchBar()
                                .onTapGesture {
                                    print("Click")
                                    withAnimation(.spring()) {
                                        self.isZommed.toggle()
                                    }
                                }
                        }
                        .frame(minHeight: geometry.size.height * 0.5)
                        HStack {
                            if citiesVirusData.currentCityData != nil {
                                CasesDetail(cityData: Binding($citiesVirusData.currentCityData)!)
                            } else if citiesVirusData.locationManager.getPostcode() != nil {
                                Button("Get the data of \(citiesVirusData.locationManager.getPostcode() ?? "NaN")") {
                                    getPostcodeData(postcode: citiesVirusData.locationManager.getPostcode()!) {
                                        print(citiesVirusData.currentCityData ?? "")
                                    }
                                }
                            } else if citiesVirusData.locationManager.checkExistingLocation() {
                                Text("Your current locatioin was not supported")
                            } else {
                                VStack {
                                    Button("Change the setting of location") {citiesVirusData.locationManager.getAuthorizationAgain()}
                                        .foregroundColor(.white)
                                        .padding()
                                        .border(radius: 10, width: 1, color: .blue, backgroundColor: .blue)
                                        .padding(.bottom, 70)
                                }
                            }
                        }
                        .frame(minHeight: geometry.size.height * 0.5)
                    }
                    .zIndex(1.0)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isDisplaying) {
                VStack {
                    Spacer()
                    CityDetail(cityData: citiesVirusData.currentCityData!)
                    Spacer()
                }
            }
        }
    }
}

struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
            .environmentObject(CitiesVirusData())
    }
}
