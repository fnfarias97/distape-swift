//
//  LoginViewModel.swift
//  MyApp
//
//  Created by Fernando Farias on 06/12/2021.
//

import Foundation

class UserViewModel {
    static func registerValidation(_ username: String) -> (Int, String) {
        if username == "" {
            print(statusCodes[1] ?? "")
            return (1, statusCodes[1]!)
        } else if username.count < 10 {
            print(statusCodes[2] ?? "")
            return (2, statusCodes[2]!)
        }

        let mirror = Mirror(reflecting: Users())
        for child in mirror.children {
            let myUser = child.value as? Account
            if username == myUser?.user {
                print(statusCodes[6] ?? "")
                return (6, statusCodes[6]!)
            }
        }
        print("User \(username) registered")
        return (0, statusCodes[0]!)
    }

    static func loginValidation(_ username: String, _ password: String) -> (Int, String) {
        if username == "" {
            print(statusCodes[1] ?? "")
            return (1, statusCodes[1]!)
        } else if username.count < 10 {
            print(statusCodes[2] ?? "")
            return (2, statusCodes[2]!)
        } else if password == "" {
            print(statusCodes[3] ?? "")
            return (3, statusCodes[3]!)
        } else if password.count < 10 {
            print(statusCodes[4] ?? "")
            return (4, statusCodes[4]!)
        }

        let mirror = Mirror(reflecting: Users())
        for child in mirror.children {
            let myUser = child.value as? Account
            if username == myUser?.user && password == myUser?.pass {
                let userText: String = username.isValidEmail() ? "email" : "user"
                print("\(userText): \(username) pass: \(password)")
                return (0, statusCodes[0]!)
            }
        }
        print(statusCodes[5] ?? "")
        return (5, statusCodes[5]!)
    }
}

let statusCodes: [Int: String] = [0: "OK",
                                 1: "Username cannot be empty",
                                 2: "Username must have at least 10 characters",
                                 3: "Password cannot be empty",
                                 4: "Password must have at least 10 characters",
                                 5: "Username or password don't match",
                                 6: "User or email already exists"
]
