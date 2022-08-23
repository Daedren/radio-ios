import Foundation
import MediaPlayer
import Combine
import Radio_cross

public class RemoteControlClient: RemoteControl, Logging {

    var defaultRegisteredCommands: [RemoteControlCommand]
    var defaultDisabledCommands: [RemoteControlCommand]
    
    var remoteControlCommands = PassthroughSubject<RemoteControlCommand,Never>()

    public init(registeredCommands: [RemoteControlCommand],
         disabledCommands: [RemoteControlCommand]) {
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
    
    func setPlayback(metadata: RemoteControlDynamicMetadata) {
        self.setNowPlayingPlaybackInfo(metadata)
    }
    
    func getRemoteController() -> AnyPublisher<RemoteControlCommand, Never> {
        return self.remoteControlCommands.eraseToAnyPublisher()
    }
    
    private func commandHandler(command: RemoteControlCommand, event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        self.log(message: "Received command \(command)", logLevel: .info)
        self.remoteControlCommands.send(command)
        return .success
    }
}
