import SwiftUI

struct NewsEntryView: View {
    var viewModel: NewsEntryViewModel
    // Dynamic attributed string size
    @State private var textSize: CGSize = .zero
    
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
                TextWithAttributedString(size: self.$textSize,
                                         attributedString: self.viewModel.body.value)
                    .frame(width: nil, height: textSize.height)
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
