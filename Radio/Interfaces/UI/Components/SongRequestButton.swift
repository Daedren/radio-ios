import Foundation
import SwiftUI

struct SongRequestButton: View {
    
    let index: Int
    let track: SearchedTrackViewModel
    var action: ((Int) -> Void)?
    
    var body: some View {
        Button(action: {
            self.action?(self.index)
        }) {
            Text(self.track.requestable ? "Request" : "Requestable soon")
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .opacity(self.track.requestable ? 1 : 0.4)
    }

}

struct SongRequestButton_Previews: PreviewProvider {
    static var previews: some View {
        var stub = SearchedTrackViewModel.stub()
        stub.requestable = false
        return SongRequestButton(index: 0, track: stub, action: nil)
    }
}
