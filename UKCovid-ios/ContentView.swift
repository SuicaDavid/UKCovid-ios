//
//  ContentView.swift
//  UKCovid-ios
//
//  Created by Suica on 10/10/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var citiesVirusData: CitiesVirusData
    @State private var selection = 0

    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selection) {
                    HomePage()
                        .tabItem {
                            VStack {
                                Image(systemName: "house")
                                Text("Home")
                            }
                        }
                        .tag(0)
                    SearchPage()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                        .tag(1)
                }
                if citiesVirusData.isLoading {
                    ProgressView("Loading")
                        .frame(width: 180, height: 150)
                        .padding()
                        .border(radius: 10, backgroundColor: Color.white)
                }
            }
        }
        .onAppear {
            citiesVirusData.initCitiesVirusData()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CitiesVirusData())
    }
}
