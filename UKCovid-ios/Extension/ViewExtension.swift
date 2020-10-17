//
//  ViewExtension.swift
//  UKCovid-ios
//
//  Created by Suica on 17/10/2020.
//

import SwiftUI


extension View {
    public func border<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
