//
//  APIManager.swift
//  MyApp
//
//  Created by Fernando Farias on 18/11/2021.
//

import Foundation
import SystemConfiguration

class APIManager {
    let baseURL = "https://raw.githubusercontent.com/beduExpert/Swift-Proyecto/main/API/db.json"

    static let shared = APIManager()
    // static let getMusicEndpoint = "songs/"

    func getMusic(completion: @escaping ([Track]?, Error?) -> Void) {
        let url: String = baseURL
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
        // let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                            print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
                  }
            if error != nil {
                completion(nil, error!)
                myTracks = []
            } else {
                if let data = data {
                    do {
                        guard let dict = try JSONSerialization.jsonObject(with: data,
                        // swiftlint:disable:next line_length
                                                                        options: .allowFragments) as? [String: Any] else {
                            return
                        }

                        guard let songs = dict["songs"] as? [[String: Any]] else {return}
                        let songsData = try JSONSerialization.data(withJSONObject: songs, options: .fragmentsAllowed)
                        let result = try JSONDecoder().decode([Track].self, from: songsData)
                        myTracks = result
                        print("todo bien")
                        completion(result, nil)
                    } catch {
                        print(String(describing: error))
                    }
                }
            }
        })
        task.resume()
    }

    func checkConnectivity() -> Bool {
        var zeroAdress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0),
                                     sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAdress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAdress))
        zeroAdress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAdress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let connectedToInternet = (isReachable && !needsConnection)

        return connectedToInternet
    }
}
