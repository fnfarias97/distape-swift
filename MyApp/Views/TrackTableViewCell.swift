//
//  TrackTableViewCell.swift
//  MyApp
//
//  Created by Fernando Farias on 04/11/2021.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    var track: Track?
    var parent: ButtonOnCellDelegate?
    var songTitle: UILabel = {
        return addLabel(myTitle: "Song Title", fontSize: 23)
    }()
    var artist: UILabel = {
        return addLabel(myTitle: "Artist", fontSize: 16)
    }()
    var albumCover: UIImageView = {
        return addImage(imageName: "audiotrack")
    }()
    var playButton: HighlightButton = {
        let button = HighlightButton(type: .system)
        let myIcon = UIImage(named: "play_circle")
        let mySecIcon = UIImage(named: "pause_circle")
        let tintedImage = myIcon?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.icon = myIcon
        button.secondIcon = mySecIcon
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: -1, left: -1, bottom: -1, right: -1)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = .black
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .black
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setParams(track: Track) {
        self.track = track
        self.songTitle.text = track.title
        self.artist.text = track.artist
        self.addSubview(albumCover)
        NSLayoutConstraint.activate([
            albumCover.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            albumCover.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            albumCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            albumCover.widthAnchor.constraint(equalTo: albumCover.heightAnchor)
        ])
        self.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor)
        ])

        if parent != nil {
            playButton.addTarget(self, action: #selector(touchHandler(myTableViewCell:)),
                                 for: .touchUpInside)
        }

        self.addSubview(songTitle)
        NSLayoutConstraint.activate([
            songTitle.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            songTitle.heightAnchor.constraint(equalToConstant: 35),
            songTitle.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 5),
            songTitle.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -5)
        ])
        self.addSubview(artist)
        NSLayoutConstraint.activate([
            artist.heightAnchor.constraint(equalToConstant: 35),
            artist.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            artist.leadingAnchor.constraint(equalTo: albumCover.trailingAnchor, constant: 5),
            artist.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -5)
        ])
    }

    @objc func touchHandler(myTableViewCell: UITableViewCell) {
        _ = parent?.buttonTouchedOnCell(myTableViewCell: myTableViewCell)
        dummyPlayButton()
    }

    func dummyPlayButton() {
        self.playButton.performTwoStateSelection()
    }
}

func addImage(imageName: String) -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: imageName)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .white
    return imageView
}

func addLabel(myTitle: String?, fontSize: CGFloat) -> UILabel {
    let myLabel = UILabel()
    myLabel.text = myTitle
    myLabel.font = UIFont.systemFont(ofSize: fontSize)
    myLabel.textColor = .white
    myLabel.translatesAutoresizingMaskIntoConstraints = false
    return myLabel
}

func addButton(myImageTitle: String) -> UIButton {
    let button = UIButton(type: .system)
    let myImage = UIImage(named: myImageTitle)
    let tintedImage = myImage?.withRenderingMode(.alwaysTemplate)
    button.setImage(tintedImage, for: .normal)
    button.backgroundColor = .white
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = button.frame.height / 2
    button.tintColor = .black
    return button
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
