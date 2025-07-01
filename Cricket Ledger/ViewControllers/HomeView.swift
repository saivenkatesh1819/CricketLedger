////
////  SwiftUIView.swift
////  Cricket Ledger
////
////  Created by Sai Voruganti on 6/5/25.
////


import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = RankingViewModel()
    @StateObject private var selectPlayersViewModel = SelectPlayersViewModel()
    @State private var searchText = ""
    var coordinator: AppCoordinator

    var filteredBatsmen: [Player] {
        searchText.isEmpty ? viewModel.batsmen : viewModel.batsmen.filter {
            $0.player.localizedCaseInsensitiveContains(searchText)
        }
    }

    var filteredBowlers: [Player] {
        searchText.isEmpty ? viewModel.bowlers : viewModel.bowlers.filter {
            $0.player.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        TabView {
            // Batsmen
            NavigationStack {
                batsmenContent
                    .navigationTitle("Top Batsmen")
                    .navigationBarItems(trailing: Button("Logout") {
                        coordinator.logout()
                    })
                    .searchable(text: $searchText, prompt: "Search Batsmen")
            }
            .tabItem {
                Label("Batsmen", systemImage: "figure.walk")
            }

            // Bowlers
            NavigationStack {
                bowlersContent
                    .navigationTitle("Top Bowlers")
                    .navigationBarItems(trailing: Button("Logout") {
                        coordinator.logout()
                    })
                    .searchable(text: $searchText, prompt: "Search Bowlers")
            }
            .tabItem {
                Label("Bowlers", systemImage: "bolt.fill")
            }

            // Favorites
            NavigationStack {
                SelectPlayers(selectPlayersVM: selectPlayersViewModel)
                    .navigationTitle("Selected Players")
                    .navigationBarItems(trailing: Button("Logout") {
                        coordinator.logout()
                    })
            }
            .tabItem {
                Label("My Team", systemImage: "person.3.fill")
            }

        }
    }

    @ViewBuilder
    private var batsmenContent: some View {
        if viewModel.isLoading {
            ProgressView("Loading...")
        } else if let error = viewModel.errorMessage {
            Text("Error: \(error)")
        } else {
            RankingListView(players: filteredBatsmen, title: "Top Batsmen") { player in
                selectPlayersViewModel.selectPlayer(player)
            }
        }
    }

    @ViewBuilder
    private var bowlersContent: some View {
        if viewModel.isLoading {
            ProgressView("Loading...")
        } else if let error = viewModel.errorMessage {
            Text("Error: \(error)")
        } else {
            RankingListView(players: filteredBowlers, title: "Top Bowlers") { player in
                selectPlayersViewModel.selectPlayer(player)
            }
        }
    }
}
