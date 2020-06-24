import Foundation
import Combine

public protocol FetchRadioDataUseCase {
    func execute(_: ())
}

public class FetchRadioDataInteractor: Interactor, FetchRadioDataUseCase {
    public typealias Input = Void
    public typealias Output = Void

    var radio: RadioGateway?
    
    public init(radioGateway: RadioGateway? = nil) {
        self.radio = radioGateway
    }
    
    public func execute(_: () = ()) {
        self.radio!.updateNow()
    }
    
}
