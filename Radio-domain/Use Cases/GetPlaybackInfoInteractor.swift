import Foundation
import Combine

public class GetPlaybackInfoInteractor: Interactor {
    public typealias Input = Void
    public typealias Output = AnyPublisher<PlaybackInfo,Never>

    var avGateway: AVGateway?
    
    public init(avGateway: AVGateway? = nil) {
        self.avGateway = avGateway
    }
    
    public func execute(_: () = ()) -> AnyPublisher<PlaybackInfo, Never> {
        self.avGateway!.getPlaybackInfo()
    }
    
}
