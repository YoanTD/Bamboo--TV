//
//  ProfileAvatarViewController.swift
//  BambooTV
//
//  Created by Yoan Tarrillo

import UIKit

class ProfileAvatarViewController: UIViewController {
    
    private let avatars: [String] = ["avatar_15", "avatar_11", "avatar_34", "avatar_03", "avatar_12", "avatar_20"]
    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAvatarButtons()
    }
    
    private func configureAvatarButtons() {
        for (index, btn) in buttons.enumerated() {
            if index < avatars.count {
                let img = UIImage(named: avatars[index])
                btn.setBackgroundImage(img, for: .normal)
            } else {
                print("‼️ Error: more buttons than avatars [\(#function)]")
            }
        }
    }
    
    @IBAction func avatarButtonTouched(_ sender: UIButton) {
        if let index: Int = buttons.firstIndex(of: sender),
            index < avatars.count {
            ProfileEditionViewModel.newAvatarImageName = avatars[index]
            self.navigationController?.popViewController(animated: true)
        }
    }
}
