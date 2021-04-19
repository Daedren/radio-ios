
import Foundation
import Combine

public protocol PlayRadioUseCase {
    func execute()
}

public class PlayRadioInteractor: PlayRadioUseCase {
    var avGateway: AVGateway
    var radioUrl: URL = URL(string: "https://stream.r-a-d.io/main.mp3")!
//    var radioUrl: URL = URL(string: "https://r-a-d.io/main.mp3")!
    
    public init(avGateway: AVGateway) {
        self.avGateway = avGateway
    }
    
    public func execute() {
        _ = self.avGateway.enqueue(url: radioUrl)
        self.avGateway.play()
    }
}
