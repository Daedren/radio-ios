
import Foundation
import Combine

public class PlayRadioInteractor: Interactor {
    var avGateway: AVGateway
    var radioUrl: URL = URL(string: "https://r-a-d.io/assets/main.mp3.m3u")!
//    var radioUrl: URL = URL(string: "https://r-a-d.io/main.mp3")!
    
    public init(avGateway: AVGateway) {
        self.avGateway = avGateway
    }
    
    public func execute() {
        _ = self.avGateway.enqueue(url: radioUrl)
        self.avGateway.play()
    }
}
