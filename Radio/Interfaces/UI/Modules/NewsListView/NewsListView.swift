import SwiftUI

struct NewsListView: View {
    @ObservedObject var presenter: NewsListPresenterImp
    
    var body: some View {
        List(presenter.returnedValues) {
            NewsEntryView(viewModel: $0)
        }
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListConfigurator().configure()
    }
}
