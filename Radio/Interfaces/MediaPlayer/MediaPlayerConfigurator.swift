import Foundation
import Swinject
import Radio_Domain
import Radio_cross

class MediaPlayerConfigurator: Configurator {
    let iOSCommands: [RemoteControlCommand] = [.togglePausePlay,
                                               .play,
                                               .pause
    ]
    
    func configure() -> MediaPlayerInterface {
        let player = MediaPlayerInterface(remoteControl: self.inject().resolve(RemoteControlClient.self)!,
                                          play: self.assembler.resolver.resolve(PlayRadioUseCase.self)!,
                                          pause: self.assembler.resolver.resolve(StopRadioUseCase.self)!,
                                          songName: self.assembler.resolver.resolve(GetCurrentTrackUseCase.self)!,
                                          dj: self.assembler.resolver.resolve(GetDJInteractor.self)!,
                                          status: self.assembler.resolver.resolve(GetCurrentStatusInteractor.self)!,
                                          playback: self.assembler.resolver.resolve(GetPlaybackInfoInteractor.self)!)
        return player
    }
    
    private func inject() -> Container {
        return Container { container in
            container.register(RemoteControlClient.self) { _ in
                return RemoteControlClient(registeredCommands: self.iOSCommands,
                                           disabledCommands: [],
                                           logger: self.assembler.resolver.resolve(LoggerWrapper.self)!)
            }
        }
        
    }
}
