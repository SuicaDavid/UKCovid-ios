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
        var drawingBorders = [Side]()
        if borders.contains(.all) {
            return [.top, .right,.bottom, .left]
        } else if borders.contains(.vertical) {
            return [.top,.bottom]
        } else if borders.contains(.horizontal) {
            return [.right, .left]
        } else {
            if borders.contains(.top) {drawingBorders.append(Side.top)}
            if borders.contains(.trailing) {drawingBorders.append(Side.right)}
            if borders.contains(.bottom) {drawingBorders.append(Side.bottom)}
            if borders.contains(.leading) {drawingBorders.append(Side.left)}
        }
        return drawingBorders
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
        overlay(RoundBorder(width: width, color: color, borders: edges, radius: radius))
    }
}
