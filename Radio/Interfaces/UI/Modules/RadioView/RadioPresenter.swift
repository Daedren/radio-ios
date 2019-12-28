import Foundation
import Combine
import Radio_Domain

protocol RadioPresenter: ObservableObject {
    var songName: String { get }
    var playText: String { get }
    var queue: [TrackViewModel] { get }
    var lastPlayed: [TrackViewModel] { get }
    var dj: DJViewModel? { get }
    
    func tappedButton()
}

class RadioPresenterPreviewer: RadioPresenter {
    @Published var songName: String = "songnamehere"
    @Published var playText: String = "Play"
    @Published var queue: [TrackViewModel] = [TrackViewModel.stub()]
    @Published var lastPlayed: [TrackViewModel] = [TrackViewModel.stub()]
    @Published var dj: DJViewModel? = DJViewModel.stub()
    
    func tappedButton() {
        print("Tapped")
    }
}

class RadioPresenterImp: RadioPresenter {
    var playInteractor: PlayRadioUseCase
    var pauseInteractor: StopRadioUseCase
    var songNameInteractor: GetSongNameUseCase
    var songQueueInteractor: GetSongQueueInteractor
    var lastPlayedInteractor: GetLastPlayedInteractor
    var djInteractor: GetDJInteractor
    
    var isPlaying = false
    private var disposeBag = Set<AnyCancellable>()
    
    @Published var songName: String = ""
    @Published var playText: String = "Play"
    @Published var queue: [TrackViewModel] = []
    @Published var lastPlayed: [TrackViewModel] = []
    @Published var dj: DJViewModel?
    
    init(play: PlayRadioUseCase,
         pause: StopRadioUseCase,
         songName: GetSongNameUseCase,
         queue: GetSongQueueInteractor,
         lastPlayed: GetLastPlayedInteractor,
         dj: GetDJInteractor
    ) {
        self.playInteractor = play
        self.pauseInteractor = pause
        self.songNameInteractor = songName
        self.songQueueInteractor = queue
        self.lastPlayedInteractor = lastPlayed
        self.djInteractor = dj
        
        self.startSongQueueListener()
        self.startLastPlayedListener()
        self.startDJListener()
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
    
    private func startSongQueueListener() {
        self.songQueueInteractor
            .execute()
            .map { tracks -> [TrackViewModel] in
                let models: [TrackViewModel] = tracks.map{ return TrackViewModel(base: $0) }
                return models
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] value in
            self?.queue = value
        })
            .store(in: &disposeBag)
        
    }
    
    private func startLastPlayedListener() {
        self.lastPlayedInteractor
            .execute()
            .map { tracks -> [TrackViewModel] in
                let models: [TrackViewModel] = tracks.map{ return TrackViewModel(base: $0) }
                return models
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] value in
            self?.lastPlayed = value
        })
            .store(in: &disposeBag)
        
    }
    
    private func startDJListener() {
        self.djInteractor
            .execute()
            .map { domainDJ -> DJViewModel in
                return DJViewModel(base: domainDJ)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] value in
            self?.dj = value
        })
            .store(in: &disposeBag)
        
    }
}
