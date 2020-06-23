import SwiftUI

struct NewsListView: View {
    @ObservedObject var presenter: NewsListPresenterImp
    var properties: NewsListProperties
    
    init(presenter: NewsListPresenterImp, properties: NewsListProperties) {
        self.presenter = presenter
        self.properties = properties
    }
    
    var body: some View {
        NavigationView {
            List(presenter.returnedValues) {
                NewsEntryView(viewModel: $0)
            }
            .navigationBarTitle(properties.titleBar)
        }
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListConfigurator().configure()
    }
}
