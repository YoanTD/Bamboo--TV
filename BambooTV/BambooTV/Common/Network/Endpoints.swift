//
//  Endpoints.swift
//  BambooTV
//
//  Created by Yoan Tarrillo

import Foundation

enum Endpoints: String {
    case movieDiscover = "https://api.themoviedb.org/3/discover/movie"
    case movieDetails = "https://api.themoviedb.org/3/movie"
    case movieCoverImage = "https://image.tmdb.org/t/p/w500"
    
    var url: String { self.rawValue }
}

enum EndpointParameter: String {
    case apiKey = "api_key"
}
