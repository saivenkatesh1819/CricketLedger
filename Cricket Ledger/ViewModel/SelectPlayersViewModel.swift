////
////  FavoritesViewModel.swift
////  Cricket Ledger
////
////  Created by Sai Voruganti on 6/13/25.
////
//

import Foundation

class SelectPlayersViewModel: ObservableObject {
    @Published var selectPlayers: [Player] = []
    @Published var fetchPlayers: [decodePlayer] = []
    @Published var showSaveSuccessAlert = false
    @Published var showSaveFailureAlert = false

    

    func selectPlayer(_ player: Player) {
        if !selectPlayers.contains(where: { $0.id == player.id }) {
            selectPlayers.append(player)
        }
    }

    func saveSelectedPlayers() {
        UserRepository.shared.saveSelectedPlayers(players: selectPlayers) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to save players: \(error.localizedDescription)")
                    self.showSaveFailureAlert = true
                } else {
                    print("Players saved successfully")
                    self.showSaveSuccessAlert = true
                }
            }
        }
    }


    func fetchSelectedPlayers() {
        UserRepository.shared.fetchSelectedPlayers { result in
            switch result {
            case .success(let rawData):
                self.decodePlayers(from: rawData)
            case .failure(let error):
                print("Error fetching players: \(error.localizedDescription)")
            }
        }
    }

    private func decodePlayers(from rawData: [[String: Any]]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: rawData)
            let decoded = try JSONDecoder().decode([decodePlayer].self, from: jsonData)
            DispatchQueue.main.async {
                self.fetchPlayers = decoded
                print("Loaded players: \(decoded.map { $0.player })")
            }
        } catch {
            print("Decoding failed: \(error)")
        }
    }

    var fetchPlayersAsPlayers: [Player] {
        fetchPlayers.map {
            Player(
                rank: $0.rank,
                pid: $0.pid,
                player: $0.player,
                team: $0.team,
                rating: $0.rating,
                image_url: $0.image_url
            )
        }
    }
}
