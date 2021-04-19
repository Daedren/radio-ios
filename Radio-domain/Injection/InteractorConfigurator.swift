import Foundation
import Swinject

public class InteractorConfigurator: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(SongDelayLogic.self) { _ in
            return SongDelayLogic()
        }
        container.register(RequestLogic.self) { _ in
            return RequestLogic()
        }
        
        container.register(PlayRadioUseCase.self) { _ in
            return PlayRadioInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
        container.register(StopRadioUseCase.self) { _ in
            return StopRadioInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
        container.register(GetCurrentTrackUseCase.self) { _ in
            return GetCurrentTrackInteractor(
                avGateway: container.resolve(AVGateway.self),
                radioGateway: container.resolve(RadioGateway.self)!
            )
        }
        
        container.register(GetSongQueueInteractor.self) { _ in
            return GetSongQueueInteractor(
                radio: container.resolve(RadioGateway.self)!
            )
        }
        container.register(GetLastPlayedInteractor.self) { _ in
            return GetLastPlayedInteractor(
                radio: container.resolve(RadioGateway.self)!
            )
        }
        
        container.register(IsPlayingUseCase.self) { _ in
            return IsPlayingInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
        
        container.register(GetDJInteractor.self) { _ in
            return GetDJInteractor(
                radio: container.resolve(RadioGateway.self)!
            )
        }
        container.register(GetCurrentStatusInteractor.self) { _ in
            return GetCurrentStatusInteractor(
                radio: container.resolve(RadioGateway.self)!
            )
        }
        container.register(GetPlaybackInfoInteractor.self) { _ in
            return GetPlaybackInfoInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
        container.register(SearchForTermInteractor.self) { _ in
            return SearchForTermInteractor(
                radioGateway: container.resolve(RadioGateway.self)!
            )
        }
        
        container.register(RequestSongInteractor.self) { _ in
            return RequestSongInteractor(
                radioGateway: container.resolve(RadioGateway.self)!,
                requestValidation: container.resolve(RequestLogic.self)!
            )
        }
        
        container.register(GetFavoritesInteractor.self) { _ in
            return GetFavoritesInteractor(
                radioGateway: container.resolve(RadioGateway.self)!,
                songDelayCalc: container.resolve(SongDelayLogic.self)!
            )
        }
        
        container.register(GetNewsListInteractor.self) { _ in
            return GetNewsListInteractor(
                radioGateway: container.resolve(RadioGateway.self)!
            )
        }
        
        container.register(CanRequestSongInteractor.self) { _ in
            return CanRequestSongInteractor(
                radioGateway: container.resolve(RadioGateway.self)!,
                requestValidation: container.resolve(RequestLogic.self)!
            )
        }
        
        container.register(FetchRadioDataUseCase.self) { _ in
            return FetchRadioDataInteractor(
                radioGateway: container.resolve(RadioGateway.self)!
            )
        }
        
        container.register(GetFourierScalesUseCase.self) { _ in
            return GetFourierScalesInteractor(
                avGateway: container.resolve(AVGateway.self)!
            )
        }
    }
}
