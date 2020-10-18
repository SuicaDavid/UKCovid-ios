//
//  SearchPage.swift
//  UKCovid-ios
//
//  Created by Suica on 16/10/2020.
//

import SwiftUI



struct SearchPage: View {
    @Namespace private var animation
    @State private var isZommed: Bool = false
    @State private var searchText: String = ""
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
    private var searchBarBgColor: Color = Color.white
    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300)),
        GridItem(.adaptive(minimum: 200, maximum: 300))
    ]
    private func getElementWidth(geometryWidth: CGFloat) -> CGFloat {
        return max(frameWidth, geometryWidth - defaultPadding)
    }
    
    private func getSearchBar() -> some View {
        return HStack {
            TextField("Sth", text: $searchText)
                .disabled(!isZommed)
                .frame(height: searchLineHeight)
                .padding(.leading)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: searchText, perform: { value in
                    print("searching \(value)")
                })
            Image(systemName: searchButtonIcon)
                .frame(width: searchLineHeight, height: searchLineHeight)
        }
        .background(searchBarBgColor)
        .border(radius: 10)
        .matchedGeometryEffect(id: "searching bar", in: animation)
        .padding()
    }
    
    var body: some View {
        ZStack {
            if isZommed {
                VStack {
                    getSearchBar()
                    
                    Spacer()
                }
                .zIndex(2.0)
                .onTapGesture {
                    print("Click")
                    withAnimation(.spring()) {
                        self.isZommed.toggle()
                    }
                }
                .background(Color.black)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.7)
            }
            VStack {
                Spacer()
                getSearchBar()
                    .onTapGesture {
                        print("Click")
                        withAnimation(.spring()) {
                            self.isZommed.toggle()
                        }
                    }
                Spacer()
                VStack {
                    Text("London")
                    LazyVGrid(columns: columns) {
                        ForEach(1...6, id: \.self) { item in
                            VStack {
                                Text("Cases Today")
                                    .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top)
                                                .foregroundColor(Color.gray), alignment: .bottom)
                                Text("1000")
                            }
                            .padding()
                        }
                    }
                }
                .border(edges: [.vertical], radius: 10)
                .padding()
            }
            .zIndex(1.0)
        }
    }
}

struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
    }
}
