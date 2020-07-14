import XCTest
@testable import Radio_domain

class RequestLogicTests: XCTestCase {

    func testRequestLogic_Req50MinutesAgo_canRequest() throws {
        let sut = RequestLogic()
        let requestTime = Date().addingTimeInterval(TimeInterval(-3000))
        sut.hasRequested(at: requestTime)
        
        let result = sut.timeUntilCanRequest()
        XCTAssertEqual(result, nil)
    }
    
    func testRequestLogic_Req20MinutesAgo_cannotRequest() throws {
        let sut = RequestLogic()
        let requestTime = Date().addingTimeInterval(TimeInterval(-1200))
        sut.hasRequested(at: requestTime)
        
        let result = sut.timeUntilCanRequest()
        XCTAssertNotNil(result)
        XCTAssertGreaterThan(result!, Date())
    }


}
