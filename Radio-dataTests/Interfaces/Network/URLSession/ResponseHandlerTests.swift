import XCTest
@testable import Radio_data

class ResponseHandlerTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetCSRFToken_Success() {
        let response = RadioResponseHandler()

        let filePath = Bundle.main.path(forResource: "RadioHomeAPIFake", ofType: "html")
        let url = URL(fileURLWithPath: filePath!)
        let data = try! Data(contentsOf: url)
        let fakeResponse = HTTPURLResponse(url: URL(string: "https://r-a-d.io")!, statusCode: 200, httpVersion: "2.0", headerFields: ["Content-Type":"text/html; charset=UTF-8"])
        let resp = try! response.getResponse(from: data, response: fakeResponse, toType: String.self)
        XCTAssertEqual(resp, "ZtcFLUJjNFGpeOsyhsEABEqVxLpX1cDsvL20BI1J")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
