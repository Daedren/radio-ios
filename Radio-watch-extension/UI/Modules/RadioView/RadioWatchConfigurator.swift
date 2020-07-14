import Foundation
import Swinject
import Radio_domain
import SwiftUI

class RadioWatchConfigurator: Configurator {
    
    func configureFake() -> RadioWatchView<RadioWatchPresenterPreviewer> {
        RadioWatchView(presenter: RadioWatchPresenterPreviewer())
    }

    func configure() -> RadioWatchView<RadioWatchPresenterImp> {
        let view = RadioWatchView<RadioWatchPresenterImp>(
            presenter: self.inject().resolve(RadioWatchPresenterImp.self)!
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(RadioWatchPresenterImp.self) { _ in

                let presenter = RadioWatchPresenterImp(
                    play: self.assembler.resolver.resolve(PlayRadioUseCase.self)!,
                    pause: self.assembler.resolver.resolve(StopRadioUseCase.self)!,
                    currentTrack: self.assembler.resolver.resolve(GetCurrentTrackUseCase.self)!,
                    isPlaying: self.assembler.resolver.resolve(IsPlayingUseCase.self)!,
                    dj: self.assembler.resolver.resolve(GetDJInteractor.self)!,
                    status: self.assembler.resolver.resolve(GetCurrentStatusInteractor.self)!
                )
                return presenter
            }

        }
    }
}
