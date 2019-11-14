
import Foundation
import Combine

public class StopRadioInteractor: Interactor {
    var avGateway: AVGateway
    
    public init(avGateway: AVGateway) {
        self.avGateway = avGateway
    }
    
    public func execute() {
        self.avGateway.pause()
    }
}
