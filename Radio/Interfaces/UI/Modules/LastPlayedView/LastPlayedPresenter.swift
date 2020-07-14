import Foundation
import Combine
import Radio_domain
import Radio_app

protocol LastPlayedPresenter: ObservableObject {
    var lastPlayed: [TrackViewModel] { get }
}


class LastPlayedPresenterPreviewer: LastPlayedPresenter {
    @Published var lastPlayed: [TrackViewModel] = [TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub(),TrackViewModel.stub()]
}

class LastPlayedPresenterImp: LastPlayedPresenter {
    @Published var lastPlayed: [TrackViewModel] = []
    
    var lastPlayedInteractor: GetLastPlayedInteractor
    
    private var disposeBag = Set<AnyCancellable>()

    init(
        lastPlayed: GetLastPlayedInteractor
    ) {
        self.lastPlayedInteractor = lastPlayed
        
        self.startLastPlayedListener()
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
}
