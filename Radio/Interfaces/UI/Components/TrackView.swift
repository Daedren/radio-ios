import Foundation
import SwiftUI

struct TrackView: View {
    
    let track: TrackViewModel

    var body: some View {
        HStack {
            Text("\(track.artist) - \(track.title)")
                .foregroundColor(track.requested ? Color(.systemTeal) : Color(.label))
            Spacer()
            if track.startsIn != "" {
                Text("\(track.startsIn)")
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.trailing)
            }
            if track.endsAt != "" {
                Text(" \(track.endsAt) ago")
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        let stub = TrackViewModel.stub()
        stub.requested = true
        return TrackView(track: stub)
    }
}
