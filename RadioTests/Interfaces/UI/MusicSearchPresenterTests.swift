import XCTest
import Combine
import Radio_domain
import Mockingbird
@testable import Radio

class MusicSearchPresenterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMusicSearchPresenter_requestSong_success() {
        let cooldownStub = RequestTimeModel(canRequest: false, timeUntilCanRequest: Date().addingTimeInterval(TimeInterval(1800)))
        let cooldownMock = mock(CanRequestSongUseCase.self)
        given(cooldownMock.execute())
            .willReturn(Just(cooldownStub).eraseToAnyPublisher())
        
        let sut = MusicSearchPresenterImp(searchInteractor: nil,
                                          requestInteractor: FakeRequestInteractor(),
                                          statusInteractor: nil,
                                          cooldownInteractor: cooldownMock
        )
        sut.searchedTracks = [SearchedTrack(id: 1, title: "", artist: "", lastPlayed: nil, lastRequested: nil, requestable: true)]
        
        let statePublisher = sut.handleAction(
            SearchListAction.choose(0)
        )
//
        let expectations = [
            SearchListState.Mutation.loading(0),
            SearchListState.Mutation.notRequestable(0),
            SearchListState.Mutation.canRequestAt("29m 59s")
        ]
        
        
        let stateValues = try! awaitPublisher(statePublisher.collect(3))
        XCTAssertNotNil(stateValues)
        XCTAssertEqual(stateValues, expectations)
        return
    }
    
    func testMusicSearchPresenter_requestSong_failure() {
        let trackStub = [SearchedTrack(id: 1, title: "", artist: "", lastPlayed: nil, lastRequested: nil, requestable: true)]
        let cooldownStub = RequestTimeModel(canRequest: true, timeUntilCanRequest: nil)
        
        let cooldownMock = mock(CanRequestSongUseCase.self)
        given(cooldownMock.execute())
            .willReturn(Just(cooldownStub).eraseToAnyPublisher())
        
        let requestMock = mock(RequestSongUseCase.self)
        given(requestMock.execute(1)).willReturn(Just(false).setFailureType(to: RequestSongUseCaseError.self).eraseToAnyPublisher())
        
        let sut = MusicSearchPresenterImp(searchInteractor: nil,
                                          requestInteractor: requestMock,
                                          statusInteractor: nil,
                                          cooldownInteractor: cooldownMock
        )
        
        sut.searchedTracks = trackStub
        
        let statePublisher2 = sut.handleAction(
            SearchListAction.choose(0)
        )
        
        let expectations = [
            SearchListState.Mutation.loading(0),
            SearchListState.Mutation.songRequestable(0),
            SearchListState.Mutation.canRequest
        ]
        
        
        let stateValues = try! awaitPublisher(statePublisher2.collect(3))
        XCTAssertNotNil(stateValues)
        XCTAssertEqual(stateValues, expectations)
    }

}
