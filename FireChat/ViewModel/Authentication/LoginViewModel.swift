//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Magno Miranda Dantas on 17/06/21.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?

    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
}
