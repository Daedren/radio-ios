import Foundation
import MediaPlayer
import Combine
import Radio_cross

class RemoteControlClient: RemoteControl, LoggerWithContext {
    var loggerInstance: LoggerWrapper

    var defaultRegisteredCommands: [RemoteControlCommand]
    var defaultDisabledCommands: [RemoteControlCommand]
    
    var remoteControlCommands = PassthroughSubject<RemoteControlCommand,Never>()

    init(registeredCommands: [RemoteControlCommand],
         disabledCommands: [RemoteControlCommand],
         logger: LoggerWrapper) {
        self.defaultRegisteredCommands = registeredCommands
        self.defaultDisabledCommands = disabledCommands
        self.loggerInstance = logger
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
        self.loggerInfo(message: "Received command \(command)")
        self.remoteControlCommands.send(command)
        return .success
    }
}
