//
//  User.swift
//  App
//
//  Created by dsanchezpc on 03/12/18.
//

import Foundation
import Vapor
import FluentSQLite
import Authentication

struct User: Content, SQLiteUUIDModel, Migration {
    var id: UUID?
    private(set) var email: String
    private(set) var password: String
}

extension User: BasicAuthenticatable {
    static let usernameKey: WritableKeyPath<User, String> = \.email
    static let passwordKey: WritableKeyPath<User, String> = \.password
}
