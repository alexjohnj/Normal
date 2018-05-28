//
//  AppDelegate.swift
//  Normal
//
//  Created by Alex Jackson on 2017-04-25.
//  Copyright © 2017 Alex Jackson. All rights reserved.
//

import Cocoa
import Dispatch

class AppDelegate: NSObject, NSApplicationDelegate {
    var windowControllers: [ScreenSaverTestWindowController] = []

    override init() {
        windowControllers = NSScreen.screens.map(ScreenSaverTestWindowController.init(screen:))
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        //        buildMenu()
        windowControllers.forEach { $0.window?.makeKeyAndOrderFront(self) }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    @objc func showPreferencesWindow() {
        let mainWindowController = windowControllers.first { $0.window?.screen == NSScreen.main }
        let screenSaverView = mainWindowController?.window?.contentView as? GaussView
        guard let configureSheet = screenSaverView?.configureSheet else {
            print("ScreenSaverView does not have a configuration sheet")
            return
        }

        mainWindowController?.window?.beginSheet(configureSheet) { response in
            configureSheet.orderOut(self)

            if response == NSApplication.ModalResponse.OK {
                self.windowControllers.forEach { wc in
                    wc.window?.orderOut(self)

                    // Wait a short time for macOS to actually close the window.
                    // Yes, this isn't a good way of doing this.
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        wc.window?.contentView?.needsDisplay = true
                        wc.window?.makeKeyAndOrderFront(self)
                    }
                }
            }
        }
    }
}
