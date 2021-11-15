import Foundation
import Combine

public protocol StopRadioUseCase {
    func execute()
}

public class StopRadioInteractor: StopRadioUseCase {
    var avGateway: MusicGateway
    
    public init(avGateway: MusicGateway) {
        self.avGateway = avGateway
    }
    
    public func execute() {
        self.avGateway.stop()
    }
}
