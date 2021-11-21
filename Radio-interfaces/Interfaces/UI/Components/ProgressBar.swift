//
//  ProgressBar.swift
//  SwiftUIProgressBar
//
//  Created by Gualtiero Frigerio on 26/07/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//
//  Based on https://dev.to/gualtierofr/progress-bar-in-swiftui-24a3
import SwiftUI

public struct ProgressBar: View {
    var barHeight: CGFloat
    var value:CGFloat
    var backgroundColor: Color
    var fillColor: Color
    
    public init(barHeight: CGFloat = 20.0, value: CGFloat, backgroundColor: Color, fillColor: Color) {
        self.barHeight = barHeight
        self.value = value
        self.backgroundColor = backgroundColor
        self.fillColor = fillColor
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .trailing) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(self.backgroundColor)
                        .cornerRadius(self.barHeight)
                    Rectangle()
                        .fill(self.fillColor)
                        .frame(minWidth: 0, idealWidth:self.getProgressBarWidth(geometry: geometry),
                               maxWidth: self.getProgressBarWidth(geometry: geometry))
                        .cornerRadius(self.barHeight)
                        .animation(.linear(duration: 1.0))
                }
                .frame(height: self.barHeight)
            }.frame(height: self.barHeight)
        }.frame(height: self.barHeight + (self.barHeight/2))
    }
    
    func getProgressBarWidth(geometry:GeometryProxy) -> CGFloat {
        let frame = geometry.frame(in: .global)
        return frame.size.width * value
    }
    
    func getPercentage(_ value:CGFloat) -> String {
        let intValue = Int(ceil(value * 100))
        return "\(intValue) %"
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        let track = ProgressBar(value: 0.5, backgroundColor: .gray, fillColor: .blue)
        return track
    }
}

