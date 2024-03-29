import Foundation
import Combine
import Radio_domain
import Radio_interfaces
import Radio_cross
import UIKit

protocol RadioPresenter: ObservableObject {
    var state: RadioViewState { get }
    func start(actions: AnyPublisher<RadioViewAction, Never>)
}

class RadioPresenterPreviewer: RadioPresenter {
    @Published var state = RadioViewState()
    
    init() {
        state.songName = "songnamehere"
        state.isPlaying = false
        state.queue = [TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub()]
        state.lastPlayed = [TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub()]
        state.currentTrack = CurrentTrackViewModel.stubCurrent()
        state.dj = DJViewModel.stub()
        state.listeners = 420
        state.thread = ""
        state.acceptingRequests = true
    }
    
    func start(actions: AnyPublisher<RadioViewAction, Never>) {
        
    }
}

class RadioPresenterImp: RadioPresenter {
    var playInteractor: PlayRadioUseCase
    var pauseInteractor: StopRadioUseCase
    var isPlayingInteractor: IsPlayingUseCase
    var currentTrackInteractor: GetCurrentTrackUseCase
    var songQueueInteractor: GetSongQueueInteractor
    var lastPlayedInteractor: GetLastPlayedInteractor
    var djInteractor: GetDJInteractor
    var statusInteractor: GetCurrentStatusUseCase
    var getScales: GetFourierScalesUseCase
    
    var isPlaying = false
    lazy var allListeners: AnyPublisher<RadioViewState.Mutation, Never> = {
        Publishers.Merge7(
            self.startSongQueueListener(),
            self.startLastPlayedListener(),
            self.startDJListener(),
            self.startStatusListener(),
            self.startCurrentTrackListener(),
            self.startIsPlayingListener(),
            self.startScalesListener()
        )
        .eraseToAnyPublisher()
    }()
    var actions = PassthroughSubject<RadioViewState.Mutation, Never>()
    private var disposeBag = Set<AnyCancellable>()
    private var appDisposeBag = Set<AnyCancellable>()
    
    @Published var state: RadioViewState = RadioViewState()
    
    init(
        play: PlayRadioUseCase,
        pause: StopRadioUseCase,
        currentTrack: GetCurrentTrackUseCase,
        isPlaying: IsPlayingUseCase,
        queue: GetSongQueueInteractor,
        lastPlayed: GetLastPlayedInteractor,
        dj: GetDJInteractor,
        status: GetCurrentStatusUseCase,
        getScales: GetFourierScalesUseCase
    ) {
        self.playInteractor = play
        self.pauseInteractor = pause
        self.currentTrackInteractor = currentTrack
        self.songQueueInteractor = queue
        self.lastPlayedInteractor = lastPlayed
        self.djInteractor = dj
        self.statusInteractor = status
        self.isPlayingInteractor = isPlaying
        self.getScales = getScales

        
        //        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
        //            .sink(receiveValue: { [weak self] _ in
        //                self?.disposeBag = Set<AnyCancellable>()
        //            })
        //            .store(in: &appDisposeBag)
        //
        //        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
        //            .sink(receiveValue: { [weak self] _ in
        //                self?.startListeners()
        //            })
        //            .store(in: &appDisposeBag)
    }
    
    func start(actions: AnyPublisher<RadioViewAction, Never>) {
        if disposeBag.isEmpty {
            self.actions
                .merge(with: self.allListeners)
                .scan(self.state, RadioViewState.reduce(state:mutation:))
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { newState in
                    self.state = newState
                })
                .store(in: &disposeBag)
        }

        actions
            .flatMap(handleAction)
            .sink(receiveValue: { [weak self] newMutation in
                self?.actions.send(newMutation)
            })
            .store(in: &disposeBag)

    }
    
    private func handleAction(_ action: RadioViewAction) -> AnyPublisher<RadioViewState.Mutation, Never> {
        switch action {
        case .tappedPlayPause:
            return self.togglePlay()
        case .tappedTitle:
            return Just(RadioViewState.Mutation.toggleTags).eraseToAnyPublisher()
        }
    }
    
    func togglePlay() -> AnyPublisher<RadioViewState.Mutation, Never> {
        if isPlaying {
            self.pauseInteractor.execute()
        }
        else {
            self.playInteractor.execute()
        }
        return Empty<RadioViewState.Mutation, Never>()
            .eraseToAnyPublisher()
    }
    
    func startCurrentTrackListener() -> AnyPublisher<RadioViewState.Mutation, Never> {
        self.currentTrackInteractor
            .execute(with: self.disposeBag)
            .map { result -> RadioViewState.Mutation in
                let track = CurrentTrackViewModel(base: result)
                return .currentTrack(track)
            }
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .eraseToAnyPublisher()
    }
    
    private func startSongQueueListener() -> AnyPublisher<RadioViewState.Mutation, Never> {
        self.songQueueInteractor
            .execute()
            .map { tracks -> RadioViewState.Mutation in
                let models: [TrackViewModel] = tracks.map{ return TrackViewModel(base: $0) }
                return .queuedTracks(models)
            }
            .catch{ err in
                return Just(RadioViewState.Mutation.error(err.localizedDescription))
            }
            .receive(on: DispatchQueue.global(qos: .default))
            .eraseToAnyPublisher()
    }
    
    private func startLastPlayedListener() -> AnyPublisher<RadioViewState.Mutation, Never> {
        self.lastPlayedInteractor
            .execute()
            .map { tracks -> RadioViewState.Mutation in
                let models: [TrackViewModel] = tracks.map{ return TrackViewModel(base: $0) }
                return .lastPlayedTracks(models)
            }
            .catch{ err in
                return Just(RadioViewState.Mutation.error(err.localizedDescription))
            }
            .receive(on: DispatchQueue.global(qos: .default))
            .eraseToAnyPublisher()
    }
    
    private func startDJListener() -> AnyPublisher<RadioViewState.Mutation, Never> {
        self.djInteractor
            .execute()
            .map { domainDJ -> RadioViewState.Mutation in
                let djModel = DJViewModel(base: domainDJ)
                return .dj(djModel)
            }
            .catch{ err in
                return Just(RadioViewState.Mutation.error(err.localizedDescription))
            }
            .receive(on: DispatchQueue.global(qos: .default))
            .eraseToAnyPublisher()
    }
    
    private func startStatusListener() -> AnyPublisher<RadioViewState.Mutation, Never> {
        self.statusInteractor
            .execute()
            .map{ status -> RadioViewState.Mutation in
                return .status(thread: status.thread,
                               listeners: status.listeners,
                               acceptingRequests: status.acceptingRequests)
            }
            .catch{ err in
                return Just(RadioViewState.Mutation.error(err.localizedDescription))
            }
            .receive(on: DispatchQueue.global(qos: .default))
            .eraseToAnyPublisher()
    }
    
    private func startIsPlayingListener() -> AnyPublisher<RadioViewState.Mutation, Never> {
        self.isPlayingInteractor
            .execute()
            .handleEvents(receiveOutput: { [weak self] result in
                self?.isPlaying = result
            })
            .map{ result -> RadioViewState.Mutation in
                .isPlaying(result)
            }
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .eraseToAnyPublisher()
    }
    
    private func startScalesListener() -> AnyPublisher<RadioViewState.Mutation, Never> {
        self.getScales
            .execute()
            .map{ result -> RadioViewState.Mutation in
                .scales(BarChartViewModel(id: result.hashValue,
                                          values: result))
            }
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .eraseToAnyPublisher()
    }
}
