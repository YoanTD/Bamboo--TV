//
//  ProfileSelectionViewController.swift
//  BambooTV
//
//
//  Created by Yoan Tarrillo

import UIKit

class ProfileSelectionViewController: UIViewController {
    
    @IBOutlet weak var readyButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var profileButtons: [UIButton]!
    @IBOutlet var profileLabels: [UILabel]!
    
    
    private let profileManager: ProfileManager = ProfileManager()
    private var currentProfiles: [Profile] = []
    private var isEditModeEnabled: Bool = false {
        didSet {
            if isEditModeEnabled {
                configureViewForEditing()
                ProfileEditionViewModel.resetSelection()
            } else {
                configureViewForSelection()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfileButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureProfileButtons()
        isEditModeEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureProfileButtons()
    }
    
    func configureProfileButtons() {
        resetProfileButtons()
        currentProfiles = profileManager.readProfiles()
        for (index, button) in profileButtons.enumerated() {
            if let profile = currentProfiles.first(where: { $0.id == index }) {
                button.setBackgroundImage(UIImage(named: profile.imageName), for: .normal)
            }
        }
        
        for (index, label) in profileLabels.enumerated() {
            if let profile = currentProfiles.first(where: { $0.id == index }) {
                label.text = profile.name
            }
        }
    }
    
    func resetProfileButtons() {
        let defaultImage = UIImage(systemName: "plus")
        for button in profileButtons {
            button.setBackgroundImage(defaultImage, for: .normal)
        }
        
        for label in profileLabels {
            label.text = "Añadir"
        }
    }
    
    func configureViewForSelection() {
        editButton.show()
        readyButton.hide()
    }
    
    func configureViewForEditing() {
        editButton.hide()
        readyButton.show()
    }
    
    func getProfile(id: Int) -> Profile? {
        return currentProfiles.first(where: { $0.id == id })
    }
    
    // MARK: - Actions
    @IBAction func editTouched(_ sender: UIBarButtonItem) {
        isEditModeEnabled = true
    }
    
    @IBAction func readyTouched(_ sender: UIBarButtonItem) {
        isEditModeEnabled = false
    }
    
    @IBAction func firstProfileTouched(_ sender: UIButton) {
        profileButtonTouched(id: 0)
    }
    
    @IBAction func secondProfileTouched(_ sender: UIButton) {
        profileButtonTouched(id: 1)
    }
    
    @IBAction func thirdProfileTouched(_ sender: UIButton) {
        profileButtonTouched(id: 2)
    }
    
    @IBAction func fourthProfileTouched(_ sender: UIButton) {
        profileButtonTouched(id: 3)
    }
    
    // MARK: - Transitions
    enum AvailableTransitions: String {
        case goToEditProfile = "goToEditProfile"
    }
    
    private func profileButtonTouched(id: Int) {
        ProfileEditionViewModel.resetSelection()
        ProfileEditionViewModel.selectedProfileIndex = id
        if let profile: Profile = getProfile(id: id) {
            // Profile already exists:
            // If we're in "edit mode" -> go to "Edit Profile" view
            // If we're in "selection mode" -> go to "Table of Movies" view
            if isEditModeEnabled {
                ProfileEditionViewModel.selectedProfile = profile
                performSegue(withIdentifier: AvailableTransitions.goToEditProfile.rawValue, sender: self)
            } else {
                MoviesViewModel.selectedProfile = profile
                self.dismiss(animated: true, completion: nil)
            }
            
        } else {
            // Profile is empty, go to "Edit Profile" view
            performSegue(withIdentifier: AvailableTransitions.goToEditProfile.rawValue, sender: self)
        }
    }
}
