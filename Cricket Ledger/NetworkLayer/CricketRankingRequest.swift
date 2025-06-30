//
//  SearchRequest.swift
//  Airlines
//
//  Created by Sai Voruganti on 5/6/25.
//

import NetworkLayer

struct CricketRankingRequest: Request {
    var baseUrl: String = "https://cricket-live-line-advance.p.rapidapi.com"
    var path: String = "/iccranks"
    var httpMethod: HttpMethod = .get
    var header: [String: String]? = [
        "x-rapidapi-key": "97693c5c7fmsh75b8af4b9022e60p1872a6jsnc113335c4d34",
        "x-rapidapi-host": "cricket-live-line-advance.p.rapidapi.com"
    ]
}

