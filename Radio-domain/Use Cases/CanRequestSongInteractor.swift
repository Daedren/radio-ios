import Foundation
import Combine


public class CanRequestSongInteractor: Interactor {
    public typealias Input = Void
    public typealias Output = AnyPublisher<RequestTimeModel,Never>
    
    var radioGateway: RadioGateway?
    var requestValidation: RequestLogic?
    
    public init(radioGateway: RadioGateway? = nil,
                requestValidation: RequestLogic? = nil) {
        self.radioGateway = radioGateway
        self.requestValidation = requestValidation
    }
    
    public func execute(_ input: () = ()) -> AnyPublisher<RequestTimeModel,Never> {
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
    
    private func requestSong(songId: Int) -> AnyPublisher<Bool, CanRequestSongUseCaseError> {
        self.radioGateway!
            .request(songId: songId)
            .mapError{
                return CanRequestSongUseCaseError.genericError($0)
            }
            .eraseToAnyPublisher()
    }
    
}

public enum CanRequestSongUseCaseError: Error {
    case cannotRequestUnknownTime
    case cannotRequestDueToTime(TimeInterval)
    case genericError(RadioError)
}
