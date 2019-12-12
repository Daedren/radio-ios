import Foundation
import Swinject
import Radio_Domain

class RadioConfigurator: Configurator {

    func configure() -> RadioView {
        let view = RadioView(
            presenter: self.inject().resolve(RadioPresenter.self)!
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(RadioPresenter.self) { _ in

                let presenter = RadioPresenter(
                    play: self.assembler.resolver.resolve(PlayRadioUseCase.self)!,
                    pause: self.assembler.resolver.resolve(StopRadioUseCase.self)!,
                    songName: self.assembler.resolver.resolve(GetSongNameUseCase.self)!
                )
                return presenter
            }

        }
    }
}
