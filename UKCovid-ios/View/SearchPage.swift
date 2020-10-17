//
//  SearchPage.swift
//  UKCovid-ios
//
//  Created by Suica on 16/10/2020.
//

import SwiftUI

//struct RoundBorder: View {
//    var borders
//    var body: some View {
//        GeometryReader { geometry in
//            Path { path in
//                let width = min(geometry.size.width, geometry.size.height)
//                let height = width * 0.75
//                let spacing = width * 0.030
//                let middle = width / 2
//                let topWidth = 0.226 * width
//                let topHeight = 0.488 * height
//
//                path.addLines([
//                    CGPoint(x: middle, y: spacing),
//                    CGPoint(x: middle - topWidth, y: topHeight - spacing),
//                    CGPoint(x: middle, y: topHeight / 2 + spacing),
//                    CGPoint(x: middle + topWidth, y: topHeight - spacing),
//                    CGPoint(x: middle, y: spacing)
//                ])
//            }
//        }
//    }
//}

struct SearchPage: View {
    @Namespace private var animation
    @State private var isZommed: Bool = false
    @State private var searchText: String = ""
    private var defaultPadding: CGFloat = 10
    private var frameWidth: CGFloat {
        isZommed ? .infinity : 300
    }
    private var frameHeight: CGFloat {
        isZommed ? 64 : 56
    }
    private var searchLineHeight: CGFloat {
        isZommed ? 52 : 44
    }
    private var searchButtonIcon: String {
        isZommed ? "magnifyingglass.circle.fill" : "magnifyingglass.circle"
    }
    private let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 300)),
        GridItem(.adaptive(minimum: 200, maximum: 300))
    ]
    private func getElementWidth(geometryWidth: CGFloat) -> CGFloat {
        return max(frameWidth, geometryWidth - defaultPadding)
    }
    var body: some View {
        
        VStack {
            HStack {
                TextField("Sth", text: $searchText)
                    .disabled(!isZommed)
                    .frame(height: searchLineHeight)
                    .padding(.leading)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: searchText, perform: { value in
                        print("searching \(value)")
                    })
                Image(systemName: "magnifyingglass.circle")
                    .frame(width: searchLineHeight, height: searchLineHeight)
            }
            .overlay(
                RoundedRectangle(cornerRadius: defaultPadding)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .matchedGeometryEffect(id: "searching bar", in: animation)
            .padding()
            .onTapGesture {
                print("Click")
                withAnimation(.spring()) {
                    self.isZommed.toggle()
                }
            }
            HStack {
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
//                    .overlay(RoundBorder())
            
            }
            .padding()
        }
    }
}

struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
    }
}
