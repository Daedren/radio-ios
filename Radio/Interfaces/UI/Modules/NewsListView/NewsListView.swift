import SwiftUI
import Radio_interfaces


struct NewsListView<P: NewsListPresenter>: View {
    @ObservedObject var presenter: P
    var properties: NewsListProperties
    
    init(presenter: P, properties: NewsListProperties) {
        self.presenter = presenter
        self.properties = properties
    }
    
    var body: some View {
            List(presenter.returnedValues) {
                NewsEntryView(viewModel: $0)
            }
//            .styledList()
            .navigationBarTitle(properties.titleBar)
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListConfigurator().configureFake()
            .preferredColorScheme(.dark)
    }
}
