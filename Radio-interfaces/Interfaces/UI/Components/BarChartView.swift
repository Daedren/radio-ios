import SwiftUI

public struct BarChartViewModel: Identifiable, Equatable {
    public var id: Int
    var values: [Float]
    
    public init(id: Int, values: [Float]) {
        self.id = id
        self.values = values
    }
    
    static func stub() -> BarChartViewModel {
        return BarChartViewModel(id: 0, values: [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.2])
    }
}


struct BarChartView: View {
    var viewModel: BarChartViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0.0) {
                ForEach(Array(viewModel.values.enumerated()), id: \.offset) { index, value in
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.red, .orange, .red]), startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: geometry.size.width / CGFloat(viewModel.values.count),
                               height: geometry.size.height * CGFloat(value))
                }
            }
        }
        .background(Color.blue)
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = BarChartViewModel.stub()
        return BarChartView(viewModel: viewModel)
    }
}
