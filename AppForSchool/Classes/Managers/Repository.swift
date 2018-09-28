//
//  Repository.swift
//  AppForSchool
//
//  Created by Ilyas on 22.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import Foundation

protocol Repository {
    
    //MARK: - Get
    func getAllSchools(completition: @escaping(_ schools: [School]?,  Error?) -> ())
    func getAllLessons(schoolID: Int?, completition: @escaping(_ schools: [Lesson]?,  Error?) -> ())
    func getAllCriteries(lessonID: Int, completition: @escaping(_ schools: [Critery]?,  Error?) -> ())
    func getUser(completition: @escaping(_ user: User?,  Error?) -> ())
    
    //MARK: - Sign
    func signIn(email: String, password: String, completition: @escaping(_ token: Token?, Error?) -> ())
    func signUp(email: String, password: String, firstName: String, lastName: String, userType: String, patronymic: String?, schoolId: Int, completition: @escaping(_ token: Token?, Error?) -> ())
    func logout(completition: @escaping(_ status: Bool, Error?)->())
    
    //MARK: - Send to server
    func sendCriteryInfo(criterionID: Int, lessonID: Int, userID: Int, mark: Int,  completition: @escaping(_ response: ResponseCritery?, Error?) -> ())
    func createSchool(schoolID: Int?, name: String, completition: @escaping(_ response: School?, Error?) -> ())
    func deleteSchool(schoolID: Int, completition: @escaping(_ response: Bool?, Error?) -> ())
}
