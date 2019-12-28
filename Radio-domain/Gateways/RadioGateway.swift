import Foundation
import Combine

public protocol RadioGateway {
    func getCurrentTrack() -> AnyPublisher<Track,RadioError>
    func getCurrentStatus() -> AnyPublisher<RadioStatus,RadioError>
    func getSongQueue() -> AnyPublisher<[Track],RadioError>
    func getLastPlayed() -> AnyPublisher<[Track],RadioError>
    func getCurrentDJ() -> AnyPublisher<RadioDJ,RadioError>
}

public enum RadioError: Error {
    case apiContentMismatch
}
