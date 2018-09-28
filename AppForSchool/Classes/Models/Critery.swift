//
//  Critery.swift
//  AppForSchool
//
//  Created by Ilyas on 18.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import Foundation

struct Critery : Codable {
    let id : Int
    let name : String
    let lesson_id : Int
    let created_at : String
    let updated_at : String
}

struct ResponseCritery : Codable {
    let id : Int
    let criterion_id : Int
    let user_id : Int
    let lesson_id : Int
    let mark : Int
    let created_at : String
    let updated_at : String
}
