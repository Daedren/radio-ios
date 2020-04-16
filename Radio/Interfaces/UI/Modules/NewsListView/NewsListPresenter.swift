import Foundation
import UIKit
import Combine
import Radio_Domain

class NewsListPresenterImp: ObservableObject {
    @Published var returnedValues: [NewsEntryViewModel] = []
    
    var searchDisposeBag = Set<AnyCancellable>()
    
    var getNewsInteractor: GetNewsListInteractor?
    var htmlParser: HTMLParser?
    
    var newsEntries = [NewsEntry]()
    
    init(getNewsInteractor: GetNewsListInteractor,
         htmlParser: HTMLParser) {
        self.getNewsInteractor = getNewsInteractor
        self.htmlParser = htmlParser
        
        
        getNewsInteractor.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] nextNews in
                    self?.newsEntries = nextNews
                    self?.returnedValues = self?.createViewModels(from: nextNews) ?? []
                    
            })
            .store(in: &searchDisposeBag)
    }
    
    func createViewModels(from requests: [NewsEntry]) -> [NewsEntryViewModel] {
        return requests.map{ entry in
            let body = self.htmlParser?.parse(htmlString: entry.text) ?? NSMutableAttributedString()
            return NewsEntryViewModel(id: entry.id,
                                      title: entry.title,
                                      body: AppAttributedString(value: body),
                                      createdAt: entry.createdDate,
                                      author: entry.author)
        }
    }
}
