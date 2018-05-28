//
//  GaussView.swift
//  Normal
//
//  Created by Alex Jackson on 2017-04-25.
//  Copyright © 2017 Alex Jackson. All rights reserved.
//

import ScreenSaver
import CoreImage
import os

class GaussView: ScreenSaverView {
    typealias WindowInfo = [String: Any]
    let ScreenSaverWindowLayer = CGWindowLevelForKey(.screenSaverWindow)
    
    lazy var preferencesWindowController: PrefencesWindowController = {
        let pref = PrefencesWindowController()
        pref.delegate = self
        return pref
    }()
    
    /// ID of the display the current instance of ScreenSaverView is presented on.
    var displayID: CGDirectDisplayID? {
        guard let devInfo = window?.screen?.deviceDescription else {
            os_log("Could not get device information for ScreenSaverView's screen",
                   type: .error)
            return nil
        }

        return devInfo [NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID
    }
    
    /// Bounds of the display the current instance of ScreenSaverView is
    /// presented on in global screen space coordinates. `nil` if the device
    /// description of the screen can't be accessed which _shouldn't_ happen.
    var displayBounds: CGRect? {
        guard let displayID = displayID else {
            return nil
        }
        return CGDisplayBounds(displayID)
    }
    
    //MARK: Initialisation
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    //MARK: View Lifetime
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        guard let screenShot = screenshotIgnoringScreenSaver() else {
            os_log("Could not take a screenshot")
            NSColor.red.setFill()
            rect.fill()
            return
        }
        
        let blurredScreenshot = CIImage(cgImage: screenShot).applyingClampedGaussianBlur(withSigma: Preferences.shared.blurRadius)
        blurredScreenshot.draw(in: rect,
                               from: blurredScreenshot.extent,
                               operation: .copy,
                               fraction: 1.0)
    }
    
    //MARK: Configuration Sheet
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        return preferencesWindowController.window
    }
    
    //MARK: Helper Functions
    
    /// Take a screenshot of all on screen windows on the screen this instance
    /// is being displayed on. Ignores the screen saver if it's displayed.
    func screenshotIgnoringScreenSaver() -> CGImage? {
        guard let onscreenWindows = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [WindowInfo]? else {
            os_log("No windows are on screen", type: .info)
            return nil
        }
        
        guard let displayBounds = displayBounds else {
            return nil
        }
        
        if let topWindow = onscreenWindows.filter({ $0["kCGWindowLayer"] as! CGWindowLevel >= ScreenSaverWindowLayer }).reversed().first {
            return CGWindowListCreateImage(displayBounds, .optionOnScreenBelowWindow, topWindow["kCGWindowNumber"]! as! CGWindowID, .bestResolution)
        } else {
            return CGWindowListCreateImage(displayBounds, .optionOnScreenOnly, kCGNullWindowID, .bestResolution)
        }
    }
}

extension GaussView: SheetDelegate {
    func sheetDidEnd(statusCode: NSApplication.ModalResponse) {
        needsDisplay = statusCode == NSApplication.ModalResponse.OK
    }
}
