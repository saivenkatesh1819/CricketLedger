////
////  UserRepository.swift
////  Cricket Ledger
////
////  Created by Sai Voruganti on 6/4/25.
////
//


import CoreData
import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserRepository {
    static let shared = UserRepository()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Core Data Methods

    func registerUser(name: String, email: String, password: String) -> Bool {
        let user = Test(context: context)
        user.name = name
        user.email = email
        user.password = password

        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }

    func validateUser(email: String, password: String) -> Bool {
        let request: NSFetchRequest<Test> = Test.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)

        do {
            let users = try context.fetch(request)
            return !users.isEmpty
        } catch {
            return false
        }
    }

    // MARK: - Firebase Player Methods

    private var dbRef: DatabaseReference {
        Database.database().reference()
    }

    func saveSelectedPlayers(players: [Player], completion: @escaping (Error?) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }

        let playersData = players.map { player in
            return [
                "id": player.pid,
                "player": player.player,
                "team": player.team,
                "rank": player.rank,
                "rating": player.rating,
                "image_url": player.image_url ?? ""
            ] as [String: Any]
        }

        dbRef.child("users").child(userID).child("selectedPlayers").setValue(playersData) { error, _ in
            completion(error)
        }
    }

    func fetchSelectedPlayers(completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        dbRef.child("users").child(userID).child("selectedPlayers").observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [[String: Any]] {
                completion(.success(data))
            } else if let dict = snapshot.value as? [String: [String: Any]] {
                completion(.success(Array(dict.values)))
            } else {
                completion(.failure(NSError(domain: "Parse", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])))
            }
        }
    }
}
