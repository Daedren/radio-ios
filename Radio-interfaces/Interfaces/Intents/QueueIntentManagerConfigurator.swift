import Foundation
import Radio_cross
import Radio_domain
import SwiftUI


class QueueIntentManagerConfigurator: Configurator {

    func configure() -> QueueIntentManager {
        let manager = QueueIntentManager(
            queueUseCase: InjectSettings.shared
                .resolve(GetSongQueueInteractor.self)!
        )
        return manager
    }
}
