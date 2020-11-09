import XCTest
@testable import Radio_data

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
    
    func testNews_Standard_Success() {
        let stub = GetNewsResponseModel(id: 62,
                                        title: "Anison Hijack is Moving",
                                        text: "<p>Times in EDT:</p>\n\n<p>McDoogle: 9:00-9:45<br>\nSuzubrah: 9:45-10:30<br>\nYorozuya: 10:30-11:15<br>\nmercury: 11:15-12:00<br>\ndeswide: 12:00-12:45<br>\nRipVanWenkle: 12:45-1:30<br>\nBakkun: 1:30-END</p>\n",
                                        header: "<p>You know the drill. Here's who's playing: </p>\n",
                                        userID: 59,
                                        deletedAt: nil,
                                        createdAt: "2020-08-19 20:27:50",
                                        updatedAt: "2020-08-20 06:37:06",
                                        isNewsPrivate: 0,
                                        author: AuthorResponseModel(id: 59, user: "mcdoogle"))
        if let mapped = try? mapper.mapNews(from: [stub]),
           let result = mapped.first {
            XCTAssertEqual(result.createdDate, Date(timeIntervalSince1970: 1597868870))
            XCTAssertEqual(result.modifiedDate, Date(timeIntervalSince1970: 1597905426))
            XCTAssertEqual(result.title, stub.title)
            XCTAssertEqual(result.text, stub.text)
        } else {
            XCTFail()
        }
        
        
    }
}
