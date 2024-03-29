//
//  User.swift
//  44643Sec03Team04Spring2024FinalProject
//
//  Created by Akhila Mylavarapu on 3/29/24.
//

import Foundation

class User {
    var email: String
    var phoneNumber: Int
    var firstName: String
    var lastName: String
    
    init(email: String, phoneNumber: Int, firstName: String, lastName: String) {
        self.email = email
        self.phoneNumber = phoneNumber
        self.firstName = firstName
        self.lastName = lastName
    }
}
