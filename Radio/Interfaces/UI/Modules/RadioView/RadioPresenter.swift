import Foundation
import Combine
import Radio_Domain

protocol RadioPresenter: ObservableObject {
    var songName: String { get }
    var playText: String { get }
    var queue: [TrackViewModel] { get }
    var lastPlayed: [TrackViewModel] { get }
    var currentTrack: CurrentTrackViewModel? { get }
    var dj: DJViewModel? { get }
    var listeners: Int? { get }
    var thread: String { get }
    var acceptingRequests: Bool { get }
    
    func tappedButton()
}

class RadioPresenterPreviewer: RadioPresenter {
    @Published var songName: String = "songnamehere"
    @Published var playText: String = "play.fill"
    @Published var queue: [TrackViewModel] = [TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub()]
    @Published var lastPlayed: [TrackViewModel] = [TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub()]
    @Published var currentTrack: CurrentTrackViewModel? = CurrentTrackViewModel.stubCurrent()
    @Published var dj: DJViewModel? = DJViewModel.stub()
    @Published var listeners: Int? = 420
    @Published var thread: String = ""
    @Published var acceptingRequests: Bool = true
    
    func tappedButton() {
        print("Tapped")
    }
}

class RadioPresenterImp: RadioPresenter {
    var playInteractor: PlayRadioUseCase
    var pauseInteractor: StopRadioUseCase
    var isPlayingInteractor: IsPlayingUseCase
    var songNameInteractor: GetCurrentTrackUseCase
    var songQueueInteractor: GetSongQueueInteractor
    var lastPlayedInteractor: GetLastPlayedInteractor
    var djInteractor: GetDJInteractor
    var statusInteractor: GetCurrentStatusInteractor
    
    var isPlaying = false
    private var disposeBag = Set<AnyCancellable>()
    
    @Published var songName: String = ""
    @Published var playText: String = "play.fill"
    @Published var queue: [TrackViewModel] = []
    @Published var lastPlayed: [TrackViewModel] = []
    @Published var currentTrack: CurrentTrackViewModel?
    @Published var dj: DJViewModel?
    @Published var listeners: Int?
    @Published var thread: String = ""
    @Published var acceptingRequests: Bool = true
    
    init(
        play: PlayRadioUseCase,
         pause: StopRadioUseCase,
         songName: GetCurrentTrackUseCase,
         isPlaying: IsPlayingUseCase,
         queue: GetSongQueueInteractor,
         lastPlayed: GetLastPlayedInteractor,
         dj: GetDJInteractor,
         status: GetCurrentStatusInteractor
    ) {
        self.playInteractor = play
        self.pauseInteractor = pause
        self.songNameInteractor = songName
        self.songQueueInteractor = queue
        self.lastPlayedInteractor = lastPlayed
        self.djInteractor = dj
        self.statusInteractor = status
        self.isPlayingInteractor = isPlaying
        
        self.startSongQueueListener()
        self.startLastPlayedListener()
        self.startDJListener()
        self.startStatusListener()
        self.getSongName()
        self.startIsPlayingListener()
    }
    
    func togglePlay() {
        if isPlaying {
            self.pauseInteractor.execute()
        }
        else {
            self.playInteractor.execute()
        }
    }
    
    func tappedButton() {
        togglePlay()
    }
    
    func getSongName() {
        self.songNameInteractor
            .execute()
//            .removeDuplicates(by: { lhs, rhs in return lhs.title == rhs.title })
            .receive(on: DispatchQueue.main)
            .sink(receiveValue:{ [weak self] value in
                self?.songName = "\(value.artist) - \(value.title)"
                self?.currentTrack = CurrentTrackViewModel(base: value)
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
    
    private func startStatusListener() {
        self.statusInteractor
            .execute()
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] value in
            self?.listeners = value.listeners
            if value.thread != self?.thread {
                self?.thread = value.thread
            }
            self?.acceptingRequests = value.acceptingRequests
        })
            .store(in: &disposeBag)
        
    }
    
    private func startIsPlayingListener() {
        self.isPlayingInteractor
            .execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                
            }, receiveValue: { [weak self] value in
                self?.isPlaying = value
                
                if value {
                    self?.playText = "stop.fill"
                }
                else {
                    self?.playText = "play.fill"
                }
            })
            .store(in: &disposeBag)
        
    }
}
