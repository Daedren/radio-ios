import Foundation
import Combine

public class GetSongQueueInteractor: Interactor {
    public typealias Input = Void
    public typealias Output = AnyPublisher<[QueuedTrack],RadioError>

    var radio: RadioGateway?
    
    public init(radio: RadioGateway? = nil) {
        self.radio = radio
    }
    
    public func execute(_: () = ()) -> AnyPublisher<[QueuedTrack], RadioError> {
        self.radio!.getSongQueue()
    }
    
}
