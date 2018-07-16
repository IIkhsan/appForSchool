//
//  Lesson.swift
//  AppForSchool
//
//  Created by Ilyas on 16.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import Foundation

struct Lesson : Codable {
    let id : Int
    let name : String
    let start_time : String
    let end_time : String
    let user_id : Int
    let created_at : String
    let updated_at : String
    let school_id : Int
}
