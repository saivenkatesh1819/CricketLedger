//////
//////  RankingListView.swift
//////  Cricket Ledger
//////
//////  Created by Sai Voruganti on 6/5/25.
//////

import SwiftUI

struct RankingListView: View {
    let players: [Player]
    let title: String
    var onPlayerTap: ((Player) -> Void)? = nil

    @State private var showAlert = false
    @State private var selectedPlayerName = ""

    var body: some View {
        List(players) { player in
            HStack {
                AsyncImage(url: player.image) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text("\(player.rank). \(player.player)").bold()
                    Text("\(player.team) • Rating: \(player.rating)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {
                    selectedPlayerName = player.player
                    showAlert = true
                    onPlayerTap?(player)
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .navigationTitle(title)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Player Selected"),
                message: Text("\(selectedPlayerName) added to Favorites."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

