import Foundation

public struct RadioMainAPIResponseModel: Decodable {
    let main: RadioMainAPIResponseBody
    
    enum CodingKeys: String, CodingKey {
        case main
    }
}
struct RadioMainAPIResponseBody: Decodable {
    let np: String
    let listeners, bitrate: Int
    let isafkstream, isstreamdesk: Bool
    let current, startTime, endTime: Int
    let lastset: String
    let trackid: Int
    let thread: String
    let requesting: Bool
    let djname: String
    let dj: DJ
    let queue, lp: [LastPlayed]
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case np, listeners, bitrate, isafkstream, isstreamdesk, current
        case startTime = "start_time"
        case endTime = "end_time"
        case lastset, trackid, thread, requesting, djname, dj, queue, lp, tags
    }
}

struct DJ: Decodable {
    let id: Int
    let djname, djtext, djimage, djcolor: String
    let visible: Bool
    let priority: Int
    let css: String
    let themeID: Int
    let role: String

    enum CodingKeys: String, CodingKey {
        case id, djname, djtext, djimage, djcolor, visible, priority, css
        case themeID = "theme_id"
        case role
    }
}

struct LastPlayed: Decodable {
    let meta, time: String
    let type, timestamp: Int
}
