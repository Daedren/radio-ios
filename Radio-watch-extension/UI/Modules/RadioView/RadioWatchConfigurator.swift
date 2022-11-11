import Foundation
import Radio_cross
import Radio_domain
import SwiftUI

class RadioWatchConfigurator: Configurator {
    
    func configureFake() -> RadioWatchView<RadioWatchPresenterPreviewer> {
        RadioWatchView(presenter: RadioWatchPresenterPreviewer())
    }

    func configure() -> RadioWatchView<RadioWatchPresenterImp> {
        self.inject()
        let view = RadioWatchView<RadioWatchPresenterImp>(
            presenter: InjectSettings.shared.resolve(RadioWatchPresenterImp.self)!
        )
        return view
    }

    private func inject(){
        
            
            InjectSettings.shared.register(RadioWatchPresenterImp.self) {

                let presenter = RadioWatchPresenterImp(
                    play: InjectSettings.shared.resolve(PlayRadioUseCase.self)!,
                    pause: InjectSettings.shared.resolve(StopRadioUseCase.self)!,
                    currentTrack: InjectSettings.shared.resolve(GetCurrentTrackUseCase.self)!,
                    isPlaying: InjectSettings.shared.resolve(IsPlayingUseCase.self)!,
                    dj: InjectSettings.shared.resolve(GetDJInteractor.self)!,
                    status: InjectSettings.shared.resolve(GetCurrentStatusUseCase.self)!
                )
                return presenter
            }

        }
    }
