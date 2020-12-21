//
//  ProfileEditionViewController.swift
//  BambooTV
//
//
//  Created by Yoan Tarrillo

import UIKit

class ProfileEditionViewController: UIViewController {
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var removeButton: UIButton!
    
    private var currentProfile: Profile? = ProfileEditionViewModel.selectedProfile
    private var profileManager = ProfileManager()
    private let defaultAvatar: String = "avatar_15"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    private func configureView() {
        if let profile = currentProfile {
            // We're editing a profile that already exists
            let avatarName = ProfileEditionViewModel.newAvatarImageName ?? profile.imageName
            let img = UIImage(named: avatarName)
            avatarButton.setBackgroundImage(img, for: .normal)
            nameTextField.text = profile.name
            removeButton.isHidden = false
            
        } else {
            let imgName = ProfileEditionViewModel.newAvatarImageName ?? defaultAvatar
            ProfileEditionViewModel.newAvatarImageName = imgName
            let img = UIImage(named: imgName)
            avatarButton.setBackgroundImage(img, for: .normal)
            removeButton.isHidden = true
        }
    }
    
    @IBAction func cancelTouched(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTouched(_ sender: Any) {
        var profile = currentProfile ?? Profile(name: "", imageName: "", id: -1)
        profile.name = nameTextField.text ?? ""
        profile.imageName = ProfileEditionViewModel.newAvatarImageName ?? profile.imageName
        profile.id = ProfileEditionViewModel.selectedProfileIndex ?? -1
        
        if profile.name.isEmpty || profile.imageName.isEmpty {
            let alert = BaseAlert.defaultAlert(title: "Revisa los datos",
                                               message: "Debes rellenar el nombre y seleccionar un avatar",
                                               buttonText: "OK")
            
            self.present(alert, animated: true, completion: nil)
        } else {
            profileManager.saveProfile(profile)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func removeButtonTouched(_ sender: Any) {
        guard let profile = currentProfile else { return }
        let alert = BaseAlert.destroyAlert( title: "Eliminar perfil",
                                            message: "¿Quieres eliminar el perfil \(profile.name)?",
                                            destroyText: "Eliminar",
                                            cancelText: "Cancelar")
        { alertAction in
            self.profileManager.removeProfile(profile)
            self.navigationController?.popViewController(animated: true)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
