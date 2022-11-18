import Foundation
import Combine


public protocol CanRequestSongUseCase {
    func execute() -> AnyPublisher<RequestTimeModel,Never>
}

public class CanRequestSongInteractor: CanRequestSongUseCase {
    var radioGateway: RadioGateway?
    var requestValidation: RequestLogic?
    
    public init(radioGateway: RadioGateway? = nil,
                requestValidation: RequestLogic? = nil) {
        self.radioGateway = radioGateway
        self.requestValidation = requestValidation
    }
    
    public func execute() -> AnyPublisher<RequestTimeModel,Never> {
        // Might be better to have the logic return the date.
        guard let requestValidation = self.requestValidation else { fatalError("Missing DI!") }

        let timeUntilCanRequest = requestValidation.timeUntilCanRequest()
        if let timeUntilCanRequest = timeUntilCanRequest {
            return Just(RequestTimeModel(canRequest: false, timeUntilCanRequest: timeUntilCanRequest))
                .eraseToAnyPublisher()
        } else {
            return
                self.radioGateway!.canRequestSong()
                .map{ apiCanRequest -> RequestTimeModel in
                    return RequestTimeModel(canRequest: apiCanRequest, timeUntilCanRequest: nil)
                }
                .catch{ _ in return Just(RequestTimeModel(canRequest: false, timeUntilCanRequest: nil)) }
                .eraseToAnyPublisher()
        }
    }
}

public enum CanRequestSongUseCaseError: Error {
    case cannotRequestUnknownTime
    case cannotRequestDueToTime(TimeInterval)
    case genericError(RadioError)
}
