//
//  Message.swift
//  App
//
//  Created by dsanchezpc on 13/11/18.
//

import Foundation
import Vapor

struct Message: Content {
    var id: UUID?
    var username: String
    var content: String
    var date: Date
}
