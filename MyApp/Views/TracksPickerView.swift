//
//  TracksPickerView.swift
//  MyApp
//
//  Created by Fernando Farias on 01/12/2021.
//

import UIKit

protocol TracksPickerDelegate: AnyObject {
    func addTrack(myTrack: Track)
}

class TracksPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myTracks.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let rowStr = myTracks[row]
        return rowStr.title
    }

    weak var delegate: TracksPickerDelegate?
    var removeView: UIButton = {
        let myB = UIButton(type: .custom)
        myB.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        myB.tintColor = .red
        return myB
    }()
    var addSong: UIButton = {
        let myB = UIButton(type: .custom)
        myB.setImage(UIImage(systemName: "cross.circle.fill"), for: .normal)
        myB.tintColor = .green
        return myB
    }()
    var pickerView: UIPickerView = UIPickerView()

    override func draw(_ rect: CGRect) {
            let dimension = 35

            removeView.frame = CGRect(x: 3, y: 3, width: dimension, height: dimension)
            self.addSubview(removeView)
            removeView.addTarget(self, action: #selector(close), for: .touchUpInside)

            addSong.frame = CGRect(x: Int(rect.width) - (dimension + 3), y: 3, width: dimension, height: dimension)
            self.addSubview(addSong)
            addSong.addTarget(self, action: #selector(add), for: .touchUpInside)

            pickerView.frame = CGRect(x: 0, y: 30, width: rect.width, height: rect.height-30)
            pickerView.delegate = self
            pickerView.dataSource = self
            self.addSubview(pickerView)
        }

        @objc func close () {
            self.removeFromSuperview()
        }

        @objc func add () {
            if delegate != nil {
                let index = pickerView.selectedRow(inComponent: 0)
                let track = myTracks[index]
                delegate?.addTrack(myTrack: track)
            }
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            self.backgroundColor = .lightGray
          }

}
