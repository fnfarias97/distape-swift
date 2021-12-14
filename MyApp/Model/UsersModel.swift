//
//  Model.swift
//  MyApp
//
//  Created by Fernando Farias on 29/10/2021.
//

import Foundation

struct Account {
    let user: String
    let pass: String
}

struct Users {
    let user1: Account = Account(user: "john@doe.com", pass: "password123")
    let user2: Account = Account(user: "fernando@bedu.org", pass: "mypassword123")
    let user3: Account = Account(user: "myUsername", pass: "asdasd12345")
}

struct GenericUserResponseModel: Codable {
    var meta: MetaModel?
    var data: [UserModel]?

    enum CodingKeys: String, CodingKey {
        case meta
        case data
    }
}

struct UserModel: Codable {
    var id: Int?
    var name: String?
    var email: String?
    var gender: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case gender
        case status
    }
}

struct MetaModel: Codable {
    var pagination: PaginationModel?

    enum CodingKeys: String, CodingKey {
        case pagination
    }
}

struct PaginationModel: Codable {
    var total: Int?
    var pages: Int?
    var page: Int?
    var limit: Int?
    var links: LinkModel?

    enum CodingKeys: String, CodingKey {
        case total
        case pages
        case page
        case limit
        case links
    }
}

struct LinkModel: Codable {
    var previous: String?
    var current: String?
    var next: String?

    enum CodingKeys: String, CodingKey {
        case previous
        case current
        case next
    }
}

struct CreateUserRequestModel: Codable {
    var name: String?
    var email: String?
    var gender: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case gender
        case status
    }
}

struct CreateUserResponseModel: Codable {
    var meta: MetaModel?
    var data: UserModel?

    enum CodingKeys: String, CodingKey {
        case meta
        case data
    }
}
