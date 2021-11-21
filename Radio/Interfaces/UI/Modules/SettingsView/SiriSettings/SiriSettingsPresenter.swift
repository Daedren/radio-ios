import Foundation
import UIKit
import SwiftUI
import Combine
import Radio_domain
import Radio_interfaces
import Intents

protocol SiriSettingsPresenter: ObservableObject {
    var state: SiriSettingsPresenterState { get }
    var leave: WireframeDestination? { get set }
    func start(actions: AnyPublisher<SiriSettingsViewAction, Never>)
}


class SiriSettingsPresenterPreviewer: SiriSettingsPresenter {
    @Published var state = SiriSettingsPresenterState()
    @Published var leave: WireframeDestination?

    
    func start(actions: AnyPublisher<SiriSettingsViewAction, Never>) {
        
    }
    
    init() {
        state.options = [ListOptionViewModel.stub(),
                          ListOptionViewModel.stub(),
                          ListOptionViewModel.stub()]
    }
}

class SiriSettingsPresenterImp: SiriSettingsPresenter {
    @Published var state = SiriSettingsPresenterState()
    @Published var leave: WireframeDestination?
    
    var disposeBag = Set<AnyCancellable>()
    var intentManager = IntentManager()
    var intents = [IntentModel]()
    
    func start(actions: AnyPublisher<SiriSettingsViewAction, Never>) {
        self.intents = self.intentManager.getIntents()
        
        actions
            .flatMap(handleAction)
            .prepend(createViewModels(for: self.intents))
            .scan(SiriSettingsPresenterState.initial, SiriSettingsPresenterState.reduce(state:mutation:))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { newState in
                self.state = newState
            })
            .store(in: &disposeBag)
    }
    
    private func handleAction(_ action: SiriSettingsViewAction) -> AnyPublisher<SiriSettingsPresenterState.Mutation, Never> {
        switch action {
        case let .tappedOption(index):
            let intent = self.intents[index]
            return self.donate(intent: intent)
        }
    }
    
    private func createViewModels(for intents: [IntentModel]) -> AnyPublisher<SiriSettingsPresenterState.Mutation, Never> {
            let options = intents.map{
                return ListOptionViewModel(id: $0.rawValue,
                                       title: $0.title,
                                       icon: nil)
        }
        
        return Just(SiriSettingsPresenterState.Mutation.options(options))
            .eraseToAnyPublisher()
    }
    
    func donate(intent: IntentModel) -> AnyPublisher<SiriSettingsPresenterState.Mutation, Never> {
        if let result = self.intentManager.get(intent: intent) {
            self.leave = WireframeDestination(id: result)
        }
        return Empty<SiriSettingsPresenterState.Mutation, Never>()
            .eraseToAnyPublisher()
    }
}
