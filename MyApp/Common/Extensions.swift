//
//  Extensions.swift
//  MyApp
//
//  Created by Fernando Farias on 06/12/2021.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let pat: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pat, options: [])
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return matches.count == 1 ? true : false
        } catch let error {
            print(error.localizedDescription)
        }
        print("unkown error")
        return false
    }
}

extension UIViewController {
    public func addLabel(_ myTitle: String?, fontSize: CGFloat) -> UILabel {
        let title = UILabel()
        title.text = myTitle ?? "Unknown"
        title.font = UIFont.systemFont(ofSize: fontSize)
        title.autoresizingMask = .flexibleWidth
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        self.view.addSubview(title)
        return title
    }

    public func addButton(_ myTitle: String, fontSize: CGFloat = 16) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(myTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.autoresizingMask = .flexibleWidth
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        return button
    }

    public func addSlider() -> UISlider {
        let slider = UISlider()
        slider.autoresizingMask = .flexibleWidth
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(slider)
        return slider
    }
}

extension UIViewController: UIContextMenuInteractionDelegate {
    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                       // swiftlint:disable:next line_length
                                       configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
      var menuElements = [UIMenuElement]()
      for option in MenuOptions.allCases {
          menuElements.append(option.menuActions())
      }
      return UIContextMenuConfiguration(identifier: nil,
                                        previewProvider: nil) { _ in
                                        UIMenu(title: "Song Menu", children: menuElements)
                                      }
    }

    /* func menuBuilder(menuTitle: String, senderButton: UIButton) -> Void {
        if #available(iOS 14.0, *) {
            var menuElements = [UIMenuElement]()
            let icon = UIImage(systemName: "music.note")
            for option in MenuOptions.allCases {
                menuElements.append(option.menuActions())
            }
            senderButton.showsMenuAsPrimaryAction = true
            senderButton.menu = UIMenu(title: "Song Menu", image: icon,
                                            identifier: nil, options: .displayInline, children: menuElements)
        } else {
            let interaction = UIContextMenuInteraction(delegate: self)
            senderButton.addInteraction(interaction)
        }
    } */
}

extension UITextField {
    func errorAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = 4
        animation.duration = 0.4/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [10, -10]
        self.layer.add(animation, forKey: "shake")
    }

    func startInController() {
       self.alpha = 0
       UIView.animate(withDuration: 1, delay: 0.2, animations: {
           self.alpha = 1
       })
   }
}
