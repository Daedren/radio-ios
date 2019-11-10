import Foundation
import Combine
import Radio_Domain

class RadioPresenter: ObservableObject {
    var playInteractor: PlayRadioInteractor
    var pauseInteractor: StopRadioInteractor
    var songNameInteractor: GetSongNameInteractor
    
    var isPlaying = false
    private var disposeBag = Set<AnyCancellable>()
    
    @Published var songName: String = ""
    
    init(play: PlayRadioInteractor, pause: StopRadioInteractor, songName: GetSongNameInteractor) {
        self.playInteractor = play
        self.pauseInteractor = pause
        self.songNameInteractor = songName
    }
    
    func togglePlay() {
        if isPlaying {
            print("Pausing")
            self.pauseInteractor.execute()
        }
        else {
            print("Playing")
            self.playInteractor.execute()
        }
        self.isPlaying = !isPlaying
    }
    
    func tappedButton() {
        getSongName()
        togglePlay()
    }
    
    func getSongName() {
        self.songNameInteractor
            .execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:{ [weak self] value in
                self?.songName = value
            })
            .store(in: &disposeBag)
    }
    
    
}
