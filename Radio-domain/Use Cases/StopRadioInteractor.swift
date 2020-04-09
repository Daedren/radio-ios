import Foundation
import Combine

public protocol StopRadioUseCase {
    func execute()
}

public class StopRadioInteractor: StopRadioUseCase {
    var avGateway: AVGateway
    
    public init(avGateway: AVGateway) {
        self.avGateway = avGateway
    }
    
    public func execute() {
        self.avGateway.stop()
    }
}
