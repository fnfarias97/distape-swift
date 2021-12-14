//
//  TracksTableViewController.swift
//  MyApp
//
//  Created by Fernando Farias on 03/11/2021.
//

import UIKit

class TracksTableViewController: UITableViewController {

    var tracks: [Track] = myTracks

    override func viewDidLoad() {
        super.viewDidLoad()
        RestServiceManager.shared.getInfo(responseType: TrackResponse.self,
                                          method: .get, endpoint: "songs", body: "") { _, data in
                   if let dataResponse = data {
                       self.tracks = dataResponse.songs ?? []
                       self.tableView.reloadData()
                   }
               }
        self.tableView.backgroundColor = .black
        self.tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTable(_:)),
                                               name: NSNotification.Name("updateTable"),
                                               object: nil)

        let _ = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in // timer in
            NotificationCenter.default.post(name: NSNotification.Name("updateTable"), object: nil)
        }

        /* let DManager = DownloadManager.shared
        DManager.startDownload(url: URL(string: "https://speed.hetzner.de/100MB.bin")!) */
    }

    @objc func updateTable(_ notification: Notification) {
        tracks.append(Track(title: "asd", artist: "asd", album: "asd", songId: "25",
                            genre: .ska, duration: 40, year: 2010, albumCover: nil))
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toAudioPlayerVC", sender: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier",
                                                    for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        let track = tracks[indexPath.row]

        cell.track = track
        cell.parent = self
        cell.setParams(track: track)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.tableView.indexPathForSelectedRow
        if indexPath == nil {
            guard let myCell = sender as? UIButton else {
                return
            }
            var superview = myCell.superview
            while let view = superview, !(view is UITableViewCell) {
                superview = view.superview
            }
            guard let cell = superview as? UITableViewCell else {
                print("button is not contained in a table view cell")
                return
            }
            guard let myIndexPath = tableView.indexPath(for: cell) else {
                print("failed to get index path for cell containing button")
                return
            }
            indexPath = myIndexPath
        }
        let myTrack = tracks[(indexPath?.row)!]
        let audioPlayerVC = segue.destination as? AudioPlayerViewController

        audioPlayerVC?.mySong = myTrack
        audioPlayerVC?.parentVC = self
    }

}

extension TracksTableViewController: ButtonOnCellDelegate {
    func buttonTouchedOnCell(myTableViewCell: UITableViewCell) {
        /* var superview = myTableViewCell.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        print(indexPath.row) */
        self.performSegue(withIdentifier: "toAudioPlayerVC", sender: myTableViewCell)
    }
}

extension TracksTableViewController: PlayButtonDelegate {
    func playButtonTouched(indexPath: IndexPath) {
        print("touched")
        // let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        let cell = self.tableView.cellForRow(at: indexPath) as? TrackTableViewCell
        cell?.parent = self
        cell?.dummyPlayButton()
    }
}
