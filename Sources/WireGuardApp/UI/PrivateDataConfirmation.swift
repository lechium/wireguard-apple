// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation
#if !os(tvOS)
import LocalAuthentication
#endif
#if os(macOS)
import AppKit
#endif

class PrivateDataConfirmation {
    static func confirmAccess(to reason: String, _ after: @escaping () -> Void) {

        #if os(tvOS)
        after()
        #endif

        #if os(iOS)
        let context = LAContext()

        var error: NSError?
        if !context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            guard let error = error as? LAError else { return }
            if error.code == .passcodeNotSet {
                // We give no protection to folks who just don't set a passcode.
                after()
            }
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
            DispatchQueue.main.async {
                #if os(macOS)
                if !NSApp.isActive {
                    NSApp.activate(ignoringOtherApps: true)
                }
                #endif
                if success {
                    after()
                }
            }
        }
        #endif
    }
}
