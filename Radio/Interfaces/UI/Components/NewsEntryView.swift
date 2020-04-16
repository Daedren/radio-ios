import SwiftUI

struct NewsEntryView: View {
    var viewModel: NewsEntryViewModel
    @State private var textHeight: CGFloat = .zero
    
    var body: some View {
            VStack {
                HStack {
                    Text(self.viewModel.title)
                        .font(.body)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                    Spacer()
                    Text("~\(self.viewModel.author)")
                        .font(.subheadline)
                }
                Text(self.viewModel.createdAt.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
                TextWithAttributedString(height: self.$textHeight,
                                         attributedString: self.viewModel.body.value)
            }
    }
}

struct NewsEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = NewsEntryViewModel(id: 1,
                                           title: "Anison Hijack #13: April 24th Schedule",
                                           body: AppAttributedString(value: NSMutableAttributedString(string: "body")),
                                           createdAt: Date(),
                                           author: "McDoogle")
        return NewsEntryView(viewModel: viewModel)
    }
}
