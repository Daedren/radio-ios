import Foundation
import Combine
import Radio_domain
import Radio_app
import UIKit


protocol RadioWatchPresenter: ObservableObject {
    var state: RadioWatchViewState { get }
    func start(actions: AnyPublisher<RadioWatchViewAction, Never>)
}

class RadioWatchPresenterPreviewer: RadioWatchPresenter {
    @Published var state = RadioWatchViewState()
    
    init() {
        state.isPlaying = false
        state.currentTrack = CurrentTrackViewModel.stubCurrent()
        state.dj = DJViewModel.stub()
        state.listeners = 420
    }
    
    func start(actions: AnyPublisher<RadioWatchViewAction, Never>) {
        
    }
}

class RadioWatchPresenterImp: RadioWatchPresenter {
    var playInteractor: PlayRadioUseCase
    var pauseInteractor: StopRadioUseCase
    var isPlayingInteractor: IsPlayingUseCase
    var currentTrackInteractor: GetCurrentTrackUseCase
    var djInteractor: GetDJInteractor
    var statusInteractor: GetCurrentStatusInteractor
    
    var isPlaying = false
    private var disposeBag = Set<AnyCancellable>()
    private var appDisposeBag = Set<AnyCancellable>()
    
    @Published var state: RadioWatchViewState = RadioWatchViewState()
    
    init(
        play: PlayRadioUseCase,
        pause: StopRadioUseCase,
        currentTrack: GetCurrentTrackUseCase,
        isPlaying: IsPlayingUseCase,
        dj: GetDJInteractor,
        status: GetCurrentStatusInteractor
    ) {
        self.playInteractor = play
        self.pauseInteractor = pause
        self.currentTrackInteractor = currentTrack
        self.djInteractor = dj
        self.statusInteractor = status
        self.isPlayingInteractor = isPlaying
        
    }
    
    func start(actions: AnyPublisher<RadioWatchViewAction, Never>) {
        let listeners = self.startListeners()
        
        let actions = actions
            .flatMap(handleAction)
            
        actions.merge(with: listeners)
            .scan(RadioWatchViewState.initial, RadioWatchViewState.reduce(state:mutation:))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { newState in
                self.state = newState
            })
            .store(in: &disposeBag)
    }
    
    private func handleAction(_ action: RadioWatchViewAction) -> AnyPublisher<RadioWatchViewState.Mutation, Never> {
        switch action {
        case .tappedPlayPause:
            return self.togglePlay()
        }
    }
    
    func startListeners() -> AnyPublisher<RadioWatchViewState.Mutation, Never> {
        Publishers.Merge4(
        self.startDJListener(),
        self.startStatusListener(),
        self.startCurrentTrackListener(),
        self.startIsPlayingListener()
        )
        .eraseToAnyPublisher()
    }
    
    func togglePlay() -> AnyPublisher<RadioWatchViewState.Mutation, Never> {
        if isPlaying {
            self.pauseInteractor.execute()
        }
        else {
            self.playInteractor.execute()
        }
        return Empty<RadioWatchViewState.Mutation, Never>()
        .eraseToAnyPublisher()
    }
    
    func startCurrentTrackListener() -> AnyPublisher<RadioWatchViewState.Mutation, Never> {
        self.currentTrackInteractor
            .execute(with: self.disposeBag)
            .map { result -> RadioWatchViewState.Mutation in
                let track = CurrentTrackViewModel(base: result)
                return .currentTrack(track)
        }
        .receive(on: DispatchQueue.global(qos: .userInteractive))
        .eraseToAnyPublisher()
    }
    
    private func startDJListener() -> AnyPublisher<RadioWatchViewState.Mutation, Never> {
        self.djInteractor
            .execute()
            .map { domainDJ -> RadioWatchViewState.Mutation in
                let djModel = DJViewModel(base: domainDJ)
                return .dj(djModel)
        }
        .catch{ err in
            return Just(RadioWatchViewState.Mutation.error(err.localizedDescription))
        }
        .receive(on: DispatchQueue.global(qos: .default))
        .eraseToAnyPublisher()
    }
    
    private func startStatusListener() -> AnyPublisher<RadioWatchViewState.Mutation, Never> {
        self.statusInteractor
            .execute()
            .map{ status -> RadioWatchViewState.Mutation in
                return .status(listeners: status.listeners)
        }
        .catch{ err in
            return Just(RadioWatchViewState.Mutation.error(err.localizedDescription))
        }
        .receive(on: DispatchQueue.global(qos: .default))
        .eraseToAnyPublisher()
    }
    
    private func startIsPlayingListener() -> AnyPublisher<RadioWatchViewState.Mutation, Never> {
        self.isPlayingInteractor
            .execute()
            .handleEvents(receiveOutput: { [weak self] result in
                self?.isPlaying = result
            })
            .map{ result -> RadioWatchViewState.Mutation in
                .isPlaying(result)
        }
        .receive(on: DispatchQueue.global(qos: .userInitiated))
        .eraseToAnyPublisher()
    }
}
