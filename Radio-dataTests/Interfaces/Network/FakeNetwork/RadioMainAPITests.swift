import XCTest
import Combine
@testable import Radio_data

class RadioMainAPITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMapFakeToModel_NotNil() {
        let client = FakeNetworkClient()
        let result = client.execute(request: RadioMainAPI())
        
        XCTAssertNotNil(result)
    }
    
    func testMapFakeToModel_MapSuccess() {
        let client = FakeNetworkClient()
        let result = client.execute(request: RadioMainAPI())
        
        var storable = Set<AnyCancellable>()
        let expectation = self.expectation(description: "API")
        
        result.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                XCTFail("The request errored out: \(error)")
                break
            default:
                break
            }
            expectation.fulfill()
        }, receiveValue: { result in
            XCTAssertNotNil(result)
        }).store(in: &storable)
        
        self.waitForExpectations(timeout: 12.0, handler: { result in
            if let result = result {
                XCTFail("API took too long. Error: \(result)")
            }
        })
    }
    
}
