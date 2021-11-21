import Foundation
import Radio_cross
import Radio_domain
import Radio_interfaces
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
        self.inject()
        let view = NewsListView(
            presenter: InjectSettings.shared.resolve(NewsListPresenterImp.self)!,
            properties: properties
        )
        return view
    }

    private func inject(){
        
            
            InjectSettings.shared.register(NewsListPresenterImp.self) {

                let presenter = NewsListPresenterImp(
                    getNewsInteractor: InjectSettings.shared.resolve(GetNewsListInteractor.self)!,
                    htmlParser: InjectSettings.shared.resolve(HTMLParser.self)!
                )
                return presenter
            }

        }
    }
