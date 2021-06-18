//
//  RegisterViewModel.swift
//  FireChat
//
//  Created by Magno Miranda Dantas on 17/06/21.
//

import UIKit

struct RegisterViewModel: AuthenticationProtocol {
    var email: String?
    var fullname: String?
    var username: String?
    var password: String?
    var profileImage: UIImage?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && fullname?.isEmpty == false
            && username?.isEmpty == false && password?.isEmpty == false
            && profileImage != nil
    }
}
