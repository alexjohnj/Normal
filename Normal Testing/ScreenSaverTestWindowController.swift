//
//  ScreenSaverTestWindowController.swift
//  Normal
//
//  Created by Alex Jackson on 2017-05-09.
//  Copyright © 2017 Alex Jackson. All rights reserved.
//

import Cocoa

class ScreenSaverTestWindowController: NSWindowController {
    init(screen: NSScreen) {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: screen.frame.width, height: screen.frame.height),
                              styleMask: NSWindow.StyleMask.borderless,
                              backing: .buffered,
                              defer: true,
                              screen: screen)

        let screensaverView = GaussView(frame: window.frame, isPreview: false)
        window.contentView = screensaverView

        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
