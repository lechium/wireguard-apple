// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

extension UIView {

    func darkMode() -> Bool {
        if self.responds(to: #selector(getter: self.traitCollection)) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        return false
    }

    func findFirstSubviewWithClass(theClass: AnyClass) -> UIView? {
        if self.isMember(of: theClass) {
            return self
        }

        for v in self.subviews {
            if let theView = v.findFirstSubviewWithClass(theClass: theClass) {
                return theView
            }
        }
        return nil
    }
}
