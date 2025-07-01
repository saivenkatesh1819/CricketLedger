//////
//////  FavouriteView.swift
//////  Cricket Ledger
//////
//////  Created by Sai Voruganti on 6/13/25.
//////
////


import SwiftUI

struct SelectPlayers: View {
    @ObservedObject var selectPlayersVM: SelectPlayersViewModel

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(
                        selectPlayersVM.selectPlayers.isEmpty ?
                        selectPlayersVM.fetchPlayersAsPlayers :
                            selectPlayersVM.selectPlayers
                    ) { player in
                        HStack{
                            AsyncImage(url: player.image) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text("\(player.rank). \(player.player)")
                                    .bold()
                                Text("\(player.team) • Rating: \(player.rating)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

                Button(action: {
                    selectPlayersVM.saveSelectedPlayers()
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding([.horizontal, .bottom])
                }
            }
            .navigationTitle("My Team")
            .alert("Players saved successfully!", isPresented: $selectPlayersVM.showSaveSuccessAlert) {
                Button("OK", role: .cancel) { }
            }
            .alert("Failed to save players.", isPresented: $selectPlayersVM.showSaveFailureAlert) {
                Button("OK", role: .cancel) { }
            }
        }
        .onAppear {
            print("SelectPlayers View appeared")
            selectPlayersVM.fetchSelectedPlayers()
        }
    }
}
