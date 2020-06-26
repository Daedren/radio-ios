import Foundation

public class RequestLogic {
    private let requestDelay = TimeInterval(1800)
    private var lastRequested: Date?
    
    public init() {}
    
    func timeUntilCanRequest() -> Date? {
        if let lastRequested = self.lastRequested {
            var canRequestTime = lastRequested
            canRequestTime.addTimeInterval(self.requestDelay)
            
            if canRequestTime < Date() {
                return nil
            } else {
                return canRequestTime
            }
        } else {
            return nil
        }
    }
    
    func hasRequested(at date: Date = Date()) {
        lastRequested = date
    }
    
}
