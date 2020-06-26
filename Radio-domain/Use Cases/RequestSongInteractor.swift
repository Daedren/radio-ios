import Foundation
import Combine


public class RequestSongInteractor: Interactor {
    public typealias Input = Int
    public typealias Output = AnyPublisher<Bool,RequestSongUseCaseError>
    
    var radioGateway: RadioGateway?
    var requestValidation: RequestLogic?
    
    public init(radioGateway: RadioGateway? = nil,
                requestValidation: RequestLogic? = nil) {
        self.radioGateway = radioGateway
        self.requestValidation = requestValidation
    }
    
    public func execute(_ input: Input) -> Output {
        guard let requestValidation = self.requestValidation else { fatalError("Missing DI!") }

        let timeUntilCanRequest = requestValidation.timeUntilCanRequest()
        if let timeUntilCanRequest = timeUntilCanRequest {
            return Fail(error: RequestSongUseCaseError.cannotRequestDueToTime(timeUntilCanRequest))
                .eraseToAnyPublisher()
            
        } else {
            return
                self.radioGateway!.canRequestSong()
                .mapError{
                    return RequestSongUseCaseError.genericError($0)
                }
                .flatMap{ [unowned self] canRequest -> AnyPublisher<Bool, RequestSongUseCaseError> in
                    if canRequest {
                        return self.requestSong(songId: input)
                    }
                    return Fail(error: RequestSongUseCaseError.cannotRequestUnknownTime)
                        .eraseToAnyPublisher()
                }
                .handleEvents(receiveOutput: { [weak self] result in
                    if result {
                        self?.requestValidation?.hasRequested()
                    }
                }).eraseToAnyPublisher()
        }
    }
    
    private func requestSong(songId: Int) -> AnyPublisher<Bool, RequestSongUseCaseError> {
        self.radioGateway!
            .request(songId: songId)
            .mapError{
                return RequestSongUseCaseError.genericError($0)
            }
            .eraseToAnyPublisher()
    }
    
}

public enum RequestSongUseCaseError: Error {
    case cannotRequestUnknownTime
    case cannotRequestDueToTime(Date)
    case genericError(RadioError)
}
