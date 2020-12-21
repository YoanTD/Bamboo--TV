//
//  MoviesStackCell.swift
//  BambooTV
//
//  Created by Yoan Tarrillo

import UIKit
import AlamofireImage

protocol MoviesStackCellDelegate {
    func didSelectMovie(movieId: Int)
}

class MoviesStackCell: UITableViewCell {

    @IBOutlet weak var rectangularConstraint: NSLayoutConstraint!
    @IBOutlet weak var squaredConstraint: NSLayoutConstraint!
    @IBOutlet var buttons: [UIButton]!
    
    var delegate: MoviesStackCellDelegate?
    
    var circularCells: Bool = false {
        didSet {
            // We're setting both constraints to false to avoid console messages complaining about conflicting constraints
            squaredConstraint.isActive = false
            rectangularConstraint.isActive = false
            
            squaredConstraint.isActive = circularCells
            rectangularConstraint.isActive = !circularCells
            updateButtonsFormat()
        }
    }
    
    var rowHeight: CGFloat = 0 {
        didSet {
            updateButtonsFormat()
        }
    }
    
    var movies: [Movie] = [] {
        didSet {
            updateCoverImages()
            updateButtonsIds()
        }
    }
    
    private func updateButtonsFormat() {
        for btn in buttons {
            let radius: CGFloat = circularCells ? rowHeight*0.5 : 0
            btn.layer.cornerRadius = radius
            btn.clipsToBounds = true
            btn.imageView?.contentMode = .scaleAspectFill
        }
    }
    
    private func updateCoverImages() {
        buttons.forEach {
            $0.setImage(nil, for: .normal)
            $0.isHidden = true
        }
        
        zip(movies, buttons).forEach { (movie, button) in
            if let posterPath = movie.posterPath {
                let urlToImage = Endpoints.movieCoverImage.url + posterPath
                if let url = URL(string: urlToImage) {
                    button.af.setImage(for: .normal, url: url)
                    button.isHidden = false
                }
            }
        }
    }
    
    private func updateButtonsIds() {
        zip(movies, buttons).forEach { (movie, button) in
            button.tag = movie.id
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didSelectMovie(movieId: sender.tag)
        }
    }
    
}
