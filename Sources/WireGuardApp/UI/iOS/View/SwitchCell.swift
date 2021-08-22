// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit

class SwitchCell: UITableViewCell {
    var message: String {
        get { return textLabel?.text ?? "" }
        set(value) { textLabel?.text = value }
    }
    var isOn: Bool {
        get { return switchView.isOn }
        set(value) { switchView.isOn = value }
    }
    var isEnabled: Bool {
        get { return switchView.isEnabled }
        set(value) {
            switchView.isEnabled = value
            if #available(iOS 13.0, tvOS 13.0, *) {
                textLabel?.textColor = value ? .label : .secondaryLabel
            } else {
                textLabel?.textColor = value ? .black : .gray
            }
        }
    }

    var onSwitchToggled: ((Bool) -> Void)?

    var observationToken: AnyObject?

    #if os(iOS)
    let switchView = UISwitch()
    #elseif os(tvOS)
    let switchView = UIFLEXSwitch.new()
    #endif

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        #if os(tvOS)
        switchView.frame = CGRect(x: 0, y: 0, width: 150, height: 87)
        #endif
        accessoryView = switchView
        switchView.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func switchToggled() {
        onSwitchToggled?(switchView.isOn)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onSwitchToggled = nil
        isEnabled = true
        message = ""
        isOn = false
        observationToken = nil
    }

    #if os(tvOS)
    func updateStateDependantViews() {
        if switchView.isEnabled {
            if isFocused {
                textLabel?.textColor = .black
            } else {
                textLabel?.textColor = .white
            }
        } else {
            if isFocused {
                textLabel?.textColor = .darkGray
            } else {
                textLabel?.textColor = .gray
            }
        }
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations({
            self.updateStateDependantViews()
        }, completion: nil)
    }
    #endif
}
