import Foundation
import Radio_Domain
import SwiftUI

struct DJViewModel: Identifiable {
    var id: String {
        return name
    }
    
    public var name: String
    public var image: URL?
    
    public init(base: RadioDJ) {
        self.name = base.name
        self.image = base.image
    }
    
    public static func stub() -> DJViewModel {
        let track = RadioDJ(id: 0,
                            name: "TestDJ",
                            text: "",
                            image: URL(fileURLWithPath: "https://r-a-d.io/api/dj-image/43-424d62e9.png"),
                            color: Color(red: 255, green: 0, blue: 0),
                            visible: true,
                            priority: 0)
        return DJViewModel(base: track)
    }
}
