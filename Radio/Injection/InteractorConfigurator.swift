import Foundation
import Swinject
import Radio_Domain

class InteractorConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(PlayRadioInteractor.self) { _ in
            return PlayRadioInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
        container.register(StopRadioInteractor.self) { _ in
            return StopRadioInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
        container.register(GetSongNameInteractor.self) { _ in
            return GetSongNameInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
    }
}
