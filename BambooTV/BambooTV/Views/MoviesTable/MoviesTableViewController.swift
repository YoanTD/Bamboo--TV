//
//  MoviesTableViewController.swift
//  BambooTV
//
//
//  Created by Yoan Tarrillo

import UIKit
import AlamofireImage

class MoviesTableViewController: UITableViewController {
    
    private let reuseIdentifier: String = String(describing: MoviesStackCell.self)
    private let numberOfRows: Int = 1
    private let moviesManager: MoviesManager = MoviesManager()
    
    private var movies: [Movie]?
    
    @IBOutlet weak var avatarButton: UIBarButtonItem!
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: reuseIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        fetchMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureAvatarMiniature()
        manageLoadingView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showProfileSelectionIfNeeded()
    }
    
    @IBAction func avatarTouched(_ sender: Any) {
        goToProfileSelection()
    }
    
    private func showProfileSelectionIfNeeded() {
        if MoviesViewModel.selectedProfile == nil {
            goToProfileSelection()
        }
    }
    
    private func configureAvatarMiniature() {
        if let profile = MoviesViewModel.selectedProfile {
            avatarButton.image = UIImage(named: profile.imageName + "_mini")
        }
    }
    
    private func configureTableHeader() {
        guard let randomMovie: Movie = movies?.randomElement() else { return }
        
        if let backdropPath = randomMovie.backdropPath {
            let urlToImage = Endpoints.movieCoverImage.url + backdropPath
            if let url = URL(string: urlToImage) {
                headerLabel.text = randomMovie.title
                headerButton.af.setImage(for: .normal, url: url)
                headerButton.imageView?.contentMode = .scaleAspectFill
            }
        }
    }
    
    private func fetchMovies() {
        moviesManager.fetchMovieDiscover() { moviesList in
            self.movies = moviesList.results
            self.configureTableHeader()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Loading view
    private func manageLoadingView() {
        
        
        if MoviesViewModel.selectedProfile == nil {
            showLoadingView(true)
        } else {
            showLoadingView(false)
        }
    }
    
    private func showLoadingView(_ showLoading: Bool) {
        tableView.isHidden = showLoading
        navigationController?.navigationBar.isHidden = showLoading
    }
    
    // MARK: - Transitions
    private func goToProfileSelection() {
        performSegue(withIdentifier: "goToProfileSelection", sender: self)
    }
    
    private func goToMovieDetails() {
        performSegue(withIdentifier: "goToMovieDetails", sender: self)
    }
    
}

// MARK: - Info for sections
extension MoviesTableViewController {
    enum SectionType: Int, CaseIterable {
        case mostPopular, recentlyAdded, mostVoted, discover, internationalMovies
        
        var name: String {
            switch self {
            case .mostPopular:
                return "Populares"
            case .recentlyAdded:
                return "Recientes"
            case .mostVoted:
                return "Más votados"
            case .discover:
                return "Películas que te gustarán"
            case .internationalMovies:
                return "Cine internacional"
            }
        }
        
        var rowHeight: CGFloat {
            switch self {
            case .mostPopular:
                return 300.0
            default:
                return 150.0
            }
        }
        
        var isCircular: Bool {
            switch self {
            case .mostVoted:
                return true
            default:
                return false
            }
        }
    }
}

// MARK: - Table view data source
extension MoviesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType: SectionType = SectionType(rawValue: section) else {
            return "<missing_title>"
        }
        return sectionType.name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let moviesCell = cell as? MoviesStackCell,
            let section: SectionType = SectionType(rawValue: indexPath.section) {
            moviesCell.rowHeight = section.rowHeight
            moviesCell.circularCells = section.isCircular
            moviesCell.movies = moviesForSection(indexPath.section)
            moviesCell.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section: SectionType = SectionType(rawValue: indexPath.section) else {
            return 100
        }
        return section.rowHeight
    }
    
    private func moviesForSection(_ section: Int) -> [Movie] {
        guard let allMovies = self.movies,
            let sectionType: SectionType = SectionType(rawValue: section)
            else { return [] }
        
        switch sectionType {
        case .mostPopular:
            return allMovies.sorted{ $0.popularity > $1.popularity }
        case .recentlyAdded:
            return allMovies.sorted{ $0.releaseDate > $1.releaseDate }
        case .mostVoted:
            return allMovies.sorted{ $0.voteAverage > $1.voteAverage }
        case .discover:
            return allMovies.shuffled()
        case .internationalMovies:
            return allMovies.filter{ $0.originalLanguage != "en" }
        }
    }
}

// MARK: - Table View Delegate
extension MoviesTableViewController: MoviesStackCellDelegate {
    func didSelectMovie(movieId: Int) {
        MoviesViewModel.selectedMovieId = movieId
        goToMovieDetails()
    }
}
