import Foundation
import Combine
import Radio_domain

public protocol RadioMapper {
    func map(from model: RadioMainAPIResponseModel) throws -> RadioDetailedModel
    func mapSearch(from model: SearchResponseModel) -> [SearchedTrack]
    func mapFavorite(from model: [GetFavoritesResponseModel]) throws -> [FavoriteTrack]
    func mapNews(from model: [GetNewsResponseModel]) throws -> [NewsEntry]
}


public struct RadioMapperImp: RadioMapper {
    let dateFormatter = DateFormatter()
    
    public init() {}
    
    public func map(from model: RadioMainAPIResponseModel) throws -> RadioDetailedModel {
        let dj = try mapDJ(from: model.main.dj)
        let currentTrack = try mapCurrentTrack(from: model)
        let queue = try mapToQueue(model: model)
        let lastPlayed = try mapToLastPlayed(model: model)
        let status = try mapStatus(from: model)
        
        let detailedModel = RadioDetailedModel(status: status,
                                               dj: dj,
                                               currentTrack: currentTrack,
                                               queue: queue,
                                               lastPlayed: lastPlayed)
        return detailedModel
    }
    
    func mapStatus(from model: RadioMainAPIResponseModel) throws -> RadioStatus {
        let main = model.main
        let entity = RadioStatus(listeners: main.listeners,
                                 bitrate: main.bitrate,
                                 currentTime: Date(timeIntervalSince1970: TimeInterval(main.current)),
                                 acceptingRequests: main.requesting,
                                 thread: main.thread == "none" ? "" : main.thread
        )
        return entity
    }
    
    func mapDJ(from dj: DJ) throws -> RadioDJ {
        let baseUrl = URL(string: "https://r-a-d.io/api/dj-image/")!
        let color = try mapColor(from: dj.djcolor)
        if let imageUrl = URL(string: dj.djimage, relativeTo: baseUrl) {
            let entity = RadioDJ(id: dj.id,
                                 name: dj.djname,
                                 text: dj.djtext,
                                 image: imageUrl,
                                 color: color,
                                 visible: dj.visible,
                                 priority: dj.priority)
            return entity
        }
        throw RadioError.apiContentMismatch
    }
    
    func mapColor(from model: String) throws -> Color {
        let hues = model.split(separator: " ")
        let integerHues = hues.compactMap{ Int($0) }
        if integerHues.count == 3 {
            return Color(red: integerHues[0], green: integerHues[1], blue: integerHues[2])
        }
        throw RadioError.apiContentMismatch
    }
    
    func mapCurrentTrack(from model: RadioMainAPIResponseModel) throws -> QueuedTrack {
        let main = model.main
        if let artistAndTitle = mapToArtistAndTitle(model: main.np) {
            let entity = QueuedTrack(title: artistAndTitle.title,
                                     artist: artistAndTitle.artist,
                                     startTime: Date(timeIntervalSince1970: TimeInterval(main.startTime)),
                                     endTime: Date(timeIntervalSince1970: TimeInterval(main.endTime)),
                                     currentTime: Date(timeIntervalSince1970: TimeInterval(main.current)),
                                     requested: false,
                                     tags: main.tags
            )
            return entity
        }
        throw RadioError.apiContentMismatch
    }
    
    func mapToQueue(model: RadioMainAPIResponseModel) throws -> [QueuedTrack] {
        let queue = model.main.queue
        let mappedQueue = queue.compactMap{ self.mapTrackHelper(track: $0, timestampIsStartTime: true) }
        
        if queue.count == mappedQueue.count {
            return mappedQueue
        }
        else {
            throw RadioError.apiContentMismatch
        }
    }
    
    func mapToLastPlayed(model: RadioMainAPIResponseModel) throws -> [QueuedTrack] {
        let queue = model.main.lp
        let mappedQueue = queue.compactMap{ self.mapTrackHelper(track: $0, timestampIsStartTime: false) }
        
        if queue.count == mappedQueue.count {
            return mappedQueue
        }
        else {
            throw RadioError.apiContentMismatch
        }
    }
    
    func mapTrackHelper(track: LastPlayed, timestampIsStartTime: Bool) -> QueuedTrack? {
        let timestamp = Date(timeIntervalSince1970: TimeInterval(track.timestamp))
        if let artistAndTitle = mapToArtistAndTitle(model: track.meta) {
            return QueuedTrack(title: artistAndTitle.title,
                               artist: artistAndTitle.artist,
                               startTime: timestampIsStartTime ? timestamp : nil,
                               endTime: timestampIsStartTime ? nil: timestamp,
                               requested: track.type == 1)
        }
        return nil
    }
    
    public func mapToArtistAndTitle(model: String) -> Track? {
        let separator = " - "
        guard let range = model
                .range(of: separator)
        else { return BaseTrack(title: model, artist: "") }
        
        let finalString = [model.prefix(upTo: range.lowerBound), model.suffix(from: range.upperBound)]
        
        if finalString.count == 2 {
            return BaseTrack(title: String(finalString[1]), artist: String(finalString[0]))
        }
        return nil
    }
    
    public func mapSearch(from model: SearchResponseModel) -> [SearchedTrack] {
        let tracks = model.data
        return tracks.map { SearchedTrack(id: $0.id,
                                          title: $0.title,
                                          artist: $0.artist,
                                          lastPlayed: Date(timeIntervalSince1970: TimeInterval($0.lastplayed)),
                                          lastRequested: Date(timeIntervalSince1970: TimeInterval($0.lastrequested)),
                                          requestable: $0.requestable)}
    }
    
    public func mapFavorite(from model: [GetFavoritesResponseModel]) throws -> [FavoriteTrack] {
        
        return try model.map {
            if let artistAndTitle = mapToArtistAndTitle(model: $0.name) {
                var lastPlayed: Date?
                var lastRequest: Date?
                if let modelDate = $0.lastplayed {
                    lastPlayed = Date(timeIntervalSince1970: TimeInterval(modelDate))
                }
                if let modelDate = $0.lastrequested {
                    lastRequest = Date(timeIntervalSince1970: TimeInterval(modelDate))
                }
                return FavoriteTrack(id: $0.id,
                                     title: artistAndTitle.title,
                                     artist: artistAndTitle.artist,
                                     lastPlayed: lastPlayed,
                                     lastRequested: lastRequest,
                                     requestCount: $0.requestcount)
            }
            throw RadioError.apiContentMismatch
        }
    }
    
    public func mapNews(from model: [GetNewsResponseModel]) throws -> [NewsEntry] {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return model.map {
            return NewsEntry(id: $0.id,
                             title: $0.title,
                             text: $0.text,
                             header: $0.header,
                             author: $0.author.user,
                             createdDate: dateFormatter.date(from: $0.createdAt) ?? Date(),
                             modifiedDate: dateFormatter.date(from: $0.updatedAt) ?? Date())
        }
    }
    
}
