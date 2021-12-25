import XCTest
@testable import Radio_domain

class SongDelayLogicTests: XCTestCase {
    
    func testSongDelayLogic_oldSong_notInCD() throws {
        let sut = SongDelayLogic()
        let stub = FavoriteTrack(id: 3962,
                                 title: "title",
                                 artist: "artist",
                                 lastPlayed: Date(timeIntervalSince1970: 1589262314),
                                 lastRequested: Date(timeIntervalSince1970: 1589260322),
                                 requestCount: 0)
        
        let isInCD = sut.isSongUnderCooldown(track: stub)
        
        XCTAssertFalse(isInCD)
    }
    
    func testSongDelayLogic_justRequested_InCD() throws {
        let sut = SongDelayLogic()
        
        let stub = FavoriteTrack(id: 3962,
                                 title: "title",
                                 artist: "artist",
                                 lastPlayed: Date(timeIntervalSince1970: 1638232588),
                                 lastRequested: Date(timeIntervalSince1970: 1640188446),
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
