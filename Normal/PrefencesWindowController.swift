//
//  PrefencesWindowController.swift
//  Normal
//
//  Created by Alex Jackson on 2017-05-09.
//  Copyright © 2017 Alex Jackson. All rights reserved.
//

import Cocoa
import ScreenSaver

protocol SheetDelegate {
    func sheetDidEnd(statusCode: NSApplication.ModalResponse)
}

class PrefencesWindowController: NSWindowController {
    var delegate: SheetDelegate? = nil

    //MARK: UI Elements
    lazy var doneButton: NSButton = {
        let button = NSButton(title: "Done", target: self, action: #selector(dismissSelf(sender:)))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.keyEquivalent = "\r"
        return button
    }()

    lazy var cancelButton: NSButton = {
        let button = NSButton(title: "Cancel", target: self, action: #selector(dismissSelf(sender:)))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.keyEquivalent = "\u{1b}"
        return button
    }()

    let blurRadiusField: NSTextField = {
        let textField = NSTextField(string: "")
        let formatter = RadiusNumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimum = 0
        formatter.isPartialStringValidationEnabled = true

        textField.formatter = formatter
        textField.doubleValue = Preferences.shared.blurRadius

        return textField
    }()

    override var windowNibName: NSNib.Name? {
        return NSNib.Name("arsars")
    }

    //MARK: Initialisers
    init() {
        super.init(window: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("initWithCoder not implemented")
    }

    //MARK: NSWindowController Overrides
    override func loadWindow() {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
                          styleMask: [NSWindow.StyleMask.titled],
                          backing: .buffered,
                          defer: true)
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        let sliderLabel = NSTextField(labelWithString: "Blur Radius:")

        let sliderStackView = NSStackView(views: [sliderLabel, blurRadiusField])
        sliderStackView.orientation = .horizontal

        let buttonStackView = NSStackView(views: [cancelButton, doneButton])
        buttonStackView.orientation = .horizontal

        let controlStackView = NSStackView(views: [sliderStackView, buttonStackView])
        controlStackView.orientation = .vertical
        controlStackView.spacing = 20.0

        guard let window = window else {
            return
        }

        window.contentView?.addSubview(controlStackView)
        controlStackView.trailingAnchor.constraint(equalTo: window.contentView!.trailingAnchor, constant: -20).isActive = true
        controlStackView.leadingAnchor.constraint(equalTo: window.contentView!.leadingAnchor, constant: 20).isActive = true
        controlStackView.topAnchor.constraint(equalTo: window.contentView!.topAnchor, constant: 20).isActive = true
        controlStackView.bottomAnchor.constraint(equalTo: window.contentView!.bottomAnchor, constant: -20).isActive = true
    }

    //MARK: Interface Actions
    @objc func dismissSelf(sender: NSButton) {
        let response = sender == doneButton ? NSApplication.ModalResponse.OK : NSApplication.ModalResponse.cancel

        if response == NSApplication.ModalResponse.OK {
            Preferences.shared.blurRadius = blurRadiusField.doubleValue
        }

        window?.sheetParent?.endSheet(window!, returnCode: response)
        delegate?.sheetDidEnd(statusCode: response)
    }
}


class RadiusNumberFormatter: NumberFormatter {
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        // Check if field is empty
        guard !partialString.isEmpty else {
            return true
        }

        // Check input is only a positive decimal number/integer
        let decimalRegexp = try! NSRegularExpression(pattern: "[0-9.]", options: .caseInsensitive)
        let partialLen = partialString.count

        guard decimalRegexp.numberOfMatches(in: partialString, range: NSMakeRange(0, partialLen)) == partialLen else {
            return false
        }

        // Check input can be parsed into a number
        guard let value = Double(partialString) else {
            return false
        }

        // Check input isn't stupidly big
        guard value <= 25 else {
            newString?.pointee = "25"
            return false
        }
        
        return true
    }
}
