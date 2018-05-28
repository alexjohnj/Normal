//
//  Preferences.swift
//  Normal
//
//  Created by Alex Jackson on 2017-05-11.
//  Copyright © 2017 Alex Jackson. All rights reserved.
//

import Foundation
import ScreenSaver
import os

class Preferences {
    static let shared = Preferences()

    private struct Keys {
        static let moduleName = "org.alexj.Normal"
        static let blurRadius = "blurRadius"
    }

    private var preferences: UserDefaults = {
        guard let prefs = ScreenSaverDefaults(forModuleWithName: Keys.moduleName) else {
            os_log("Unable to load module defaults.", type: OSLogType.error)
            return UserDefaults()
        }

        return prefs
    }()

    var blurRadius: Double {
        get {
            return preferences.double(forKey: Keys.blurRadius)
        }

        set(newRadius) {
            preferences.set(newRadius, forKey: Keys.blurRadius)
            preferences.synchronize()
        }
    }

    private init() {
        let defaults: [String: Any] = [Keys.blurRadius: 7.0]

        preferences.register(defaults: defaults)
    }
}
