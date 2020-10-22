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
    var backgroundColor: Color?
    private let processesOfDrawing: [Any] = [BorderEdge.topLeft, Side.top, BorderEdge.topRight, Side.right, BorderEdge.bottomRight, Side.bottom, BorderEdge.bottomLeft, Side.left]
    
    func drawBorders(at path: inout Path, in size: CGSize) {
        let drawingBorders = getDrawingBorder()
        let drawingEdges = getDrawingEdge(when: drawingBorders)
        var currentPoint: CGPoint = CGPoint(x: 0, y: 0) // record the end point of last line in order to check if move function is necessary
        var isIgnoreStraight: Bool = false // when border was ignored, use move function to jump to other line start point
        path.move(to: currentPoint)
        for process in processesOfDrawing {
            if process is Side {
                let side = process as! Side
                if drawingBorders.contains(side) {
                    let points: [CGPoint] = identifyExtremityPoint(to: side, at: drawingEdges, in: size)
                    if points.count > 0{
                        let startPoint = points[0]
                        let endPoint = points[1]
                        if currentPoint != startPoint && isIgnoreStraight == true {
                            path.move(to: startPoint)
                        }
                        path.addLine(to: endPoint)
                        currentPoint = endPoint
                        isIgnoreStraight = false
                    }
                } else {
                    isIgnoreStraight = true
                }
            } else if process is BorderEdge {
                let edge: BorderEdge = process as! BorderEdge
                if drawingEdges.contains(edge) {
                    let points = getCurlLinePoints(to: edge, in: size)
                    let startPoint = points[0]
                    let endPoint = points[1]
                    let controlPoint = points[2]
                    if currentPoint != startPoint {
                        path.move(to: startPoint)
                    }
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
            let edgeName = edgesAtSide[0].rawValue
            let range = edgeName.range(of: side.rawValue)
            let index = edgeName.distance(from: edgeName.startIndex, to: range!.lowerBound)
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
    
    func drawingPath(in geometry: GeometryProxy) -> Path {
        Path { path in
            drawBorders(at: &path, in: geometry.size)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            drawingPath(in: geometry)
                .stroke(color, lineWidth: width)
            if borders == [.all] && (backgroundColor != nil) {
                drawingPath(in: geometry)
                    .fill(backgroundColor!)
            }
        }
    }
}

extension View {
    func border(radius: CGFloat, width: CGFloat = 1, edges: [Edge.Set] = [.all], color: Color = Color.gray, notCurveEdges: [BorderEdge] = [], backgroundColor: Color? = nil) -> some View {
        cornerRadius(radius)
            .background(
                RoundBorder(width: width, color: color, borders: edges, notCurveEdges: notCurveEdges, radius: radius, backgroundColor: backgroundColor)
        )
    }
}

struct ViewExtension_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Text("leading")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.leading], color: Color.black, backgroundColor: Color.red)
                Text("top")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.top], color: Color.black, backgroundColor: Color.red)
                Text("trailing")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.trailing], color: Color.black, backgroundColor: Color.red)
                Text("vertical")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.vertical], color: Color.black, backgroundColor: Color.red)
            }
            HStack {
                Text("top and left")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.top, .leading], color: Color.black, notCurveEdges: [.topRight, .bottomLeft], backgroundColor: Color.red)
                Text("top and right")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.top, .trailing], color: Color.black, notCurveEdges: [.topLeft, .bottomRight], backgroundColor: Color.red)
                Text("right and bottom")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.trailing, .bottom], color: Color.black, notCurveEdges: [.topRight, .bottomLeft], backgroundColor: Color.red)
            }
            HStack {
                Text("horizontal")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.horizontal], color: Color.black, backgroundColor: Color.red)
                Text("vertical")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.vertical], color: Color.black, backgroundColor: Color.red)
            }
            HStack {
                Text("leading and vertical")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.leading, .vertical], color: Color.black, backgroundColor: Color.red)
                Text("leading and vertical")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.leading, .vertical], color: Color.black, notCurveEdges: [.topRight, .bottomRight],  backgroundColor: Color.red)
            }
            HStack {
                Text("top and horizontal")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.top, .horizontal], color: Color.black, notCurveEdges: [.topLeft, .topRight], backgroundColor: Color.red)
                Text("bottom and horizontal")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.bottom, .horizontal], color: Color.black, notCurveEdges: [.bottomLeft, .bottomRight],  backgroundColor: Color.red)
            }
            HStack {
                Text("all")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.all], color: Color.black, backgroundColor: Color.red)
                Text("left button")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.all], color: Color.black, notCurveEdges: [.topRight, .bottomRight], backgroundColor: Color.red)
                Text("right button")
                    .padding()
                    .border(radius: 10, width: 1, edges: [.all], color: Color.black, notCurveEdges: [.topLeft, .bottomLeft], backgroundColor: Color.red)
            }
        }
    }
}
