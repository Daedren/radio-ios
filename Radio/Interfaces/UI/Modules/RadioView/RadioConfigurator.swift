import Foundation
import Swinject
import Radio_domain
import SwiftUI

class RadioConfigurator: Configurator {
    
    func configureFake() -> RadioView<RadioPresenterPreviewer> {
        RadioView(presenter: RadioPresenterPreviewer())
    }

    func configure() -> RadioView<RadioPresenterImp> {
        let view = RadioView<RadioPresenterImp>(
            presenter: self.inject().resolve(RadioPresenterImp.self)!
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(RadioPresenterImp.self) { _ in

                let presenter = RadioPresenterImp(
                    play: self.assembler.resolver.resolve(PlayRadioUseCase.self)!,
                    pause: self.assembler.resolver.resolve(StopRadioUseCase.self)!,
                    currentTrack: self.assembler.resolver.resolve(GetCurrentTrackUseCase.self)!,
                    isPlaying: self.assembler.resolver.resolve(IsPlayingUseCase.self)!,
                    queue: self.assembler.resolver.resolve(GetSongQueueInteractor.self)!,
                    lastPlayed: self.assembler.resolver.resolve(GetLastPlayedInteractor.self)!,
                    dj: self.assembler.resolver.resolve(GetDJInteractor.self)!,
                    status: self.assembler.resolver.resolve(GetCurrentStatusInteractor.self)!
                )
                return presenter
            }

        }
    }
}
