//
//  MovieDetailViewController.swift
//  BambooTV
//
//
//  Created by Yoan Tarrillo

import UIKit
import AVKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var producedBy: UILabel!
    
    // MARK: - Private vars
    private let moviesManager: MoviesManager = MoviesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetails()
    }
    
    private func fetchMovieDetails() {
        guard let selectedMovieId = MoviesViewModel.selectedMovieId else { return }
        moviesManager.fetchMovieDetails(movieId: selectedMovieId) { infoDescargadaAPI in
            self.configureView(movieDetails: infoDescargadaAPI)
        }
    }
    
    private func configureView(movieDetails: MovieDetails) {
        movieTitle.text = movieDetails.title
        popularityLabel.text = "Popularidad: \(Int(movieDetails.popularity))"
        yearLabel.text = movieDetails.releaseDate
        votesLabel.text = " \(movieDetails.voteAverage) "
        budgetLabel.text = "\(movieDetails.formattedBudget)M$"
        overviewLabel.text = movieDetails.overview
        genresLabel.text = "Géneros: " + movieDetails.genres.map{$0.name}.joined(separator: ", ")
        producedBy.text = "Producida por: " + movieDetails.productionCompanies.map{$0.name}.joined(separator: ", ")
        
        if let videoURL = movieDetails.videoURL {
            configurePlayer(videoURL: videoURL)
        } else {
            debugPrint("Error: video URL invalid in \(#function)")
        }
        
    }
    
    private func configurePlayerOnlyAVPlayer(movieDetails: MovieDetails) {
        guard let videoURL = movieDetails.videoURL else {
            debugPrint("Error: video URL invalid in \(#function)")
            return
        }
        
        // Solución #1: usando solo AVPlayer
        // El usuario no podrá interactuar con el vídeo
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoContainer.bounds
        videoContainer.layer.addSublayer(playerLayer)
        player.play()
    }
    
    private func configurePlayer(videoURL: URL) {
        // Solución #2: usando AVPlayerViewController
        // Muestra los controles típicos de un vídeo (play, pause, pantalla completa, etc.)
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        guard let playerView = playerViewController.view else {
            debugPrint("Error: player view is nil")
            return
        }
        self.addChild(playerViewController)
        videoContainer.addSubview(playerView)
        playerViewController.didMove(toParent: self)

        playerView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: playerView, attribute: .top, relatedBy: .equal, toItem: videoContainer, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: playerView, attribute: .bottom, relatedBy: .equal, toItem: videoContainer, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: playerView, attribute: .leading, relatedBy: .equal, toItem: videoContainer, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: playerView, attribute: .trailing, relatedBy: .equal, toItem: videoContainer, attribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])

        player.play()
    }
}
