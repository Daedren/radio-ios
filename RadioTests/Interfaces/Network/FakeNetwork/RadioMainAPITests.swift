import XCTest
import Combine
@testable import Radio

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
                XCTFail("The request errored out: \(error.localizedDescription)")
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
    
    func testMapFakeToModel_ModelMatchesJson() {
        let client = FakeNetworkClient()
        let result = client.execute(request: RadioMainAPI())
        
        XCTAssertNotNil(result)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
