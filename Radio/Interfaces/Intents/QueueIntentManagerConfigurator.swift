import Foundation
import Swinject
import Radio_domain
import SwiftUI


class QueueIntentManagerConfigurator: Configurator {

    func configure() -> QueueIntentManager {
        let manager = QueueIntentManager(
            queueUseCase: self.assembler.resolver
                .resolve(GetSongQueueInteractor.self)!
        )
        return manager
    }
}
