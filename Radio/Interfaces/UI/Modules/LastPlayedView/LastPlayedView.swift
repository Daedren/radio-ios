import SwiftUI
import Combine
import Radio_interfaces

struct LastPlayedView<P: LastPlayedPresenter>: View {
    @ObservedObject var presenter: P
    
    var body: some View {
            VStack(spacing: 0.0){
//                HStack(spacing: 10.0){
//                    Text("Last Played")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                    Spacer()
//                }
//                .padding(.leading, 10.0)
//                .frame(height: 100.0)
//                .background(RadioColors.systemBackground)
                
                SongList(content: self.presenter.lastPlayed)
            }
        .navigationBarTitle("Last Played")
        .background(RadioColors.systemBackground)
    }
}

struct LastPlayedView_Previews: PreviewProvider {
    static var previews: some View {
        LastPlayedConfigurator().configureFake()
            .environment(\.colorScheme, .dark)
    }
}
