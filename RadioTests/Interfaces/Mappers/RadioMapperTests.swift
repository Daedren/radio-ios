import XCTest
@testable import Radio

class RadioMapperTests: XCTestCase {
    
    let mapper = RadioMapperImp()
    
    func testTrackHelper_Queue() {
        let track = LastPlayed(
            meta: "Hatsune Miku - Kogane no Seiya Sousetsu ni Kuchite",
            time: "<time class=\"timeago\" datetime=\"2019-12-27T04:27:36+0000\">04:27:36</time>",
            type: 1,
            timestamp: 1577420856)
        
        let result = mapper.mapTrackHelper(track: track, timestampIsStartTime: true)
        let startTime = Date(timeIntervalSince1970: 1577420856)
        XCTAssertNotNil(startTime)
        XCTAssertEqual(result?.endTime, nil)
        XCTAssertEqual(result?.startTime, startTime)
    }
    
    func testArtistTitle_StandardFormat_Success() {
        let value = "Hatsune Miku - Kogane no Seiya Sousetsu ni Kuchite"
        let result = mapper.mapToArtistAndTitle(model: value)
        
        XCTAssertEqual(result?.artist, "Hatsune Miku")
        XCTAssertEqual(result?.title, "Kogane no Seiya Sousetsu ni Kuchite")
    }
    
    func testArtistTitle_TwoDashes_Success() {
        let value = "秣本 瑳羅 - Esoterica - esoteria -"
        let result = mapper.mapToArtistAndTitle(model: value)
        
        XCTAssertEqual(result?.artist, "秣本 瑳羅")
        XCTAssertEqual(result?.title, "Esoterica - esoteria -")
    }
    
    func testArtistTitle_TwoDashesTogether_Success() {
        let value = "See-Saw - Obsession"
        let result = mapper.mapToArtistAndTitle(model: value)
        
        XCTAssertEqual(result?.artist, "See-Saw")
        XCTAssertEqual(result?.title, "Obsession")
    }
    
    func testArtistTitle_NoDashes_Success() {
        let value = "konata healing springs"
        let result = mapper.mapToArtistAndTitle(model: value)
        
        XCTAssertEqual(result?.artist, "")
        XCTAssertEqual(result?.title, "konata healing springs")
    }
}
