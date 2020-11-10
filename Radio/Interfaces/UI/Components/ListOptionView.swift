import SwiftUI

struct ListOptionView: View {
    var viewModel: ListOptionViewModel
    @State private var textHeight: CGFloat = .zero
    
    var body: some View {
            VStack {
                HStack {
                    Image(systemName: self.viewModel.icon ?? "")
                    Text(self.viewModel.title)
                        .font(.body)
//                        .fontWeight(.bold)
                        .lineLimit(nil)
                    Spacer()
                }
            }
    }
}

struct ListOptionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ListOptionViewModel(id: 1,
                                           title: "Anison Hijack #13: April 24th Schedule",
                                           icon: nil)
        return ListOptionView(viewModel: viewModel)
    }
}
