//
//  APIServices.swift
//  SchoolApp
//
//  Created by Ilyas on 11.07.2018.
//  Copyright © 2018 itis. All rights reserved.
//

import Foundation

class APIServices : Repository {
    private let url = "https://kpfu-school-api.herokuapp.com"
    private let token : String! = UserDefaults.standard.string(forKey: "token")
    private let uid : Int! = UserDefaults.standard.integer(forKey: "uid")
    private func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    func logout(completition: @escaping(_ status: Bool, Error?)->()) {
        let urlString = "\(url)/api/v1/logout"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(false, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(false, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(false, error!)
                        return
                    }
                    completition(true, nil)
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(false, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func signIn(email: String, password: String, completition: @escaping(_ token: Token?, Error?) -> ()) {
        let urlString = "\(url)/api/v1/login"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let postString = self.getPostString(params: ["email" : email, "password" : password])
        urlRequest.httpBody = postString.data(using: .utf8)
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let token = try decoder.decode(Token.self, from: responseData)
                        completition(token, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String, userType: String, patronymic: String?, schoolId: Int, completition: @escaping(_ token: Token?, Error?) -> ()) {
        
        let urlString = "\(url)/api/v1/signup"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let postString = self.getPostString(params: ["email" : email,"password" : password, "first_name" : firstName, "last_name" : lastName, "user_type" : userType, "patronymic" : patronymic ?? "otsosin", "school_id" : schoolId])
        urlRequest.httpBody = postString.data(using: .utf8)
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let token = try decoder.decode(Token.self, from: responseData)
                        print(token.token)
                        completition(token, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
                
                
                
            }
        }
        task.resume()
    }
    
    func getAllSchools(completition: @escaping(_ schools: [School]?,  Error?) -> ()) {
        let urlString = "\(url)/api/v1/school"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let schools = try decoder.decode([School].self, from: responseData)
                        print(schools[0].name)
                        completition(schools, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func getSchool(schoolID: Int, completition: @escaping(_ schools: School?,  Error?) -> ()) {
        let urlString = "\(url)/api/v1/school/\(schoolID)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let school = try decoder.decode(School.self, from: responseData)
                        print(school.name)
                        completition(school, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func getAllLessons(schoolID: Int?, completition: @escaping(_ schools: [Lesson]?,  Error?) -> ()) {
        var urlString = "\(url)/api/v1/lesson"
        
        if let id = schoolID {
            urlString = urlString + "?school_id=\(id)"
        }
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let lessons = try decoder.decode([Lesson].self, from: responseData)
                        completition(lessons, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func createCriterios(criterionID: Int?, lessonID: Int? , name: String, completition: @escaping(_ response: Lesson?, Error?) -> ()) {
        
        var urlString : String
        var httpMethod : String
        if let id = criterionID {
            urlString = "\(url)/api/v1/criterion/\(id)"
            httpMethod = "PUT"
        } else {
            urlString = "\(url)/api/v1/criterion"
            httpMethod = "POST"
        }
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        let postString = self.getPostString(params: [ "name" : name, "lesson_id" : lessonID!])
        urlRequest.httpBody = postString.data(using: .utf8)
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let lesson = try decoder.decode(Lesson.self, from: responseData)
                        completition(lesson, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func getAllCriteries(lessonID: Int, completition: @escaping(_ schools: [Critery]?,  Error?) -> ()) {
        let urlString = "\(url)/api/v1/criterion?lesson_id=\(lessonID)"
    
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let criterys = try decoder.decode([Critery].self, from: responseData)
                        completition(criterys, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func getUsers(completition: @escaping(_ user: [User]?,  Error?) -> ()) {
        let urlString = "\(url)/api/v1/user/"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let users = try decoder.decode([User].self, from: responseData)
                        completition(users, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    
    func getUser(completition: @escaping(_ user: User?,  Error?) -> ()) {
        let urlString = "\(url)/api/v1/user/\(uid!)"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let user = try decoder.decode(User.self, from: responseData)
                        print(user.first_name)
                        completition(user, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
//    func getUser(completition: @escaping(_ user: [User]?,  Error?) -> ()) {
//        let urlString = "\(url)/api/v1/user/"
//
//        guard let url = URL(string: urlString) else {
//            print("Error: cannot create URL")
//            let error = BackendError.urlError(reason: "Could not construct URL")
//            completition(nil, error)
//            return
//        }
//
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//        urlRequest.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
//
//        //Make request
//        let session = URLSession.shared
//
//        let task = session.dataTask(with: urlRequest) { (data, response, error) in
//            DispatchQueue.main.async {
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    let error = BackendError.statusError(reason: "Status get error")
//                    completition(nil, error)
//                    return
//                }
//                switch httpResponse.statusCode {
//                case 200:
//                    guard error == nil else {
//                        completition(nil, error!)
//                        return
//                    }
//                    guard let responseData = data else {
//                        let error = BackendError.objectSerialization(reason: "No data in response")
//                        completition(nil, error)
//                        return
//                    }
//
//                    let decoder = JSONDecoder()
//                    do {
//                        let user = try decoder.decode([User].self, from: responseData)
//                        completition(user, nil)
//                    } catch let error {
//                        completition(nil, error)
//                        print("Fail to decode with error: ", error)
//                    }
//                default:
//                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
//                    completition(nil, error)
//                    break
//                }
//            }
//        }
//        task.resume()
//    }
    
    func sendCriteryInfo(criterionID: Int, lessonID: Int, userID: Int, mark: Int,  completition: @escaping(_ response: ResponseCritery?, Error?) -> ()) {
        
        let urlString = "\(url)/api/v1/rating"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        let postString = self.getPostString(params: ["criterion_id" : criterionID, "lesson_id" : lessonID, "user_id" : userID, "mark" : mark ])
        urlRequest.httpBody = postString.data(using: .utf8)
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let token = try decoder.decode(ResponseCritery.self, from: responseData)
                        completition(token, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func createSchool(schoolID: Int?, name: String, completition: @escaping(_ response: School?, Error?) -> ()) {
        
        var urlString : String
        var httpMethod : String
        if let id = schoolID {
            urlString = "\(url)/api/v1/school/\(id)"
            httpMethod = "PUT"
        } else {
            urlString = "\(url)/api/v1/school"
            httpMethod = "POST"
        }
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        let postString = self.getPostString(params: [ "name" : name ])
        urlRequest.httpBody = postString.data(using: .utf8)
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let school = try decoder.decode(School.self, from: responseData)
                        completition(school, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func deleteSchool(schoolID: Int, completition: @escaping(_ response: Bool?, Error?) -> ()) {
        
        let urlString : String = "\(url)/api/v1/school/\(schoolID)"
        let httpMethod : String = "DELETE"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")

        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    completition(true, nil)
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    
    func createLeson(_ lessonID: Int? = nil, name: String, startTime: String, endTime: String, schoolID: Int, teacherID: Int, completition: @escaping(_ response: Lesson?, Error?) -> ()) {
        
        var urlString : String
        var httpMethod : String
        if let id = lessonID {
            urlString = "\(url)/api/v1/lesson/\(id)"
            httpMethod = "PUT"
        } else {
            urlString = "\(url)/api/v1/lesson"
            httpMethod = "POST"
        }
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        let postString = self.getPostString(params: [ "name" : name, "start_time" : startTime, "end_time" : endTime, "school_id" : schoolID, "user_id" : teacherID])
        urlRequest.httpBody = postString.data(using: .utf8)
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    guard error == nil else {
                        completition(nil, error!)
                        return
                    }
                    guard let responseData = data else {
                        let error = BackendError.objectSerialization(reason: "No data in response")
                        completition(nil, error)
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    do {
                        let lesson = try decoder.decode(Lesson.self, from: responseData)
                        completition(lesson, nil)
                    } catch let error {
                        completition(nil, error)
                        print("Fail to decode with error: ", error)
                    }
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func deleteLesson(lessonID: Int, completition: @escaping(_ response: Bool?, Error?) -> ()) {
        
        let urlString : String = "\(url)/api/v1/school/\(lessonID)"
        let httpMethod : String = "DELETE"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    completition(true, nil)
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    
    
    func deleteCritery(lessonID: Int, completition: @escaping(_ response: Bool?, Error?) -> ()) {
        
        let urlString : String = "\(url)/api/v1/criterion/\(lessonID)"
        let httpMethod : String = "DELETE"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    completition(true, nil)
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
    
    func deleteRaiting(ratingID: Int, completition: @escaping(_ response: Bool?, Error?) -> ()) {
        
        let urlString : String = "\(url)/api/v1/rating/\(ratingID)"
        let httpMethod : String = "DELETE"
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            completition(nil, error)
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        urlRequest.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        //Make request
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = BackendError.statusError(reason: "Status get error")
                    completition(nil, error)
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    completition(true, nil)
                default:
                    let error = BackendError.statusError(reason: "Http response status: \(httpResponse.statusCode)")
                    completition(nil, error)
                    break
                }
            }
        }
        task.resume()
    }
}


enum BackendError : Error {
    case urlError(reason: String)
    case objectSerialization(reason: String)
    case statusError(reason: String)
}

