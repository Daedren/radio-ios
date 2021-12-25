import Radio_domain
import Combine

class FakeRequestInteractor: RequestSongUseCase {
    let stub: Bool
    init(result: Bool = true) {
        self.stub = result
    }
    
    func execute(_ input: Int) -> AnyPublisher<Bool,RequestSongUseCaseError> {
        
        return Just(stub)
            .setFailureType(to: RequestSongUseCaseError.self)
            .eraseToAnyPublisher()
    }
}

//class FakeCooldownInteractor: CanRequestSongUseCase {
//    func execute(_ input: ()) -> AnyPublisher<RequestTimeModel, Never> {
//        return Just(RequestTimeModel(canRequest: true))
//            .eraseToAnyPublisher()
//    }
//}

class FakeSearchInteractor: SearchForTermUseCase {
    let stub: [SearchedTrack]
    init(result: [SearchedTrack]) {
        self.stub = result
    }
    func execute(_ input: String) -> AnyPublisher<[SearchedTrack],RadioError> {
        return Just(stub)
            .setFailureType(to: RadioError.self)
            .eraseToAnyPublisher()
    }
}

