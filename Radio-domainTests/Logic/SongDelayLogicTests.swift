import XCTest
@testable import Radio_domain

class SongDelayLogicTests: XCTestCase {
    
    func testSongDelayLogic_oldSong_notInCD() throws {
        let sut = SongDelayLogic()

        let lastPlayed = Calendar.current.date(byAdding: .day, value: -9, to: Date())
        let lastReq = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        
        let stub = FavoriteTrack(id: 3962,
                                 title: "title",
                                 artist: "artist",
                                 lastPlayed: lastPlayed,
                                 lastRequested: lastReq,
                                 requestCount: 2)
        
        let isInCD = sut.isSongUnderCooldown(track: stub)
        XCTAssertFalse(isInCD)
    }
    
    func testSongDelayLogic_justRequested_InCD() throws {
        let sut = SongDelayLogic()
        
        let lastPlayed = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        let lastReq = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        let stub = FavoriteTrack(id: 3962,
                                 title: "title",
                                 artist: "artist",
                                 lastPlayed: lastPlayed,
                                 lastRequested: lastReq,
                                 requestCount: 2)
        
        let isInCD = sut.isSongUnderCooldown(track: stub)
        XCTAssertTrue(isInCD)
    }
    
    func testSongDelayLogic_delay2req_2d5h() throws {
        let sut = SongDelayLogic()
        
        let delay = sut.delay(2)
        
        XCTAssertEqual(delay, 191700)
    }
    
    func testSongDelayLogic_delay8req_112h12m() throws {
        let sut = SongDelayLogic()
        
        let delay = sut.delay(8)
        
        XCTAssertEqual(delay, 403956.8602586973)
    }


}
