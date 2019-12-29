import Foundation
import Combine
import Radio_Domain

public protocol RadioMapper {
    func map(from model: RadioMainAPIResponseModel) throws -> RadioDetailedModel
}


struct RadioMapperImp: RadioMapper {
    func map(from model: RadioMainAPIResponseModel) throws -> RadioDetailedModel {
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
                                 acceptingRequests: main.requesting)
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
    
    func mapCurrentTrack(from model: RadioMainAPIResponseModel) throws -> Track {
        let main = model.main
        if let artistAndTitle = mapToArtistAndTitle(model: main.np) {
            let entity = Track(title: artistAndTitle.title,
                               artist: artistAndTitle.artist,
                               startTime: Date(timeIntervalSince1970: TimeInterval(main.startTime)),
                               endTime: Date(timeIntervalSince1970: TimeInterval(main.endTime)),
                               requested: false)
            return entity
        }
        throw RadioError.apiContentMismatch
    }
    
    func mapToQueue(model: RadioMainAPIResponseModel) throws -> [Track] {
        let queue = model.main.queue
        let mappedQueue = queue.compactMap{ self.mapTrackHelper(track: $0, timestampIsStartTime: true) }
        
        if queue.count == mappedQueue.count {
            return mappedQueue
        }
        else {
            throw RadioError.apiContentMismatch
        }
    }
    
    func mapToLastPlayed(model: RadioMainAPIResponseModel) throws -> [Track] {
        let queue = model.main.lp
        let mappedQueue = queue.compactMap{ self.mapTrackHelper(track: $0, timestampIsStartTime: false) }
        
        if queue.count == mappedQueue.count {
            return mappedQueue
        }
        else {
           throw RadioError.apiContentMismatch
        }
    }
    
    func mapTrackHelper(track: LastPlayed, timestampIsStartTime: Bool) -> Track? {
        let timestamp = Date(timeIntervalSince1970: TimeInterval(track.timestamp))
        if let artistAndTitle = mapToArtistAndTitle(model: track.meta) {
            return Track(title: artistAndTitle.title,
                         artist: artistAndTitle.artist,
                         startTime: timestampIsStartTime ? timestamp : nil,
                         endTime: timestampIsStartTime ? nil: timestamp,
                         requested: track.type == 1)
        }
        return nil
    }
    
    private func mapToArtistAndTitle(model: String) -> TrackTitleArtist? {
        let separator = " - "
        guard let range = model
            .range(of: separator)
            else { return nil }
        
        let finalString = [model.prefix(upTo: range.lowerBound), model.suffix(from: range.upperBound)]
        
        if finalString.count == 2 {
            return TrackTitleArtist(title: String(finalString[1]), artist: String(finalString[0]))
        }
        return nil
    }
}
