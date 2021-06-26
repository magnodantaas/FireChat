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
        COLLECTION_USERS.getDocuments { snapshot, error in
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
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapchot, error in
            guard let dictionary = snapchot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(currentId).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { snapchot, error in
            snapchot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    let message = Message(dictionary: dictionary)
                    self.fetchUser(withUid: message.toId) { user in
                        let conversation = Conversation(user: user, message: message)
                        conversations.append(conversation)
                        completion(conversations)
                    }
                }
            })
        }
        
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(currentId).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapchot, error in
            snapchot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        
        let data = [
            "text": message,
            "fromId": currentId,
            "toId": user.uid,
            "timestamp": Timestamp(date: Date())
        ] as [String : Any]
        
        COLLECTION_MESSAGES.document(currentId).collection(user.uid).addDocument(data: data) { _ in
            COLLECTION_MESSAGES.document(user.uid).collection(currentId).addDocument(data: data, completion: completion)
            
            COLLECTION_MESSAGES.document(currentId).collection("recent-messages").document(user.uid).setData(data)
            
            COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentId).setData(data)
        }
    }
}
