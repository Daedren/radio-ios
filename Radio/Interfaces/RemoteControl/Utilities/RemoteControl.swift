import Foundation
import MediaPlayer

protocol RemoteControl: AnyObject {
    
    var defaultRegisteredCommands: [RemoteControlCommand] { get }
    var defaultDisabledCommands: [RemoteControlCommand] { get }

}


extension RemoteControl {
    
    // Install handlers for registered commands, and disable commands as necessary.
    
    func configureRemoteCommands(_ commands: [RemoteControlCommand],
                                 disabledCommands: [RemoteControlCommand],
                                 commandHandler: @escaping (RemoteControlCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) throws {
        
        // Check that at least one command is being handled.
        
        guard commands.count > 1 else { throw RemoteControlError.noRegisteredCommands }
        
        // Configure each command.
        
        for command in RemoteControlCommand.allCases {
            
            // Remove any existing handler.
            
            command.removeHandler()
            
            // Add a handler if necessary.
            
            if commands.contains(command) {
                command.addHandler(commandHandler)
            }
            
            // Disable the command if necessary.
            
            command.setDisabled(disabledCommands.contains(command))
        }
    }
    
    // Set per-track metadata. Implementations of `handleNowPlayableItemChange(metadata:)`
    
    // will typically invoke this method.
    
    func setNowPlayingMetadata(_ metadata: RemoteControlStaticMetadata) {
       
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        
        NSLog("%@", "**** Set track metadata: title \(metadata.title)")
        nowPlayingInfo[MPNowPlayingInfoPropertyAssetURL] = metadata.assetURL
        nowPlayingInfo[MPNowPlayingInfoPropertyMediaType] = metadata.mediaType.rawValue
        nowPlayingInfo[MPNowPlayingInfoPropertyIsLiveStream] = metadata.isLiveStream
        nowPlayingInfo[MPMediaItemPropertyTitle] = metadata.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = metadata.artist
        nowPlayingInfo[MPMediaItemPropertyArtwork] = metadata.artwork
        nowPlayingInfo[MPMediaItemPropertyAlbumArtist] = metadata.albumArtist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = metadata.albumTitle
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    // Set playback info. Implementations of `handleNowPlayablePlaybackChange(playing:rate:position:duration:)`
    // will typically invoke this method.
    
    func setNowPlayingPlaybackInfo(_ metadata: RemoteControlDynamicMetadata) {
        
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        
        NSLog("%@", "**** Set playback info: rate \(metadata.rate), position \(metadata.position), duration \(metadata.duration)")
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = metadata.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = metadata.position
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = metadata.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyCurrentLanguageOptions] = metadata.currentLanguageOptions
        nowPlayingInfo[MPNowPlayingInfoPropertyAvailableLanguageOptions] = metadata.availableLanguageOptionGroups
        
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
}
