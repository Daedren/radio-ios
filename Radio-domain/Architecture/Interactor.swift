
import Foundation

public protocol Interactor {
    associatedtype Input
    associatedtype Output
    func execute(_ input: Input) -> Output
}
