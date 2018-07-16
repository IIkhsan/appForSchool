//
//  Date.swift
//  Evo
//
//  Created by Ленар Гилязов on 09.01.18.
//  Copyright © 2018 Evo. All rights reserved.
//

import Foundation

extension Date {
    
    func getDateString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd.MM.yyyy"
        return dateFormatterGet.string(from: self)
    }
    
    func getDayOfWeek() -> String {
        let weekdays = [
            "Воскресенье",
            "Понедельник",
            "Вторник",
            "Среда",
            "Четверг",
            "Пятница",
            "Суббота"
        ]
        let myCalendar = Calendar(identifier: .gregorian)
        let myComponents = myCalendar.component(.weekday, from: self)
        let weekDay = myComponents
        return weekdays[weekDay - 1]
    }
    
    static func getDateFromMonth(number: Int) -> Date {
        let month = [
            "январь",
            "февраль",
            "март",
            "апрель",
            "май",
            "июнь",
            "июль",
            "август",
            "сентябрь",
            "октябрь",
            "ноябрь",
            "декабрь"
        ]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.date(from: month[number])!
    }
    
    static func getDateFrom(time: String) -> Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm"
        return dateFormatterGet.date(from: time)!
    }
    
    static func getDateFrom(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let date = dateFormatter.date(from: string)
        return date ?? Date()
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: self)
        return nameOfMonth
    }
    
    func getDateWithTime() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatterGet.string(from: self)
    }
    
    func getTimeString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm"
        return dateFormatterGet.string(from: self)
    }
    
    func getDateWithOutYear() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd MMMM"
        return dateFormatterGet.string(from: self)
    }
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year > 0 && year < 5 ? "\(year)" + " " + (year == 1 ? "год" : "года") :
                "\(year)" + " " + "лет"
        } else if let month = interval.month, month > 0 {
            return month > 1 && month < 5 ? "\(month)" + " " + "мес." :
                "\(month)" + " " + "мес."
        } else if let day = interval.day, day > 0 {
            return day > 1 && day < 5 ? "\(day)" + " " + (day == 1 ? "день" : "дня") :
                "\(day)" + " " + "дней"
        } else if let hour = interval.hour, hour > 0{
            return hour > 1 && hour < 5 ? "\(hour)" + " " + "час." :
                "\(hour)" + " " + "час."
        } else if let minute = interval.minute, minute > 0{
            return minute == 1 ? "\(minute)" + " " + "мин." :
                "\(minute)" + " " + "мин."
        } else{
            return "1 сек."
        }
        
    }
}
