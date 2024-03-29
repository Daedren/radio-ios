import Foundation
import MediaPlayer


protocol RemoteControlProtocol: AnyObject {
    var defaultRegisteredCommands: [RemoteControlCommand] { get }
    var defaultDisabledCommands: [RemoteControlCommand] { get }
}

struct RemoteControlStaticMetadata {
    
    let assetURL: URL                   // MPNowPlayingInfoPropertyAssetURL
    let mediaType: MPNowPlayingInfoMediaType
                                        // MPNowPlayingInfoPropertyMediaType
    let isLiveStream: Bool              // MPNowPlayingInfoPropertyIsLiveStream
    
    let title: String                   // MPMediaItemPropertyTitle
    let artist: String?                 // MPMediaItemPropertyArtist
    let artwork: MPMediaItemArtwork?    // MPMediaItemPropertyArtwork
    
    let albumArtist: String?            // MPMediaItemPropertyAlbumArtist
    let albumTitle: String?             // MPMediaItemPropertyAlbumTitle
    
}

struct RemoteControlDynamicMetadata {
    
    let rate: Float                     // MPNowPlayingInfoPropertyPlaybackRate
    let position: Float                 // MPNowPlayingInfoPropertyElapsedPlaybackTime
    let duration: Float? = nil                 // MPMediaItemPropertyPlaybackDuration
    
    let currentLanguageOptions: [MPNowPlayingInfoLanguageOption]
                                        // MPNowPlayingInfoPropertyCurrentLanguageOptions
    let availableLanguageOptionGroups: [MPNowPlayingInfoLanguageOptionGroup]
                                        // MPNowPlayingInfoPropertyAvailableLanguageOptions
    
}

public enum RemoteControlCommand: CaseIterable {

    case pause, play, stop, togglePausePlay
    case nextTrack, previousTrack, changeRepeatMode, changeShuffleMode
    case changePlaybackRate, seekBackward, seekForward, skipBackward, skipForward, changePlaybackPosition
    case rating, like, dislike
    case bookmark
    case enableLanguageOption, disableLanguageOption

    var remoteCommand: MPRemoteCommand {

        let remoteCommandCenter = MPRemoteCommandCenter.shared()

        switch self {

        case .pause:
            return remoteCommandCenter.pauseCommand
        case .play:
            return remoteCommandCenter.playCommand
        case .stop:
            return remoteCommandCenter.stopCommand
        case .togglePausePlay:
            return remoteCommandCenter.togglePlayPauseCommand
        case .nextTrack:
            return remoteCommandCenter.nextTrackCommand
        case .previousTrack:
            return remoteCommandCenter.previousTrackCommand
        case .changeRepeatMode:
            return remoteCommandCenter.changeRepeatModeCommand
        case .changeShuffleMode:
            return remoteCommandCenter.changeShuffleModeCommand
        case .changePlaybackRate:
            return remoteCommandCenter.changePlaybackRateCommand
        case .seekBackward:
            return remoteCommandCenter.seekBackwardCommand
        case .seekForward:
            return remoteCommandCenter.seekForwardCommand
        case .skipBackward:
            return remoteCommandCenter.skipBackwardCommand
        case .skipForward:
            return remoteCommandCenter.skipForwardCommand
        case .changePlaybackPosition:
            return remoteCommandCenter.changePlaybackPositionCommand
        case .rating:
            return remoteCommandCenter.ratingCommand
        case .like:
            return remoteCommandCenter.likeCommand
        case .dislike:
            return remoteCommandCenter.dislikeCommand
        case .bookmark:
            return remoteCommandCenter.bookmarkCommand
        case .enableLanguageOption:
            return remoteCommandCenter.enableLanguageOptionCommand
        case .disableLanguageOption:
            return remoteCommandCenter.disableLanguageOptionCommand
        }
    }

    // Remove all handlers associated with this command.

    func removeHandler() {
        remoteCommand.removeTarget(nil)
    }

    // Install a handler for this command.

    func addHandler(_ handler: @escaping (RemoteControlCommand, MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus) {

        // Configure certain commands
        switch self {
        case .changePlaybackRate:
            MPRemoteCommandCenter.shared().changePlaybackRateCommand.supportedPlaybackRates = [1.0, 2.0]

        case .skipBackward:
            MPRemoteCommandCenter.shared().skipBackwardCommand.preferredIntervals = [15.0]

        case .skipForward:
            MPRemoteCommandCenter.shared().skipForwardCommand.preferredIntervals = [15.0]

        default:
            break
        }

        remoteCommand.addTarget { handler(self, $0) }
    }

    // Disable this command.

    func setDisabled(_ isDisabled: Bool) {
        remoteCommand.isEnabled = !isDisabled
    }

}
