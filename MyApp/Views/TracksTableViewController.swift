//
//  TracksTableViewController.swift
//  MyApp
//
//  Created by Fernando Farias on 03/11/2021.
//

import UIKit
import CoreData

class TracksTableViewController: UITableViewController {

    var tracks: [Track] = myTracks

    override func viewDidLoad() {
        super.viewDidLoad()

        self.savedData()

        self.tableView.backgroundColor = .black
        self.tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.tintColor = .white
        self.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }

    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view

        if Connectivity.isConnectedToInternet() {
            print("Refreshing Data")
            DispatchQueue.main.async {
                self.downloadTracks()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    func savedData() {
            // Check if there's not internet connection
        if !Connectivity.isConnectedToInternet() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.managedObjectContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Track_")
            request.returnsObjectsAsFaults = false

            do {
                let result = try context!.fetch(request)
                myTracks = [Track]()

                guard let resultData = result as? [NSManagedObject] else { return }
                for data in resultData {
                    let title = data.value(forKey: "title") as? String
                    let artist = data.value(forKey: "artist") as? String
                    let album = data.value(forKey: "album") as? String
                    let genre = data.value(forKey: "genre") as? String
                    let songId = data.value(forKey: "song_id") as? String

                    let track = Track(title: title!, artist: artist, album: album,
                                      songId: songId!, genre: genre!)
                    myTracks.append(track)
                }
                self.tracks = myTracks
            } catch {
                print("Failed to obtain info from DB, \(error), \(error.localizedDescription)")
            }

        } else {
            // only if there's internet
            self.downloadTracks()
        }
    }

    func downloadTracks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.managedObjectContext

        RestServiceManager.shared.getInfo(responseType: TrackResponse.self,
                                          method: .get, endpoint: "songs", body: "") { _, data in
           if let dataResponse = data {
               myTracks = dataResponse.songs ?? []
               self.tracks = myTracks

               // Using CoreData
               if let context = context {

                   // Remove Content
                   let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Track_")
                   let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                   do {
                       try appDelegate.persistentStoreCoordinator?.execute(deleteRequest, with: context)
                   } catch {
                       print(error)
                   }

                   // Add Content
                   for item in dataResponse.songs! {
                       let trackEntity = NSEntityDescription.insertNewObject(forEntityName: "Track_", into: context)

                       trackEntity.setValue(item.artist, forKey: "artist")
                       trackEntity.setValue(item.genre, forKey: "genre")
                       trackEntity.setValue(item.album, forKey: "album")
                       trackEntity.setValue(item.songId, forKey: "song_id")
                       trackEntity.setValue(item.title, forKey: "title")
                       trackEntity.setValue(item.albumCover, forKey: "album_cover")
                       trackEntity.setValue(item.year, forKey: "year")

                       do {
                           try context.save()
                       } catch {
                           print("Info wasn't saved. \(error), \(error.localizedDescription)")
                       }
                   }
               }

               self.tableView.reloadData()
           }
       }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTable(_:)),
                                               name: NSNotification.Name("updateTable"),
                                               object: nil)

        _ = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in // timer in
            NotificationCenter.default.post(name: NSNotification.Name("updateTable"), object: nil)
        }
    }

    @objc func updateTable(_ notification: Notification) {
        myTracks.append(Track(title: "Unknown", artist: "Unknown Artist", album: "Unknown Album",
                              songId: "\(myTracks.count)", genre: "ska", duration: 40, year: 2010, albumCover: nil))
        tracks = myTracks
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as? TrackTableViewCell
        cell?.parent = self
        cell?.dummyPlayButton()
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
        self.performSegue(withIdentifier: "toAudioPlayerVC", sender: myTableViewCell)
    }
}

extension TracksTableViewController: PlayButtonDelegate {
    func playButtonTouched(indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as? TrackTableViewCell
        cell?.parent = self
        cell?.dummyPlayButton()
    }
}
