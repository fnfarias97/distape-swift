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

class HighlightButton: UIButton {
    var icon: UIImage?
    var secondIcon: UIImage?
    var isPlaying: Bool = false

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
        self.backgroundColor = .clear
        // self.tintColor = .green
    }

    func performTwoStateSelection() {
        self.isPlaying = !isPlaying
        self.setImage(!isPlaying ? icon : secondIcon, for: .normal)
        self.setImage(!isPlaying ? icon : secondIcon, for: .highlighted)
    }

    func setImage(icon: UIImage?) {
        guard let icon = icon else { return }
        self.icon = icon
        self.setImage(icon, for: .normal)
        self.setImage(icon, for: .highlighted)
    }
}

var myTracks = [Track]()
