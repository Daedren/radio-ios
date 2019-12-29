import Foundation
import SwiftUI

struct TrackView: View {
    
    let track: TrackViewModel

    var body: some View {
        HStack {
            Text("\(track.artist) - \(track.title)")
            if track.startsIn != "" {
                Text("in \(track.startsIn)")
                    .foregroundColor(Color.gray)
            }
            if track.endsAt != "" {
                Text(" \(track.endsAt) ago")
                    .foregroundColor(Color.gray)
            }
        }
    }
    
}
