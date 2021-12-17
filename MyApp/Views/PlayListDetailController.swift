//
//  PlayListDetailController.swift
//  MyApp
//
//  Created by Fernando Farias on 30/11/2021.
//

import UIKit

class PlayListDetailController: UIViewController, UITableViewDelegate {

    let titleTF: UITextField = {
        let myTF = UITextField()
        myTF.font = UIFont.systemFont(ofSize: 16)
        myTF.placeholder = "Playlist..."
        myTF.borderStyle = UITextField.BorderStyle.roundedRect
        myTF.autocorrectionType = UITextAutocorrectionType.no
        myTF.keyboardType = UIKeyboardType.default
        myTF.returnKeyType = UIReturnKeyType.done
        myTF.clearButtonMode = UITextField.ViewMode.whileEditing
        myTF.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        myTF.translatesAutoresizingMaskIntoConstraints = false
        return myTF
    }()
    var addButton: UIButton = {
        let myB = UIButton(type: .custom)
        myB.setImage(UIImage(systemName: "plus.rectangle.fill.on.rectangle.fill"), for: .normal)
        myB.translatesAutoresizingMaskIntoConstraints = false
        return myB
    }()
    var tracks = Set<Track>()
    var trackList: [Track] = [Track]()
    var myTV: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        tableView.separatorColor = UIColor.systemBlue.withAlphaComponent(0.5)
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        self.view.addSubview(titleTF)
        NSLayoutConstraint.activate([
            titleTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            titleTF.heightAnchor.constraint(equalToConstant: 50)
        ])

        self.view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
            addButton.leadingAnchor.constraint(equalTo: titleTF.trailingAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        addButton.addTarget(self, action: #selector(showView), for: .touchUpInside)

        self.view.addSubview(myTV)
        myTV.layer.cornerRadius = 5
        NSLayoutConstraint.activate([
            myTV.topAnchor.constraint(equalTo: titleTF.bottomAnchor, constant: 20),
            myTV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myTV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myTV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        myTV.register(UITableViewCell.self, forCellReuseIdentifier: "templateCell")
        myTV.dataSource = self
        myTV.delegate = self
    }

    @objc func showView() {
        let trv = TracksPickerView(frame: CGRect(x: 0, y: self.view.frame.height/2,
                                                  width: self.view.frame.width, height: self.view.frame.height/2))
        trv.delegate = self
        self.view.addSubview(trv)
        trv.layer.masksToBounds = true
        trv.layer.cornerRadius = 10
    }

    /* override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myTV.frame = CGRect(x: 20, y: 150, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    } */
}

extension PlayListDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trackList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "templateCell", for: indexPath)
        let track = trackList[indexPath.row]
        cell.textLabel?.text = track.title
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tracks.remove(trackList[indexPath.row])
            trackList = Array(tracks)
            myTV.reloadData()
        }
    }
}

extension PlayListDetailController: TracksPickerDelegate {
    func addTrack(myTrack: Track) {
        tracks.insert(myTrack)
        trackList = Array(tracks)
        myTV.reloadData()
    }
}
