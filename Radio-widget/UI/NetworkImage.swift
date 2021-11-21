import Foundation
import SwiftUI

struct NetworkImage: View {

  private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }

  var body: some View {

    Group {
     if let url = url, let imageData = try? Data(contentsOf: url),
       let uiImage = UIImage(data: imageData) {

       Image(uiImage: uiImage)
         .resizable()
        .aspectRatio(contentMode: .fit)
      }
      else {
       Image("placeholder-image")
      }
    }
  }

}
