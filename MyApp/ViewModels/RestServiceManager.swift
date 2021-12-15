//
//  File.swift
//  MyApp
//
//  Created by Fernando Farias on 11/12/2021.
//

import Foundation
import Alamofire

class RestServiceManager {
    // let baseURL = "https://gorest.co.in/public/v1/" // "https://my-json-server.typicode.com/oguzman/music_server/"
    let baseURL = "https://raw.githubusercontent.com/beduExpert/Swift-Proyecto/main/API/db.json"
    // let apiKey = "d5ec48ffb10ee60967c2003e84abb7d7638605328e3e2ba9f9810d568fbfab44"

    static let shared = RestServiceManager()

    func getInfo<T: Decodable, U: Encodable>(responseType: T.Type,
                                             method: HTTPMethod,
                                             endpoint: String,
                                             body: U?,
                                             completionHandler: @escaping (_ status: Bool, _ data: T?) -> Void) {
        // stop cache saving
        Alamofire.Session.default.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        do {
            // var request = URLRequest(url: URL(string: "\(self.baseURL)\(endpoint)")!)
            var request = URLRequest(url: URL(string: "\(self.baseURL)")!)
            request.httpMethod = method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

            switch method {
            case .post:
                let jsonData = try JSONEncoder().encode(body)
                request.httpBody = jsonData
            default:
                break
            }

            AF.request(request)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let value):
                        do {
                            let data = try JSONDecoder().decode(T.self, from: value)
                            completionHandler(true, data)
                        } catch {
                            print(error)
                            completionHandler(false, nil)
                        }
                    case .failure(let error):
                        print(error)
                        completionHandler(false, nil)
                    }
                }
        } catch {
            print(error)
            completionHandler(false, nil)
        }

    }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
