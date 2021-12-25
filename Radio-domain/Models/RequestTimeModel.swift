import Foundation

public struct RequestTimeModel {
    public var canRequest: Bool
    public var timeUntilCanRequest: Date?
    
    public init(canRequest: Bool, timeUntilCanRequest: Date? = nil) {
        self.canRequest = canRequest
        self.timeUntilCanRequest = timeUntilCanRequest
    }
}
