//
//  FetchDate.swift
//  DollarRate
//
//  Created by Кирилл Тила on 24.06.2021.
//

import Foundation

class FetchDate {
    private var curretnTime = Date()
    private var formatter = DateFormatter()
    
    static let shared = FetchDate()
    
    func currentDate() -> String {
        setFormatter()
        return formatter.string(from: curretnTime)
    }
    
    func dateOfBeginning() -> String {
        setFormatter()
        return formatter.string(from: curretnTime - (60*60*24) * 30)
    }
    
    private func setFormatter(){
        formatter.dateFormat = "dd/MM/YYYY"
        formatter.timeZone = TimeZone.current
    }
}

