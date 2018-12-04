//
//  File.swift
//  App
//
//  Created by dsanchezpc on 03/12/18.
//

import Foundation
import Vapor
import Fluent
import Authentication


class TodoController: RouteCollection {
    func boot(router: Router) throws {
       let group = router.grouped("api", "todos")
        group.get(use: getTodosHandler)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCrypt)
        let guardAuthMiddleware = User.guardAuthMiddleware()
        let basicAuthGroup = group.grouped([basicAuthMiddleware, guardAuthMiddleware])
        basicAuthGroup.post(use: createTodoHandler)
        basicAuthGroup.delete(Message.parameter, use: deleteTodoHandler)
    }
}

private extension TodoController {
    
    func getTodosHandler(_ request: Request) throws -> Future<[Message]> {
        return Message.query(on: request).all()
    }
    
    func createTodoHandler(_ request: Request) throws -> Future<Message> {
        return try request.content.decode(Message.self).flatMap({ (todo) in
            return todo.save(on: request)
        })
    }
    
    func deleteTodoHandler(_ request: Request) throws -> Future<HTTPStatus> {
        return try request.parameters.next(Message.self).flatMap({ (message) in
            return message.delete(on: request)
        }).transform(to: .ok)
    }
    
}
