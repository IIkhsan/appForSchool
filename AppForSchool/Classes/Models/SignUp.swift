//
//  SignUp.swift
//  SchoolApp
//
//  Created by Ilyas on 13.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import Foundation

struct SignUp : Codable {
    let email: String
    let password: String
    let first_name: String
    let last_name: String
    let user_type: String
}
