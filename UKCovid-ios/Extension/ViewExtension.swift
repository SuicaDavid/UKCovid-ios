//
//  ViewExtension.swift
//  UKCovid-ios
//
//  Created by Suica on 17/10/2020.
//

import SwiftUI

enum Side: String, CaseIterable {
    case top = "top"
    case right = "right"
    case bottom = "bottom"
    case left = "left"
}

enum BorderEdge: String, CaseIterable {
    // raw value is following the order of drawing
    case topLeft = "left top"
    case topRight = "top right"
    case bottomRight = "right bottom"
    case bottomLeft = "bottom left"
}
struct RoundBorder: View {

    
    var width: CGFloat = 1
    var color: Color = Color.gray
    var borders: [Edge.Set] = [.top, .bottom,.leading, .trailing]
    var notCurveEdges: [BorderEdge] = []
    var radius: CGFloat = 0
    private let processesOfDrawing: [Any] = [BorderEdge.topLeft, Side.top, BorderEdge.topRight, Side.right, BorderEdge.bottomRight, Side.bottom, BorderEdge.bottomLeft, Side.left]
    
    func drawBorders(at path: inout Path, in size: CGSize) {
        let drawingBorders = getDrawingBorder()
        let drawingEdges = getDrawingEdge(when: drawingBorders)
        path.move(to: CGPoint(x: 0, y: 0))
        for process in processesOfDrawing {
            if process is Side {
                let side = process as! Side
                if drawingBorders.contains(side) {
                    let points: [CGPoint] = identifyExtremityPoint(to: side, at: drawingEdges, in: size)
                    if points.count > 0{
                        path.addLines(points)
                    }
                }
            } else if process is BorderEdge {
                let edge: BorderEdge = process as! BorderEdge
                if drawingEdges.contains(edge) {
                    let points = getCurlLinePoints(to: edge, in: size)
                    let startPoint = points[0]
                    let endPoint = points[1]
                    let controlPoint = points[2]
                    path.move(to: startPoint)
                    path.addQuadCurve(to: endPoint, control: controlPoint)
                }
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
    
    func getDrawingEdge(when drawingBorders: [Side]) -> [BorderEdge] {
        return BorderEdge.allCases.filter { edge in
            !notCurveEdges.contains(edge) && drawingBorders.contains { edge.rawValue.contains($0.rawValue) }
        }
    }
    
    func identifyExtremityPoint(to side: Side, at drawingEdges: [BorderEdge], in size: CGSize) -> [CGPoint] {
        let edgesAtSide = drawingEdges.filter {return $0.rawValue.contains(side.rawValue)}
        if edgesAtSide.count == 2 {
            print("=====")
            edgesAtSide.forEach { print($0.rawValue) }
            print(side.rawValue)
            print(getCurlLinePoints(to: edgesAtSide[0], in: size))
            let edgeName = edgesAtSide[0].rawValue
            let range = edgeName.range(of: side.rawValue)
            let index = edgeName.distance(from: edgeName.startIndex, to: range!.lowerBound)
            print(index)
            if index == 0 { // the second element is the curl angle
                return [getCurlLinePoints(to: edgesAtSide[1], in: size)[1], getCurlLinePoints(to: edgesAtSide[0], in: size)[0]]
            } else {
                return [getCurlLinePoints(to: edgesAtSide[0], in: size)[1], getCurlLinePoints(to: edgesAtSide[1], in: size)[0]]
            }
        } else if edgesAtSide.count == 1 {
            let edgeName = edgesAtSide[0].rawValue
            let range = edgeName.range(of: side.rawValue)
            let index = edgeName.distance(from: edgeName.startIndex, to: range!.lowerBound)
            let curlLinePoints = getCurlLinePoints(to: edgesAtSide[0], in: size)
            if index == 0 { // the second element is the curl angle
                return [getStraightStartPoint(to: side, in: size), curlLinePoints[0]]
            } else {
                return [curlLinePoints[1], getStraightEndPoint(to: side, in: size)]
            }
        } else if edgesAtSide.count == 0 {
            return [getStraightStartPoint(to: side, in: size), getStraightEndPoint(to: side, in: size)]
        } else {
            return []
        }
    }
    
    func getStraightStartPoint(to side: Side, in size: CGSize) -> CGPoint {
        switch side {
        case .top:
            return CGPoint(x:0, y: 0)
        case .right:
            return CGPoint(x:size.width, y: 0)
        case .bottom:
            return CGPoint(x: size.width, y: size.height)
        case .left:
            return CGPoint(x: 0, y: size.height)
        }
    }
    func getStraightEndPoint(to side: Side, in size: CGSize) -> CGPoint {
        switch side {
        case .top:
            return CGPoint(x:size.width, y: 0)
        case .right:
            return CGPoint(x: size.width, y: size.height)
        case .bottom:
            return CGPoint(x: 0, y: size.height)
        case .left:
            return CGPoint(x:0, y: 0)
        }
    }
    
    func getCurlLinePoints(to edge: BorderEdge, in size: CGSize) -> [CGPoint] {
        switch edge {
        case .topLeft:
            return [
                CGPoint(x: 0, y: 0 + radius),
                CGPoint(x: 0 + radius, y: 0),
                CGPoint(x:0, y: 0)
            ]
        case .topRight:
            return [
                CGPoint(x: size.width - radius, y: 0),
                CGPoint(x: size.width, y: radius),
                CGPoint(x:size.width, y: 0)
            ]
        case .bottomRight:
            return [
                CGPoint(x: size.width, y: size.height - radius),
                CGPoint(x: size.width - radius, y: size.height),
                CGPoint(x: size.width, y: size.height)
            ]
        case .bottomLeft:
            return [
                CGPoint(x: 0 + radius, y: size.height),
                CGPoint(x: 0, y: size.height - radius),
                CGPoint(x: 0, y: size.height)
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
    func border(radius: CGFloat, width: CGFloat = 1, edges: [Edge.Set] = [.all], color: Color = Color.gray, notCurveEdges: [BorderEdge] = []) -> some View {
        cornerRadius(radius)
            .background(
                RoundBorder(width: width, color: color, borders: edges, notCurveEdges: notCurveEdges, radius: radius)
        )
    }
}

struct ViewExtension_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("leading")
                .padding()
                .border(radius: 10, width: 1, edges: [.leading], color: Color.black)
            Text("top")
                .padding()
                .border(radius: 10, width: 1, edges: [.top], color: Color.black)
            Text("trailing")
                .padding()
                .border(radius: 10, width: 1, edges: [.trailing], color: Color.black)
            Text("bottom")
                .padding()
                .border(radius: 10, width: 1, edges: [.bottom], color: Color.black)
            Text("vertical")
                .padding()
                .border(radius: 10, width: 1, edges: [.vertical], color: Color.black)
            Text("horizontal")
                .padding()
                .border(radius: 10, width: 1, edges: [.horizontal], color: Color.black)
            Text("leading and vertical")
                .padding()
                .border(radius: 10, width: 1, edges: [.leading, .vertical], color: Color.black)
            Text("all")
                .padding()
                .border(radius: 10, width: 1, edges: [.all], color: Color.black)
            Text("left button")
                .padding()
                .border(radius: 10, width: 1, edges: [.all], color: Color.black, notCurveEdges: [.topRight, .bottomRight])
            Text("right button")
                .padding()
                .border(radius: 10, width: 1, edges: [.all], color: Color.black, notCurveEdges: [.topLeft, .bottomLeft])
        }
    }
}
