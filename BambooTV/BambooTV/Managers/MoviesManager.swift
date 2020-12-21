//
//  MoviesManager.swift
//  BambooTV
//
//  Created by Yoan Tarrillo
import Foundation
import Alamofire

struct MoviesManager {
    private let apiKeyValue: String = "d3e5f2e7aa48d158fe52cb91d420410c"
    
    func fetchMovieDiscover(success: @escaping (MoviesList) -> ()) {
        let parameters: [String: String] = [
            EndpointParameter.apiKey.rawValue: apiKeyValue
        ]
        
        AF.request(Endpoints.movieDiscover.url, parameters: parameters).validate().responseDecodable(of: MoviesList.self) { (response) in
            
            guard let moviesList: MoviesList = response.value else {
                debugPrint("Error while calling \(#function)")
                self.printResponse(response)
                return
            }
            
            success(moviesList)
        }
    }
    
    func fetchMovieDetails(movieId: Int,
                           success: @escaping (MovieDetails) -> ()) {
        let parameters: [String: String] = [
            EndpointParameter.apiKey.rawValue: apiKeyValue
        ]
        
        let fullUrl = Endpoints.movieDetails.url + "/" + String(movieId)
        AF.request(fullUrl, parameters: parameters).validate().responseDecodable(of: MovieDetails.self) { (response) in
            
            guard let movieDetails: MovieDetails = response.value else {
                debugPrint("Error while calling \(#function)")
                self.printResponse(response)
                return
            }
            
            success(movieDetails)
        }
    }
    
    private func printResponse<T>(_ response: AFDataResponse<T>) {
        debugPrint("Request: \(String(describing: response.request))")
        debugPrint("Error: \(String(describing: response.error))")
    }
}
