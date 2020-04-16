import Foundation
import Swinject
import Radio_Domain
import SwiftUI

class NewsListConfigurator: Configurator {
    
//    func configureFake() -> NewsListView<NewsListPresenterPreviewer> {
//        NewsListView(presenter: NewsListPresenterPreviewer())
//    }

    func configure() -> NewsListView {
        let view = NewsListView(
            presenter: self.inject().resolve(NewsListPresenterImp.self)!
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(NewsListPresenterImp.self) { _ in

                let presenter = NewsListPresenterImp(
                    getNewsInteractor: self.assembler.resolver.resolve(GetNewsListInteractor.self)!,
                    htmlParser: self.assembler.resolver.resolve(HTMLParser.self)!
                )
                return presenter
            }

        }
    }
}
