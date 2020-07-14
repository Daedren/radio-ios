import Foundation
import Swinject
import Radio_domain
import SwiftUI

struct NewsListProperties {
    var titleBar: String
}

class NewsListConfigurator: Configurator {
    
    func configureFake() -> NewsListView<NewsListPresenterPreviewer> {
        NewsListView(presenter: NewsListPresenterPreviewer(),
                     properties: NewsListProperties(titleBar: "News"))
    }

    func configure() -> NewsListView<NewsListPresenterImp> {
        let properties = NewsListProperties(titleBar: "News")
        let view = NewsListView(
            presenter: self.inject().resolve(NewsListPresenterImp.self)!,
            properties: properties
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
