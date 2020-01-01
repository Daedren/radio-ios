//
//  ProgressBar.swift
//  SwiftUIProgressBar
//
//  Created by Gualtiero Frigerio on 26/07/2019.
//  Copyright © 2019 Gualtiero Frigerio. All rights reserved.
//
//  Based on https://dev.to/gualtierofr/progress-bar-in-swiftui-24a3
import SwiftUI

struct ProgressBar: View {
    let barHeight: CGFloat = 20.0
    var value:CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .trailing) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.secondarySystemBackground))
                        .cornerRadius(self.barHeight)
                    Rectangle()
                        .fill(Color(.systemTeal))
                        .frame(minWidth: 0, idealWidth:self.getProgressBarWidth(geometry: geometry),
                               maxWidth: self.getProgressBarWidth(geometry: geometry))
                        .cornerRadius(self.barHeight)
                        .animation(.linear(duration: 1.0))
                }
                .frame(height: self.barHeight)
            }.frame(height: self.barHeight)
        }.frame(height: self.barHeight + 10)
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
        let track = ProgressBar(value: 0.5)
        return track
    }
}

