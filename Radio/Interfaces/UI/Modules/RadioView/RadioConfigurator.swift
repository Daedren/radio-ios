import Foundation
import Radio_cross
import Radio_domain
import SwiftUI

class RadioConfigurator: Configurator {
    
    func configureFake() -> RadioView<RadioPresenterPreviewer> {
        RadioView(presenter: RadioPresenterPreviewer(), bigVersion: false)
    }

    func configureBig() -> RadioView<RadioPresenterImp> {
        self.inject()
        let view = RadioView<RadioPresenterImp>(
            presenter: InjectSettings.shared.resolve(RadioPresenterImp.self)!,
            bigVersion: true
        )
        return view
    }
    
    func configureSmall() -> RadioView<RadioPresenterImp> {
        self.inject()
        let view = RadioView<RadioPresenterImp>(
            presenter: InjectSettings.shared.resolve(RadioPresenterImp.self)!,
            bigVersion: false
        )
        return view
    }

    private func inject(){
            InjectSettings.shared.register(RadioPresenterImp.self) {

                let presenter = RadioPresenterImp(
                    play: InjectSettings.shared.resolve(PlayRadioUseCase.self)!,
                    pause: InjectSettings.shared.resolve(StopRadioUseCase.self)!,
                    currentTrack: InjectSettings.shared.resolve(GetCurrentTrackUseCase.self)!,
                    isPlaying: InjectSettings.shared.resolve(IsPlayingUseCase.self)!,
                    queue: InjectSettings.shared.resolve(GetSongQueueInteractor.self)!,
                    lastPlayed: InjectSettings.shared.resolve(GetLastPlayedInteractor.self)!,
                    dj: InjectSettings.shared.resolve(GetDJInteractor.self)!,
                    status: InjectSettings.shared.resolve(GetCurrentStatusUseCase.self)!,
                    getScales: InjectSettings.shared.resolve(GetFourierScalesUseCase.self)!
                )
                return presenter
            }

        }
    }
