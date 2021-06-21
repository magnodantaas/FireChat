//
//  Service.swift
//  FireChat
//
//  Created by Magno Miranda Dantas on 21/06/21.
//

import Firebase

struct Service {
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Error \(error)")
                return
            }
            snapshot?.documents.forEach({ document in
                
                let dictionary = document.data()
                
                let user = User(dictionary: dictionary)
                
                users.append(user)
                
                completion(users)
            })
        }
    }
}
