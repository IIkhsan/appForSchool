//
//  Int.swift
//  Evo
//
//  Created by Ленар Гилязов on 10.01.18.
//  Copyright © 2018 Evo. All rights reserved.
//

import Foundation

extension Int {
    func toString() -> String {
        return String(describing: self)
    }
    
    func getAgeAsString() -> String {
        var age = toString()
        let lastNumber = self % 10
        if lastNumber < 5 && lastNumber > 0 {
            age = age + " года"
        } else {
            age = age + " лет"
        }
        return age
    }
}

extension UInt64 {
    func getDocumentSize() -> String {
        if Double(self)/1024/1024 > 1.0 {
            return "\(self/1024/1024) Мб"
        } else if Double(self)/1024 > 1.0 {
            return "\(self/1024) Кб"
        } else {
            return "\(self/100) Б"
        }
    }
}
