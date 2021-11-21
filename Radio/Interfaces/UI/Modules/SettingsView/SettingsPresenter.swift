import Foundation
import UIKit
import Combine
import Radio_domain
import Radio_interfaces

protocol SettingsPresenter: ObservableObject {
    var state: SettingsPresenterState { get }
    func start(actions: AnyPublisher<SettingsViewAction, Never>)
}

enum SettingsOptions: Int, CaseIterable {
    case siri
    
    var title: String {
        switch self {
        case .siri:
            return "Siri"
        }
    }
}


class SettingsPresenterPreviewer: SettingsPresenter {
    @Published var state = SettingsPresenterState()
    
    func start(actions: AnyPublisher<SettingsViewAction, Never>) {
        
    }
    
    init() {
        state.options = [ListOptionViewModel.stub(),
                          ListOptionViewModel.stub(),
                          ListOptionViewModel.stub()]
    }
}

class SettingsPresenterImp: SettingsPresenter {
    @Published var state = SettingsPresenterState()
    
    var disposeBag = Set<AnyCancellable>()
    
    func start(actions: AnyPublisher<SettingsViewAction, Never>) {
        actions
            .flatMap(handleAction)
            .prepend(createViewModels())
            .scan(SettingsPresenterState.initial, SettingsPresenterState.reduce(state:mutation:))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { newState in
                self.state = newState
            })
            .store(in: &disposeBag)
    }
    
    private func handleAction(_ action: SettingsViewAction) -> AnyPublisher<SettingsPresenterState.Mutation, Never> {
        switch action {
        case let .tappedOption(index):
            return self.goToOption(at: index)
        }
    }
    
    private func createViewModels() -> AnyPublisher<SettingsPresenterState.Mutation, Never> {
            let options = SettingsOptions.allCases.map{
            return ListOptionViewModel(id: $0.rawValue,
                                       title: $0.title,
                                       icon: nil)
        }
        
        return Just(SettingsPresenterState.Mutation.options(options))
            .eraseToAnyPublisher()
    }
    
    func goToOption(at index: Int) -> AnyPublisher<SettingsPresenterState.Mutation, Never> {
        
        return Empty<SettingsPresenterState.Mutation, Never>()
            .eraseToAnyPublisher()
    }
}
