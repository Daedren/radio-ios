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
//                    router: container.resolve(WelcomeWireframe.self, argument: viewController)!,
                    play: self.assembler.resolver.resolve(PlayRadioInteractor.self)!,
                    pause: self.assembler.resolver.resolve(StopRadioInteractor.self)!,
                    songName: self.assembler.resolver.resolve(GetSongNameInteractor.self)!
                )
                return presenter
            }

        }
    }
}
