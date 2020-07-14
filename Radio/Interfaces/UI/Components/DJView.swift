import Foundation
import SwiftUI
import KingfisherSwiftUI
import Radio_app

struct DJView: View {
    
    let dj: DJViewModel
    var action: () -> () = {}
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing){
                KFImage(self.dj.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(Color(.label))
                    .frame(width: 150.0,
                           alignment: .center)
                    .clipShape(Circle())
                Button(action: {
                    self.action()
                }) {
                    Image(systemName: "play.fill")
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

struct DJView_Previews: PreviewProvider {
    static var previews: some View {
        let dj = DJViewModel.stub()
        let v = DJView(dj: dj)
        return v
    }
}
