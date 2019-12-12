import Foundation
import Combine
import Radio_Domain

class RadioPresenter: ObservableObject {
    var playInteractor: PlayRadioUseCase
    var pauseInteractor: StopRadioUseCase
    var songNameInteractor: GetSongNameUseCase
    
    var isPlaying = false
    private var disposeBag = Set<AnyCancellable>()
    
    @Published var songName: String = ""
    @Published var playText: String = "Play"
    
    init(play: PlayRadioUseCase, pause: StopRadioUseCase, songName: GetSongNameUseCase) {
        self.playInteractor = play
        self.pauseInteractor = pause
        self.songNameInteractor = songName
    }
    
    func togglePlay() {
        if isPlaying {
            print("Pausing")
            self.playText = "Stop"
            self.pauseInteractor.execute()
        }
        else {
            print("Playing")
            self.playText = "Play"
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
