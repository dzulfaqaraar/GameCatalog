//
//  ProfileMemory.swift
//  Profile
//
//  Created by Dzulfaqar on 20/06/22.
//

import Foundation

public final class ProfileMemory {
    private let stateFirstKey = "first"
    private let imageKey = "image"
    private let nameKey = "name"
    private let websiteKey = "website"

    private init() {}

    static let sharedInstance: ProfileMemory = .init()

    var stateFirst: Bool {
        get {
            return UserDefaults.standard.bool(forKey: stateFirstKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: stateFirstKey)
        }
    }

    var image: Data? {
        get {
            return UserDefaults.standard.data(forKey: imageKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: imageKey)
        }
    }

    var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }

    var website: String {
        get {
            return UserDefaults.standard.string(forKey: websiteKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: websiteKey)
        }
    }

    func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
