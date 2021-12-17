//
//  DownloadManager.swift
//  MyApp
//
//  Created by Fernando Farias on 09/12/2021.
//

import Foundation

class DownloadManager: NSObject, ObservableObject {
    static var shared = DownloadManager()

    private var urlSession: URLSession!
    @Published var tasks: [URLSessionTask] = []

    override private init() {
        super.init()
        print("hasdi")
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")

        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())

        updateTasks()

    }

    func startDownload(url: URL) {
        print("Downloading")
        let task = urlSession.downloadTask(with: url)
        task.resume()
        tasks.append(task)
    }

    private func updateTasks() {
        urlSession.getAllTasks { tasks in
            DispatchQueue.main.async {
                self.tasks = tasks
            }
        }
    }
}

extension DownloadManager: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didWriteData _: Int64,
                    totalBytesWritten _: Int64, totalBytesExpectedToWrite _: Int64) {
        print("Progress \(downloadTask.progress.fractionCompleted)")
    }

    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download finished: \(location.absoluteString) - for - \(downloadTask)")
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download error: \(String(describing: error))")
        } else {
            print("Task finished: \(task)")
        }
    }
}
