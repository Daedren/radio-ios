import Foundation
import Combine
import Radio_domain
import MediaPlayer

class MediaPlayerInterface {
    var remoteControl: RemoteControlClient
    var nowPlayingDisposeBag = Set<AnyCancellable>()
    var classDisposeBag = Set<AnyCancellable>()
    var remote: AnyPublisher<RemoteControlCommand, Never>?
    
    var playInteractor: PlayRadioUseCase
    var pauseInteractor: StopRadioUseCase
    var songNameInteractor: GetCurrentTrackUseCase
    var statusInteractor: GetCurrentStatusInteractor
    var djInteractor: GetDJInteractor
    var playbackInteractor: GetPlaybackInfoInteractor
    
    var currentDJ: URL?
    var artworkHandler = ArtworkHandler()
    
    var isPlaying = false

    init(remoteControl: RemoteControlClient,
         play: PlayRadioUseCase,
         pause: StopRadioUseCase,
         songName: GetCurrentTrackUseCase,
         dj: GetDJInteractor,
         status: GetCurrentStatusInteractor,
         playback: GetPlaybackInfoInteractor
    ) {
        self.remoteControl = remoteControl
        self.playInteractor = play
        self.pauseInteractor = pause
        self.songNameInteractor = songName
        self.djInteractor = dj
        self.statusInteractor = status
        self.playbackInteractor = playback
        
        self.prepareToReceiveCommands()
        self.setReactiveHandlers()
    }
    
    
    private func prepareToReceiveCommands() {
        remoteControl.handleNowPlayableConfiguration()
        
        remoteControl
            .getRemoteController()
            .sink(receiveValue: { [weak self] command in
                switch command {
                case .play:
                    self?.playInteractor.execute()
                case .pause:
                    self?.pauseInteractor.execute()
                case .togglePausePlay:
                    if self?.isPlaying ?? false {
                        self?.playInteractor.execute()
                    } else {
                        self?.pauseInteractor.execute()
                    }
                default:
                    break
                }
            }).store(in: &classDisposeBag)
        
    }
    
    private func setReactiveHandlers() {
        self.nowPlayingDisposeBag = Set<AnyCancellable>()
        
        self.playbackInteractor.execute()
            .sink(receiveValue: { [weak self] metadata in
                if let playback = self?.createDynamicMetadata(from: metadata) {
                    self?.isPlaying = (metadata.rate > 0.0)
                    self?.remoteControl.setPlayback(metadata: playback)
                }
            }).store(in: &nowPlayingDisposeBag)
        
        self.djInteractor.execute()
            .sink(receiveCompletion: { _ in
                
            },receiveValue: { [weak self] newDJ in
                self?.currentDJ = newDJ.image
                self?.artworkHandler.prepareArtworkFromDJ(url: newDJ.image)
            }).store(in: &nowPlayingDisposeBag)
        
        self.songNameInteractor.execute(with: nowPlayingDisposeBag)
            .removeDuplicates(by: { lhs, rhs in return lhs.title == rhs.title })
            .sink(receiveValue: { [weak self] newName in
                if let metadata = self?.createStaticMetadata(title: newName.title, artist: newName.artist, image: self?.currentDJ) {
                    self?.remoteControl.setStatic(metadata: metadata)
                }
            }).store(in: &nowPlayingDisposeBag)
    }
    
    private func createStaticMetadata(title: String, artist: String, image: URL?) -> RemoteControlStaticMetadata {
        let fallbackImage = URL(string: "https://r-a-d.io/assets/logo_image_small.png")!
        let djImage = image ?? fallbackImage
        
        let metadata = RemoteControlStaticMetadata(
            assetURL: djImage,
            mediaType: .audio,
            isLiveStream: true,
            title: title,
            artist: artist,
            artwork: self.artworkHandler.artwork,
            albumArtist: nil,
            albumTitle: nil)
        return metadata
    }
    
    private func createDynamicMetadata(from avMetadata: PlaybackInfo) -> RemoteControlDynamicMetadata {
        let metadata = RemoteControlDynamicMetadata(rate: avMetadata.rate,
                                                    position: avMetadata.position,
                                                    currentLanguageOptions: [],
                                                    availableLanguageOptionGroups: [])
        return metadata
    }

}
