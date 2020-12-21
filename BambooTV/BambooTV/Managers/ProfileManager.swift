//
//  ProfileManager.swift
//  BambooTV
//
//  Created by Yoan Tarrillo
import Foundation

struct ProfileManager {
    func readProfiles() -> [Profile] {
        if let encodedData = UserDefaults.standard.data(forKey: ProfileKeys.profileList.rawValue) {
            do {
                let storedProfiles = try JSONDecoder().decode([Profile].self, from: encodedData)
                return storedProfiles

            } catch {
                print("Unable to decode [Profiles] (\(error))")
            }
        }
        return []
    }
    
    func saveProfile(_ profile: Profile) {
        removeProfile(profile)
        var storedProfiles = readProfiles()
        storedProfiles.append(profile)
        saveAllProfiles(storedProfiles)
    }
    
    func removeProfile(_ profile: Profile) {
        var storedProfiles = readProfiles()
        storedProfiles.removeAll(where: { $0 == profile })
        saveAllProfiles(storedProfiles)
    }
    
    private func saveAllProfiles(_ profiles: [Profile]) {
        guard let encodedData = try? JSONEncoder().encode(profiles) else { return }
        UserDefaults.standard.set(encodedData, forKey: ProfileKeys.profileList.rawValue)
        UserDefaults.standard.synchronize()
    }
}

enum ProfileKeys: String {
    case profileList
}
