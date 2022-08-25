import Foundation
import SwiftUI
import Kingfisher
import Radio_domain

public struct DJView: View {
    
    let dj: DJViewModel?
    let isPlaying: Bool
    var action: () -> () = {}
    
    public init(dj: DJViewModel?, isPlaying: Bool, action: @escaping () -> () = {}) {
        self.dj = dj
        self.isPlaying = isPlaying
        self.action = action
    }
    
    public var body: some View {
        VStack {
            self.dj.map{ dj in
                ZStack(alignment: .bottomTrailing){
                    KFImage(dj.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color(.label))
                        .frame(width: 150.0,
                               alignment: .center)
                        .clipShape(Circle())
                    Button(action: {
                        self.action()
                    }) {
                        Image(systemName: self.isPlaying ? "stop.fill" : "play.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(10.0)
                            .foregroundColor(Color(.label))
                    }
                    .frame(width: 40.0, height: 40.0)
                    .background(Color.red)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2.0))
                }
            }
        }
    }
}

struct DJView_Previews: PreviewProvider {
    static var previews: some View {
        let dj = DJViewModel.stub()
//        let radioDj = RadioDJ(id: 5, name: "asd", text: "asd", image: URL(string: "https://www.google.com")!, color: Color(red: 255, green: 0, blue: 0), visible: true, priority: 1)
//        let dj = DJViewModel(base: radioDj)
        let v = DJView(dj: dj, isPlaying: false)
        return v
    }
}
