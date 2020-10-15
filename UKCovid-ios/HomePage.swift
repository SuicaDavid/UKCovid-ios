//
//  HomePage.swift
//  UKCovid-ios
//
//  Created by Suica on 13/10/2020.
//

import SwiftUI

struct HomePage: View {
    
    var body: some View{
        ScrollView {
            LazyVStack {
                ForEach(1...1000, id: \.self) { city in
                    Text("\(city)")
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
