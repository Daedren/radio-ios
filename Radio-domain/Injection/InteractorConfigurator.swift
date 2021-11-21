import Foundation
import Radio_cross

public class InteractorConfigurator {
    public init() {
        InjectSettings.shared.register(SongDelayLogic.self) {
            return SongDelayLogic()
        }
        
        InjectSettings.shared.register(RequestLogic.self) {
            return RequestLogic()
        }
        
        InjectSettings.shared.register(PlayRadioUseCase.self) {
            return PlayRadioInteractor(
                avGateway: InjectSettings.shared.resolve(MusicGateway.self)!
            )
        }
        InjectSettings.shared.register(StopRadioUseCase.self) {
            return StopRadioInteractor(
                avGateway: InjectSettings.shared.resolve(MusicGateway.self)!
            )
        }
        InjectSettings.shared.register(GetCurrentTrackUseCase.self) {
            return GetCurrentTrackInteractor(
                avGateway: InjectSettings.shared.resolve(MusicGateway.self),
                radioGateway: InjectSettings.shared.resolve(RadioGateway.self)!
            )
        }
        
        InjectSettings.shared.register(GetSongQueueInteractor.self) {
            return GetSongQueueInteractor(
                radio: InjectSettings.shared.resolve(RadioGateway.self)!
            )
        }
        InjectSettings.shared.register(GetLastPlayedInteractor.self) {
            return GetLastPlayedInteractor(
                radio: InjectSettings.shared.resolve(RadioGateway.self)!
            )
        }
        
        InjectSettings.shared.register(IsPlayingUseCase.self) {
            return IsPlayingInteractor(
                avGateway: InjectSettings.shared.resolve(MusicGateway.self)!
            )
        }
        
        InjectSettings.shared.register(GetDJInteractor.self) {
            return GetDJInteractor(
                radio: InjectSettings.shared.resolve(RadioGateway.self)!
            )
        }
        InjectSettings.shared.register(GetCurrentStatusInteractor.self) {
            return GetCurrentStatusInteractor(
                radio: InjectSettings.shared.resolve(RadioGateway.self)!
            )
        }
        InjectSettings.shared.register(GetPlaybackInfoInteractor.self) {
            return GetPlaybackInfoInteractor(
                avGateway: InjectSettings.shared.resolve(MusicGateway.self)!
            )
        }
        InjectSettings.shared.register(SearchForTermInteractor.self) {
            return SearchForTermInteractor(
                radioGateway: InjectSettings.shared.resolve(RadioGateway.self)!
            )
        }
        
        InjectSettings.shared.register(RequestSongInteractor.self) {
            return RequestSongInteractor(
                radioGateway: InjectSettings.shared.resolve(RadioGateway.self)!,
                requestValidation: InjectSettings.shared.resolve(RequestLogic.self)!
            )
        }
        
        InjectSettings.shared.register(GetFavoritesInteractor.self) {
            return GetFavoritesInteractor(
                radioGateway: InjectSettings.shared.resolve(RadioGateway.self)!,
                songDelayCalc: InjectSettings.shared.resolve(SongDelayLogic.self)!
            )
        }
        
        InjectSettings.shared.register(GetNewsListInteractor.self) {
            return GetNewsListInteractor(
                radioGateway: InjectSettings.shared.resolve(RadioGateway.self)!
            )
        }
        
        InjectSettings.shared.register(CanRequestSongInteractor.self) {
            return CanRequestSongInteractor(
                radioGateway: InjectSettings.shared.resolve(RadioGateway.self)!,
                requestValidation: InjectSettings.shared.resolve(RequestLogic.self)!
            )
        }
        
        InjectSettings.shared.register(FetchRadioDataUseCase.self) {
            return FetchRadioDataInteractor(
                radioGateway: InjectSettings.shared.resolve(RadioGateway.self)!
            )
        }
        
        InjectSettings.shared.register(GetFourierScalesUseCase.self) {
            return GetFourierScalesInteractor(
                avGateway: InjectSettings.shared.resolve(MusicGateway.self)!
            )
        }
    }
}
