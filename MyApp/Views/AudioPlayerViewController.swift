//
//  AudioPlayerViewController.swift
//  MyApp
//
//  Created by Fernando Farias on 05/11/2021.
//

import UIKit
import Foundation
import AudioPlayer

class AudioPlayerViewController: UIViewController {

    var isPlaying: Bool = false
    var mySoundURL: String?
    var mySound: AudioPlayer?
    var mySong: Track?
    var parentVC: PlayButtonDelegate?

    // var volumeSlider: UISlider?
    var timeSlider: UISlider?
    var timer: Timer? = Timer()
    var timePosition: TimeInterval? {
        didSet {
            let time = NSInteger(timePosition ?? 0)
            let seconds = time % 60
            let minutes = (time / 60) % 60
            self.timeLabel.text = String(format: "%0.2d:%0.2d", minutes, seconds)
        }

    }
    var timeLabel: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 15)
        title.autoresizingMask = .flexibleWidth
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        return title
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mySongID = mySong?.songId else { return }
        mySoundURL = mySongID+".mp3"
        do {
            mySound = try? AudioPlayer(fileName: mySoundURL!)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerPosition),
                                         userInfo: nil, repeats: true)
            timePosition = mySound?.currentTime
            mySound?.play()
            isPlaying = !isPlaying
        }
        self.view.backgroundColor = UIColor(named: "Background")
        let songTitleLabel = addLabel(mySong?.title, fontSize: 30)
        let artistLabel = addLabel(mySong?.artist, fontSize: 20)
        let playButton = addButton("Stop")
        playButton.addTarget(self, action: #selector(soundHandler(_:)), for: .touchUpInside)
        timeSlider = addSlider()
        timeSlider?.addTarget(self, action: #selector(timeHandler(_:)), for: .valueChanged)
        self.view.addSubview(timeLabel)
        let myGif = addGif()
        let optionsMenuButton = addButton("...", fontSize: 40)
        createMenu(optionsMenuButton)
        NSLayoutConstraint.activate([
            myGif.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            myGif.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myGif.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeSlider!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            timeSlider!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeSlider!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            timeLabel.centerYAnchor.constraint(equalTo: timeSlider!.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: timeSlider!.trailingAnchor, constant: 20),
            playButton.bottomAnchor.constraint(equalTo: timeSlider!.topAnchor, constant: -40),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            songTitleLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -20),
            songTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            songTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            songTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            artistLabel.bottomAnchor.constraint(equalTo: songTitleLabel.topAnchor, constant: -10),
            artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            optionsMenuButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor, constant: -10),
            optionsMenuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }

    override func viewDidDisappear(_ animated: Bool) {
        mySound = nil
        self.parentVC?.playButtonTouched(indexPath: [0, Int(mySong!.songId)! - 1])
    }

    @objc func soundHandler(_ sender: UIButton?) {
        switch sender?.titleLabel?.text {
        case "Play":
            guard !isPlaying else {return}
            mySound?.play()
            sender?.setTitle("Stop", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerPosition),
                                         userInfo: nil, repeats: true)
        case "Stop":
            guard isPlaying else {return}
            mySound?.stop()
            sender?.setTitle("Play", for: .normal)
            timer?.invalidate()
            timer = nil
        default:
            if isPlaying {
                mySound?.stop()
            } else {
                mySound?.play()
            }
        }
        isPlaying = !isPlaying
        isPlaying ? print("Playing") : print("Not Playing")
    }

    @objc func volumeHandler(_ sender: UISlider) {
        mySound?.volume = sender.value
    }
    @objc func timerPosition() {
        guard var time = mySound?.currentTime else {return}
        timePosition = time
        time /= mySound!.duration
        timeSlider?.value = Float(time)
    }
    @objc func timeHandler(_ sender: UISlider) {
        timePosition = Double(sender.value) * (mySound?.duration ?? 1)
        mySound?.currentTime = TimeInterval(timePosition!)
    }

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        soundHandler(nil)
    }

    /* private func addImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.autoresizingMask = .flexibleWidth
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.frame = CGRect(x: 20, y: 350, width: 50, height: 50)
        imageView.image = UIImage(named: "Logo")
        self.view.addSubview(imageView)
        return imageView
    } */

    private func addGif() -> UIImageView {
        let myGif = UIImageView()
        let myGifURL: String? = Bundle.main.path(forResource: "stegosaurus-studio", ofType: ".gif")
        myGif.translatesAutoresizingMaskIntoConstraints = false
        myGif.image = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: myGifURL!))
        self.view.addSubview(myGif)
        return myGif
    }

    private func createMenu(_ sender: UIButton) {
        if #available(iOS 14.0, *) {
            var menuElements = [UIMenuElement]()
            let icon = UIImage(systemName: "music.note")
            for option in MenuOptions.allCases {
                menuElements.append(option.menuActions())
            }
            sender.showsMenuAsPrimaryAction = true
            sender.menu = UIMenu(title: "Song Menu", image: icon,
                                            identifier: nil, options: .displayInline, children: menuElements)
        } else {
            let interaction = UIContextMenuInteraction(delegate: self)
            sender.addInteraction(interaction)
        }
    }
}
