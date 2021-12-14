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
    /* override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    } */

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

    /* @objc func buttonTouchedOnCell(myTableViewCell: UITableViewCell) {
        // guard let tabBarController = self.window?.rootViewController as? UITabBarController else { return }
        // print(tabBarController)
        let mainVC = UIStoryboard(name: "Main", bundle: nil)
        let audioPlayerVC = mainVC.instantiateViewController(
            withIdentifier: "AudioPlayerVC") as? AudioPlayerViewController
        print(audioPlayerVC)
        audioPlayerVC?.modalPresentationStyle = .overCurrentContext
        // self.window?.rootViewController?.present(audioPlayerVC!, animated: true, completion: nil)
        // self.window?.rootViewController?.tabBarController?.present(audioPlayerVC!, animated: true, completion: nil)
        // self.windowr.performSegue(withIdentifier: "toAudioPlayerVC", sender: tabBarController)
        self.window?.rootViewController?.performSegue(withIdentifier: "toAudioPlayerVC",
     sender: self.window?.rootViewController)

        // self.inputViewController?.tabBarController?.present(audioPlayerVC!, animated: true, completion: nil)
        print("gello")
    }*/
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
    // imageView.autoresizingMask = .flexibleWidth
    imageView.contentMode = .scaleAspectFit
    imageView.image = UIImage(named: imageName)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    // imageView.frame = CGRect(x: myX, y: myY, width: widthHeight, height: widthHeight)
    imageView.backgroundColor = .white
    return imageView
}

func addLabel(myTitle: String?, fontSize: CGFloat) -> UILabel {
    let myLabel = UILabel()
    myLabel.text = myTitle
    myLabel.font = UIFont.systemFont(ofSize: fontSize)
    myLabel.textColor = .white
    // myLabel.autoresizingMask = .flexibleWidth
    myLabel.translatesAutoresizingMaskIntoConstraints = false
    // myLabel.frame = CGRect(x: 60, y: myY, width: UIScreen.main.bounds.width - 150, height: 50)
    // myLabel.textAlignment = .center
    return myLabel
}

func addButton(myImageTitle: String) -> UIButton {
    let button = UIButton(type: .system)
    let myImage = UIImage(named: myImageTitle)
    let tintedImage = myImage?.withRenderingMode(.alwaysTemplate)
    button.setImage(tintedImage, for: .normal)
    // button.imageEdgeInsets = UIEdgeInsets(top: widthHeight/1.2, left: widthHeight/1.2,
    //                                      bottom: widthHeight/1.2, right: widthHeight/1.2)
    button.backgroundColor = .white
    // button.autoresizingMask = .flexibleWidth
    button.translatesAutoresizingMaskIntoConstraints = false
    // button.frame=CGRect(x: myX, y: myY, width: widthHeight, height: widthHeight)
    button.layer.cornerRadius = button.frame.height / 2
    // button.layer.borderWidth = 1
    // button.layer.borderColor = UIColor.black.cgColor
    button.tintColor = .black
    // button.frame.size = CGSize(width: widthHeight, height: widthHeight)

    return button
}
