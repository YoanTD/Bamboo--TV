//
//  ProfileEditionViewModel.swift
//  BambooTV
//
//  Created by Yoan Tarrillo

import Foundation

struct ProfileEditionViewModel {
    static var selectedProfileIndex: Int?
    static var selectedProfile: Profile?
    static var newAvatarImageName: String?
    
    static func resetSelection() {
        selectedProfileIndex = nil
        selectedProfile = nil
        newAvatarImageName = nil
    }
}
