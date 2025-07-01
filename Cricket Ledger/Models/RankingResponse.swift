//
//  CricketRankingResponse.swift
//  Cricket Ledger
//
//  Created by Sai Voruganti on 6/5/25.
//
import Foundation

struct RankingResponse: Decodable {
    let response: RankResponse
}

struct RankResponse: Decodable {
    let ranks: PlayerRanks?
}


struct PlayerRanks: Decodable {
    let batsmen: FormatRanks
    let bowlers: FormatRanks
    let allRounders: FormatRanks?
    

    enum CodingKeys: String, CodingKey {
        case batsmen
        case bowlers
        case allRounders = "all-rounders"
    }
}

struct FormatRanks: Decodable {
    let odis: [Player]?
    let tests: [Player]?
    let t20s: [Player]?
}


struct Player: Decodable, Identifiable, Equatable{
    var id: String { pid }
    let rank: String
    let pid: String
    let player: String
    let team: String
    let rating: String
    let image_url: String?
    var image: URL? { image_url.flatMap(URL.init) }

    enum CodingKeys: String, CodingKey {
        case rank, pid, player, team, rating
        case image_url
    }
}

struct decodePlayer: Decodable, Identifiable, Equatable {
    var id: String { pid }
    let rank: String
    let pid: String
    let player: String
    let team: String
    let rating: String
    let image_url: String?
    var image: URL? { image_url.flatMap(URL.init) }

    enum CodingKeys: String, CodingKey {
        case rank, player, team, rating, image_url
        case pid = "id"  
    }
}


struct TestChampionshipRanking: Decodable {
    let rank: String
    let pid: String
    let player: String
    let team: String
    let rating: String
    let image_url: URL?
}
