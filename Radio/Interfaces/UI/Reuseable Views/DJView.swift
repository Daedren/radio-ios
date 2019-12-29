import Foundation
import SwiftUI
import KingfisherSwiftUI

struct DJView: View {
    
    let dj: DJViewModel
    
    var body: some View {
        VStack {
            KFImage(self.dj.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150.0,
                       alignment: .center)
                .clipShape(Circle())
            Text(self.dj.name)
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
