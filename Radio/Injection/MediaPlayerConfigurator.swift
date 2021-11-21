import Foundation
import Radio_cross
import Radio_domain
import Radio_cross
import Radio_interfaces

class MediaPlayerConfigurator: Configurator {
    let iOSCommands: [RemoteControlCommand] = [.togglePausePlay,
                                               .play,
                                               .pause
    ]
    
    func configure() -> MediaPlayerInterface {
        self.inject()
        return MediaPlayerInterface()
    }
    
    private func inject(){
        InjectSettings.shared.register(RemoteControlClient.self) {
            return RemoteControlClient(registeredCommands: self.iOSCommands,
                                       disabledCommands: [],
                                       logger: InjectSettings.shared.resolve(LoggerWrapper.self)!)
        }
    }
    
}
