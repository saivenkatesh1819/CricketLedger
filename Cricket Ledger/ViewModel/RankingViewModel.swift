//
//  CricketRankingViewModel.swift
//  Cricket Ledger
//
//  Created by Sai Voruganti on 6/5/25.
//

import Foundation
import NetworkLayer

class RankingViewModel: ObservableObject {
    @Published var batsmen: [Player] = []
    @Published var bowlers: [Player] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkManager: Servicable

    init(networkManager: Servicable = NetworkManager()) {
        self.networkManager = networkManager
        fetchRankings()
    }

    func fetchRankings() {
        isLoading = true
        errorMessage = nil
        let request = CricketRankingRequest()
        networkManager.execute(request: request, modelType: RankingResponse.self) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.batsmen = response.response.ranks?.batsmen.odis ?? []
                    self?.bowlers = response.response.ranks?.bowlers.odis ?? []
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
