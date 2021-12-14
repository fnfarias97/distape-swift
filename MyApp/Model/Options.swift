//
//  Options.swift
//  MyApp
//
//  Created by Fernando Farias on 03/12/2021.
//

import Foundation
import UIKit

enum MenuOptions: CaseIterable {
    case deleteFromLibrary, download, addToPlaylist, share,
         lyrics, shareLyrics, showAlbum, radioStation, love, suggestLess

    private func actionCreator(iconName: String, actionTitle: String, actionClosure: @escaping () -> Void) -> UIAction {
        let icon = UIImage(systemName: iconName)
        return UIAction(title: actionTitle, image: icon) { _ in
            actionClosure()
        }
    }

    func menuActions() -> UIAction {
        switch self {
        case .deleteFromLibrary:
            return actionCreator(iconName: "trash", actionTitle: "Delete from Library", actionClosure: {print(self)})
        case .download:
            return actionCreator(iconName: "arrow.down.circle", actionTitle: "Download", actionClosure: {print(self)})
        case .addToPlaylist:
            return actionCreator(iconName: "text.badge.plus", actionTitle: "Add to a Playlist...",
                                 actionClosure: {print(self)})
        case .share:
            return actionCreator(iconName: "square.and.arrow.up", actionTitle: "Share Song...",
                                 actionClosure: {print(self)})
        case .lyrics:
            return actionCreator(iconName: "text.quote", actionTitle: "View Full Lyrics...",
                                 actionClosure: {print(self)})
        case .shareLyrics:
            return actionCreator(iconName: "quote.bubble", actionTitle: "Share Lyrics...", actionClosure: {print(self)})
        case .showAlbum:
            return actionCreator(iconName: "music.house", actionTitle: "Show Album", actionClosure: {print(self)})
        case .radioStation:
            return actionCreator(iconName: "badge.plus.radiowaves.right", actionTitle: "Create Station",
                                 actionClosure: {print(self)})
        case .love:
            return actionCreator(iconName: "heart", actionTitle: "Love", actionClosure: {
                let alert = UIAlertController(title: "Loved", message: "We'll recommend more like this in Listen Now",
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)

                let imgTitle = UIImage(systemName: "heart")
                let imgViewTitle = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
                imgViewTitle.image = imgTitle

                alert.view.addSubview(imgViewTitle)
                alert.addAction(action)
                // present(alert, animated: true, completion: nil)
                // self.parent
                // self.present(alert, animated: true, completion: nil)
            })
        case .suggestLess:
            return actionCreator(iconName: "hand.thumbsdown", actionTitle: "Suggest Less Like This",
                                 actionClosure: {print(self)})
        }
    }
}

class PlayerMenuButton: UIButton {

    let playerMenu: UIMenu = {
        var menuElements = [UIMenuElement]()
        for option in MenuOptions.allCases {
            menuElements.append(option.menuActions())
        }

        let icon = UIImage(systemName: "music.note")
        return UIMenu(title: "Song Menu", image: icon, identifier: nil, options: .displayInline, children: menuElements)
    }()
}
