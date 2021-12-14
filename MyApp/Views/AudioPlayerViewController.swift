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

    var volumeSlider: UISlider?
    var timeSlider: UISlider?
    var timer: Timer? = Timer()
    var timePosition: TimeInterval? {
        willSet {
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
        // mySoundURL = String(format: "%02d", mySongID)+".mp3"
        mySoundURL = mySongID+".mp3"
        do {
            mySound = try? AudioPlayer(fileName: mySoundURL!)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerPosition),
                                         userInfo: nil, repeats: true)
            timePosition = mySound?.currentTime
        }

        mySound?.volume = 0.5
        self.view.backgroundColor = UIColor(named: "Background")

        let songTitleLabel = addLabel(mySong?.title, fontSize: 30)
        let playButton = addButton("Play")
        playButton.addTarget(self, action: #selector(soundHandler(_:)), for: .touchUpInside)
        let stopButton = addButton("Stop")
        stopButton.addTarget(self, action: #selector(soundHandler(_:)), for: .touchUpInside)
        timeSlider = addSlider()
        timeSlider?.addTarget(self, action: #selector(timeHandler(_:)), for: .valueChanged)
        let volumeLabel = addLabel("Volume", fontSize: 16)
        volumeSlider = addSlider()
        volumeSlider?.value = 0.5
        volumeSlider?.addTarget(self, action: #selector(volumeHandler(_:)), for: .valueChanged)
        self.view.addSubview(timeLabel)
        let myGif = UIImageView()
        let myGifURL: String? = Bundle.main.path(forResource: "stegosaurus-studio", ofType: ".gif")
        myGif.translatesAutoresizingMaskIntoConstraints = false
        myGif.image = UIImage.animatedImage(withAnimatedGIFURL: URL(fileURLWithPath: myGifURL!))
        self.view.addSubview(myGif)
        mySound?.play()
        isPlaying = !isPlaying

        let optionsMenuButton = addButton("...", fontSize: 40)

        NSLayoutConstraint.activate([
            songTitleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            songTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            songTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            songTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: songTitleLabel.bottomAnchor, constant: 40),
            playButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            stopButton.topAnchor.constraint(equalTo: songTitleLabel.bottomAnchor, constant: 40),
            stopButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            timeSlider!.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            timeSlider!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            timeSlider!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                    constant: -80),
            volumeLabel.topAnchor.constraint(equalTo: timeSlider!.bottomAnchor, constant: 40),
            volumeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            volumeSlider!.topAnchor.constraint(equalTo: volumeLabel.bottomAnchor, constant: 20),
            volumeSlider!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            volumeSlider!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                    constant: -self.view.frame.width/2),
            myGif.topAnchor.constraint(equalTo: volumeSlider!.bottomAnchor, constant: 50),
            myGif.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            myGif.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            optionsMenuButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor, constant: -5),
            optionsMenuButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timeSlider!.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: timeSlider!.trailingAnchor, constant: 20)
        ])
        if #available(iOS 14.0, *) {
            var menuElements = [UIMenuElement]()
            let icon = UIImage(systemName: "music.note")
            for option in MenuOptions.allCases {
                menuElements.append(option.menuActions())
            }
            optionsMenuButton.showsMenuAsPrimaryAction = true
            optionsMenuButton.menu = UIMenu(title: "Song Menu", image: icon,
                                            identifier: nil, options: .displayInline, children: menuElements)
        } else {
            let interaction = UIContextMenuInteraction(delegate: self)
            optionsMenuButton.addInteraction(interaction)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        mySound = nil
        self.parentVC?.playButtonTouched(indexPath: [0, Int(mySong!.songId)! - 1])
        // let viewControllers = self.navigationController?.viewControllers
        // print(viewControllers)
    }
    @objc func soundHandler(_ sender: UIButton?) {
        switch sender?.titleLabel?.text {
        case "Play":
            guard !isPlaying else {return}
            mySound?.play()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerPosition),
                                         userInfo: nil, repeats: true)
        case "Stop":
            guard isPlaying else {return}
            mySound?.stop()
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

    private func addImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.autoresizingMask = .flexibleWidth
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.frame = CGRect(x: 20, y: 350, width: 50, height: 50)
        imageView.image = UIImage(named: "Logo")
        self.view.addSubview(imageView)
        return imageView
    }
}
