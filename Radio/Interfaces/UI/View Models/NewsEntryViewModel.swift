import Foundation

struct NewsEntryViewModel: Identifiable {
    var id: Int

    var title: String
    var body: AppAttributedString
//    var header: String
    var createdAt: Date
    var author: String
    
}
