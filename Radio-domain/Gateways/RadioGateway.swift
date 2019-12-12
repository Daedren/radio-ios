import Foundation
import Combine

protocol RadioGateway {
    func getCurrentTrack() -> AnyPublisher<Track,RadioError>
    func getCurrentStatus() -> AnyPublisher<RadioStatus,RadioError>
    func getSongQueue() -> AnyPublisher<[Track],RadioError>
    func getLastPlayed() -> AnyPublisher<[Track],RadioError>
    func getCurrentDJ() -> AnyPublisher<RadioDJ,RadioError>
}

enum RadioError: Error {
    case apiContentMismatch
}
