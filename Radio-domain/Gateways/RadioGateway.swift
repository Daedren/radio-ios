import Foundation
import Combine

public protocol RadioGateway {
    func getCurrentTrack() -> AnyPublisher<QueuedTrack,RadioError>
    func getCurrentStatus() -> AnyPublisher<RadioStatus,RadioError>
    func getSongQueue() -> AnyPublisher<[QueuedTrack],RadioError>
    func getLastPlayed() -> AnyPublisher<[QueuedTrack],RadioError>
    func getCurrentDJ() -> AnyPublisher<RadioDJ,RadioError>
    func searchFor(term: String) -> AnyPublisher<[SearchedTrack], RadioError>
    func request(songId: Int) -> AnyPublisher<Bool, RadioError>
    func updateNow()
    func getTrackWith(identifier: String) -> QueuedTrack?
}

public enum RadioError: Error {
    case apiContentMismatch
    case unknown
}
