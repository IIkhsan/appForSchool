//
//  User.swift
//  AppForSchool
//
//  Created by Ilyas on 17.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import Foundation

struct User : Codable {
    let id : Int
    let first_name : String
    let last_name : String
    let patronymic : String
    let user_type : String
    let school_id : Int
}
