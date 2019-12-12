import Foundation
import Swinject
import Radio_Domain

class InteractorConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(PlayRadioUseCase.self) { _ in
            return PlayRadioInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
        container.register(StopRadioUseCase.self) { _ in
            return StopRadioInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
        container.register(GetSongNameUseCase.self) { _ in
            return GetSongNameInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
    }
}
