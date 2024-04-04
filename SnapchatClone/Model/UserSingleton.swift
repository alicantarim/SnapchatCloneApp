//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Alican TARIM on 1.04.2024.
//

import Foundation

// Singleton -> Bir sınıf ama bu sınıfın içerisinde sadece tek bir obje oluşturulabiliyor.

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init() {
        
    }
    
}
