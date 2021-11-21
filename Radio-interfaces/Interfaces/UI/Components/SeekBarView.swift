import Foundation
import SwiftUI

public struct SeekBarView: View {
    
    var track: CurrentTrackViewModel
    
    public init(track: CurrentTrackViewModel) {
        self.track = track
    }
    
    public var body: some View {
        VStack {
            track.percentage.map{ProgressBar(
                value: CGFloat($0),
                backgroundColor: Color(.secondarySystemBackground),
                fillColor: Color(.systemTeal))}
            HStack(spacing: 0) {
                Text("\(track.startTag ?? "")")
                    .inExpandingRectangle(alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                Text("\(track.endTag ?? "")")
                    .inExpandingRectangle(alignment: .trailing)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding([.leading,.trailing], 20.0)
    }
    
}
public struct SeekBarView_Previews: PreviewProvider {
    public static var previews: some View {
        let track = CurrentTrackViewModel.stubCurrent()
        let v = SeekBarView(track: track)
        return v
    }
}

extension View {
    func inExpandingRectangle(alignment: Alignment) -> some View {
        ZStack(alignment: alignment) {
            Rectangle()
                .fill(Color.clear)
            self
        }
    }
}
