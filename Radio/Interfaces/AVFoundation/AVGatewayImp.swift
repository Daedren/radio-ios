import Foundation
import UIKit
import Combine
import Radio_Domain

public class AVGatewayImp: AVGateway {

    var client: AVClient
    
    init() {
        self.client = AVClient()
    }
    
    public func play() {
        client.play()
    }
    
    public func pause() {
        client.pause()
    }
    
    public func enqueue(url: URL) -> Bool {
        client.enqueue(url: url)
    }
    
    public func getSongName() -> AnyPublisher<String, Never> {
        return client.getSongName()
    }
    
}
