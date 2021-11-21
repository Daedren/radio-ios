import Foundation
import Radio_domain
import Intents
import Combine

class QueueIntentManager {
    
    var queueUseCase: GetSongQueueInteractor
    var queueDisposeBag = Set<AnyCancellable>()
    
    init(queueUseCase: GetSongQueueInteractor) {
        self.queueUseCase = queueUseCase
//        bindPublishers()
    }
    
    func bindPublishers() {
        self.queueUseCase
            .execute()
            .sink(receiveCompletion: { _ in
                
            },
                  receiveValue: { [weak self] tracks in
                self?.processQueue(newTracks: tracks)
            })
            .store(in: &queueDisposeBag)
    }
    
    func processQueue(newTracks: [QueuedTrack]) {
        let manager = INUpcomingMediaManager.shared
        
        let mediaTracks = newTracks.map{ INMediaItem(identifier: $0.title, title: $0.title, type: .music, artwork: nil)}
        
        let intent = INPlayMediaIntent(mediaItems: mediaTracks,
                          mediaContainer: nil,
                          playShuffled: nil,
                          playbackRepeatMode: .none,
                          resumePlayback: false,
                          playbackQueueLocation: .later,
                          playbackSpeed: nil,
                          mediaSearch: nil)
        
        let tracksAsSet = NSOrderedSet(array: [intent])
        
        manager.setSuggestedMediaIntents(tracksAsSet)
    }
}
