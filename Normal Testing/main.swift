//
//  main.swift
//  Normal
//
//  Created by Alex Jackson on 2017-04-25.
//  Copyright © 2017 Alex Jackson. All rights reserved.
//

import Cocoa


func buildMenubar() -> NSMenu {
    let bundleNameKey = kCFBundleNameKey as String
    let appName = Bundle.main.object(forInfoDictionaryKey: bundleNameKey)! as! String

    let mainMenu = NSMenu(title: "")

    let applicationMenu = NSMenu(title: appName)
    let applicationMenuItem = NSMenuItem(title: appName, action: nil, keyEquivalent: "")

    let preferencesWindowItem = NSMenuItem(title: "Preferences...",
                                           action: #selector(AppDelegate.showPreferencesWindow),
                                           keyEquivalent: ",")

    let quitItem = NSMenuItem(title: "Quit",
                              action: #selector(NSApplication.stop(_:)),
                              keyEquivalent: "q")

    applicationMenuItem.submenu = applicationMenu
    applicationMenu.addItem(preferencesWindowItem)
    applicationMenu.addItem(quitItem)

    mainMenu.addItem(applicationMenuItem)

    return mainMenu
}


let app = NSApplication.shared
let delegate = AppDelegate()
let menu = buildMenubar()

// Build the main menu

app.delegate = delegate
app.mainMenu = menu

app.run()
