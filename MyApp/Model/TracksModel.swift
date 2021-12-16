//
//  TrackModel.swift
//  MyApp
//
//  Created by Fernando Farias on 01/12/2021.
//

import Foundation

struct TrackResponse: Codable {
    var songs: [Track]?

    enum CodingKeys: CodingKey {
        case songs
    }
}

struct Track: Codable, Hashable {
    let title: String
    var artist: String?
    var album: String?
    let songId: String
    // var genre: Genres?
    var genre: String?
    var duration: Int?
    var year: Int?
    var albumCover: String?

    var isLoved: Bool = false

    private enum CodingKeys: String, CodingKey {
        case songId = "song_id"
        case title // = "name"
        case duration
        case artist
        case album
        case year
        case albumCover
    }

    /* enum Genres: Int {
        case rock = 0, pop, trap, altrock, folk, cumbia, rkt, edm, trance, techno, punk, ska, metal, trash
    } */
}

enum PlayerStates {
    case play, pause, next, previous
}

var myTracks = [Track]()
