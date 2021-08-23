// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

class AirDropHelper {
    static var shared = AirDropHelper()

    func airdrop(path: String) {
        if let bundleID = Bundle.main.bundleIdentifier {
            let fullString = "airdropper://\(path)?sender=\(bundleID)"
            if let url = URL(string: fullString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
