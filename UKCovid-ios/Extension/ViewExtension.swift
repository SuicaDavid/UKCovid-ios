//
//  ViewExtension.swift
//  UKCovid-ios
//
//  Created by Suica on 17/10/2020.
//

import SwiftUI

struct RoundBorder: View {

    
    var width: CGFloat = 1
    var color: Color = Color.gray
    var borders: [Edge.Set] = [.top, .bottom,.leading, .trailing]
    var radius: CGFloat = 0
    enum Side: CaseIterable {
        case top
        case right
        case bottom
        case left
    }
    func drawBorders(at path: inout Path, in size: CGSize) {
        let drawingBorders = getDrawingBorder()
        var pointsCollection = [[CGPoint]]()
        var controlStartPoints = [CGPoint]()
        var controlEndPoints = [CGPoint]()
        path.move(to: CGPoint(x: 0, y: 0))
        for side in drawingBorders {
            if radius != 0 {
                pointsCollection.append(getCurlLine(to: side, in: size))
                controlStartPoints.append(getStraightLine(to: side, in: size)[0])
                controlEndPoints.append(getStraightLine(to: side, in: size)[1])
            } else {
                pointsCollection.append(getStraightLine(to: side, in: size))
            }
        }
        for (key, points) in pointsCollection.enumerated() {
            if radius == 0 {
                path.move(to: points[0])
                path.addLines(points)
            } else {
                path.move(to: points[0])
                path.addQuadCurve(to: points[1], control: controlStartPoints[key])
                path.addLine(to: points[2])
                path.addQuadCurve(to: points[3], control: controlEndPoints[key])
            }
        }
    }
    func getDrawingBorder() ->[Side] {
        var drawingBordersSet: Set<Side> = []
        if borders.contains(.all) {
            drawingBordersSet.insert([.top, .right,.bottom, .left])
            return Array(drawingBordersSet)
        }
        if borders.contains(.vertical) {drawingBordersSet.insert([.top,.bottom])}
        if borders.contains(.horizontal) {drawingBordersSet.insert([.right, .left])}
        if borders.contains(.top) {drawingBordersSet.insert(Side.top)}
        if borders.contains(.trailing) {drawingBordersSet.insert(Side.right)}
        if borders.contains(.bottom) {drawingBordersSet.insert(Side.bottom)}
        if borders.contains(.leading) {drawingBordersSet.insert(Side.left)}
        return Array(drawingBordersSet)
    }
    
    func getStraightLine(to side: Side, in size: CGSize) -> [CGPoint] {
        switch side {
        case .top:
            return [CGPoint(x:0, y: 0), CGPoint(x:size.width, y: 0)]
        case .right:
            return [CGPoint(x:size.width, y: 0), CGPoint(x: size.width, y: size.height)]
        case .bottom:
            return [CGPoint(x: size.width, y: size.height), CGPoint(x: 0, y: size.height)]
        case .left:
            return [CGPoint(x: 0, y: size.height), CGPoint(x:0, y: 0)]
        }
    }
    
    func getCurlLine(to side: Side, in size: CGSize) -> [CGPoint] {
        switch side {
        case .top:
            return [
                CGPoint(x: 0, y: 0 + radius),
                CGPoint(x: 0 + radius, y: 0),
                CGPoint(x: size.width - radius, y: 0),
                CGPoint(x: size.width, y: radius)
            ]
        case .right:
            return [
                CGPoint(x: size.width - radius, y: 0),
                CGPoint(x: size.width, y: radius),
                CGPoint(x: size.width, y: size.height - radius),
                CGPoint(x: size.width - radius, y: size.height)
            ]
        case .bottom:
            return [
                CGPoint(x: size.width, y: size.height - radius),
                CGPoint(x: size.width - radius, y: size.height),
                CGPoint(x: 0 + radius, y: size.height),
                CGPoint(x: 0, y: size.height - radius)
            ]
        case .left:
            return [
                CGPoint(x: 0 + radius, y: size.height),
                CGPoint(x: 0, y: size.height - radius),
                CGPoint(x: 0, y: 0 + radius),
                CGPoint(x: 0 + radius, y: 0)
            ]
        }
    }

    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                drawBorders(at: &path, in: geometry.size)
            }
            .stroke(color, lineWidth: width)
        }
    }
}

extension View {
    func border(width: CGFloat = 1, edges: [Edge.Set] = [.all], color: Color = Color.gray, radius: CGFloat) -> some View {
        cornerRadius(radius)
            .background(
            RoundBorder(width: width, color: color, borders: edges, radius: radius)
        )
    }
}

struct ViewExtension_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("leading")
                .padding()
                .border(width: 1, edges: [.leading], color: Color.black, radius: 10)
            Text("top")
                .padding()
                .border(width: 1, edges: [.top], color: Color.black, radius: 10)
            Text("trailing")
                .padding()
                .border(width: 1, edges: [.trailing], color: Color.black, radius: 10)
            Text("bottom")
                .padding()
                .border(width: 1, edges: [.bottom], color: Color.black, radius: 10)
            Text("vertical")
                .padding()
                .border(width: 1, edges: [.vertical], color: Color.black, radius: 10)
            Text("horizontal")
                .padding()
                .border(width: 1, edges: [.horizontal], color: Color.black, radius: 10)
            Text("leading and vertical")
                .padding()
                .border(width: 1, edges: [.leading, .vertical], color: Color.black, radius: 10)
            Text("all")
                .padding()
                .border(width: 1, edges: [.all], color: Color.black, radius: 10)
            Text("all")
                .padding()
                .border(width: 1, edges: [.all], color: Color.black, radius: 0)
        }
    }
}
