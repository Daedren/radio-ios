import Foundation
import Combine

public protocol RequestSongUseCase {
    func execute(_ input: Int) -> AnyPublisher<Bool,RequestSongUseCaseError>
}

public class RequestSongInteractor: RequestSongUseCase, Interactor {
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

        return self.checkCooldown()
            .flatMap { [unowned self] _ in
                self.acceptingRequests()
            }
            .flatMap { [unowned self] _ -> AnyPublisher<Bool, RequestSongUseCaseError> in
                self.requestSong(songId: input)
            }
            .handleEvents(receiveOutput: { [weak self] result in
                if result {
                    self?.requestValidation?.hasRequested()
                }
            })
            .eraseToAnyPublisher()
    }

    private func acceptingRequests() -> AnyPublisher<Bool, RequestSongUseCaseError> {
        guard let radioGateway = self.radioGateway
        else { fatalError("Missing DI!") }

        return radioGateway
            .getCurrentStatus()
            .first()
            .mapError{ RequestSongUseCaseError.genericError($0) }
            .flatMap{ status -> AnyPublisher<Bool, RequestSongUseCaseError> in
                if status.acceptingRequests {
                    return Just(true)
                        .setFailureType(to: RequestSongUseCaseError.self)
                        .eraseToAnyPublisher()
                } else {
                    return Fail(outputType: Bool.self, failure: RequestSongUseCaseError.notAcceptingRequests)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func checkCooldown() -> AnyPublisher<Bool, RequestSongUseCaseError> {
        guard let requestValidation = self.requestValidation,
              let radioGateway = self.radioGateway
        else { fatalError("Missing DI!") }

        let timeUntilCanRequest = requestValidation.timeUntilCanRequest()
        if let timeUntilCanRequest = timeUntilCanRequest {
            return Fail(error: RequestSongUseCaseError.cannotRequestDueToTime(timeUntilCanRequest))
                .eraseToAnyPublisher()
        }

        return radioGateway.canRequestSong()
            .mapError{ return RequestSongUseCaseError.genericError($0) }
            .flatMap { notInCooldown -> AnyPublisher<Bool, RequestSongUseCaseError> in
                if notInCooldown {
                    return Just(true)
                        .setFailureType(to: RequestSongUseCaseError.self)
                        .eraseToAnyPublisher()
                } else {
                    return Fail(outputType: Bool.self, failure: RequestSongUseCaseError.cannotRequestUnknownTime)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func requestSong(songId: Int) -> AnyPublisher<Bool, RequestSongUseCaseError> {
        self.radioGateway!
            .request(songId: songId)
            .mapError{ return RequestSongUseCaseError.genericError($0) }
            .eraseToAnyPublisher()
    }

}

public enum RequestSongUseCaseError: Error {
    case cannotRequestUnknownTime
    case cannotRequestDueToTime(Date)
    case notAcceptingRequests
    case genericError(RadioError)
}
