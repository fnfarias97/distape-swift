//
//  Options.swift
//  MyApp
//
//  Created by Fernando Farias on 03/12/2021.
//

import Foundation
import UIKit

enum MenuOptions: Int, CaseIterable {
    case deleteFromLibrary = 0, download, addToPlaylist, share,
         lyrics, shareLyrics, showAlbum, radioStation, love, suggestLess

    func actionCreator(iconName: String, actionTitle: String, actionClosure: @escaping () -> Void) -> UIAction {
        let icon = UIImage(systemName: iconName)
        return UIAction(title: actionTitle, image: icon) { _ in
            actionClosure()
        }
    }
}

class PlayerMenuButton: UIButton {
    var elements = [UIMenuElement]()

    let icon = UIImage(systemName: "music.note")
    var title = "Song Menu"
    var parentVC: AudioPlayerViewController?

    init(type: UIButton.ButtonType, parentVC: AudioPlayerViewController) {
        super.init(frame: .zero)
        self.parentVC = parentVC
        for option in MenuOptions.allCases {
            elements.append(menuActions(option))
        }
        self.setTitle("...", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        self.autoresizingMask = .flexibleWidth
        self.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 14.0, *) {
            self.showsMenuAsPrimaryAction = true
            self.menu = UIMenu(title: self.title, image: icon, identifier: nil,
                               options: .displayInline, children: elements)
        } else {
            let interaction = UIContextMenuInteraction(delegate: parentVC)
            self.addInteraction(interaction)
        }
    }
    // cyclomatic_complexity: ignores_case_statements: true
    func menuActions(_ option: MenuOptions) -> UIAction {
        let mySong = self.parentVC?.mySong

        switch option {
        case .deleteFromLibrary:
            return option.actionCreator(iconName: "trash", actionTitle: "Delete from Library",
                                        actionClosure: {print(self)})
        case .download:
            return option.actionCreator(iconName: "arrow.down.circle", actionTitle: "Download",
                                        actionClosure: {self.handleDownload(mySong, option: option)})
        case .addToPlaylist:
            return option.actionCreator(iconName: "text.badge.plus", actionTitle: "Add to a Playlist...",
                                 actionClosure: {print(self)})
        case .share:
            return option.actionCreator(iconName: "square.and.arrow.up", actionTitle: "Share Song...",
                                 actionClosure: {print(self)})
        case .lyrics:
            return option.actionCreator(iconName: "text.quote", actionTitle: "View Full Lyrics...",
                                 actionClosure: {print(self)})
        case .shareLyrics:
            return option.actionCreator(iconName: "quote.bubble",
                                        actionTitle: "Share Lyrics...", actionClosure: {print(self)})
        case .showAlbum:
            return option.actionCreator(iconName: "music.house",
                                        actionTitle: "Show Album", actionClosure: {print(self)})
        case .radioStation:
            return option.actionCreator(iconName: "badge.plus.radiowaves.right", actionTitle: "Create Station",
                                 actionClosure: {print(self)})
        case .love:
            let lovedSong = self.parentVC?.mySong?.isLoved
            var iconName: String
            var actionTitle: String

            if lovedSong! {
                iconName = "heart.slash"
                actionTitle = "Unlove"
            } else {
                iconName = "heart"
                actionTitle = "Love"
            }
            return option.actionCreator(iconName: iconName, actionTitle: actionTitle,
                                        actionClosure: {self.handleLove(option: option)})
        case .suggestLess:
            return option.actionCreator(iconName: "hand.thumbsdown", actionTitle: "Suggest Less Like This",
                                 actionClosure: {print(self)})
        }
    }

    private func handleDownload(_ mySong: Track?, option: MenuOptions) {
        let alert = UIAlertController(title: "Download",
                                      message: "Downloading \(mySong?.title ?? "") by \(mySong?.artist ?? "")",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.parentVC?.present(alert, animated: true, completion: nil)
        self.elements.remove(at: option.rawValue)
        self.parentVC?.refreshMenu(option: nil)
    }

    private func handleLove(option: MenuOptions) {
        let lovedSong = self.parentVC?.mySong?.isLoved
        let alert: UIAlertController
        let imgTitle: UIImage

        if lovedSong! {
            self.parentVC?.mySong?.isLoved = false
            alert = UIAlertController(title: "Unloved", message: "You Unloved this song",
                                          preferredStyle: .alert)
            imgTitle = UIImage(systemName: "heart.slash")!
        } else {
            self.parentVC?.mySong?.isLoved = true
            alert = UIAlertController(title: "Loved", message: "We'll recommend more like this in Listen Now",
                                          preferredStyle: .alert)
            imgTitle = UIImage(systemName: "heart")!
        }
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imgViewTitle.image = imgTitle

        alert.view.addSubview(imgViewTitle)
        alert.addAction(action)
        self.parentVC?.present(alert, animated: true, completion: nil)
        let rawValueFix: Int = self.elements.count-1 - (MenuOptions.allCases.count-1 - option.rawValue)
        self.elements.remove(at: rawValueFix)
        self.parentVC?.refreshMenu(option: option)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
