import Foundation
import MediaPlayer
import Combine

class RemoteControlClient: RemoteControl {

    var defaultRegisteredCommands: [RemoteControlCommand]
    var defaultDisabledCommands: [RemoteControlCommand]
    
    var remoteControlCommands = PassthroughSubject<RemoteControlCommand,Never>()

    init(registeredCommands: [RemoteControlCommand], disabledCommands: [RemoteControlCommand]) {
        self.defaultRegisteredCommands = registeredCommands
        self.defaultDisabledCommands = disabledCommands
    }
    
    func handleNowPlayableConfiguration() {
        
       try? self.configureRemoteCommands(defaultRegisteredCommands,
                                     disabledCommands: defaultDisabledCommands,
                                     commandHandler: commandHandler(command:event:))
    }
    
    func setStatic(metadata: RemoteControlStaticMetadata) {
        self.setNowPlayingMetadata(metadata)
    }
    
    func setPlayback(metadata: NowPlayableDynamicMetadata) {
        self.setNowPlayingPlaybackInfo(metadata)
    }
    
    func getRemoteController() -> AnyPublisher<RemoteControlCommand, Never> {
        return self.remoteControlCommands.eraseToAnyPublisher()
    }
    
    private func commandHandler(command: RemoteControlCommand, event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        print("Received command \(command)")
        self.remoteControlCommands.send(command)
        return .success
    }
}
