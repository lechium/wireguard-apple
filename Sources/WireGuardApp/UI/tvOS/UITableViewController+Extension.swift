// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

extension UITableViewController {

    func clearWeirdBackgrounds() {
        #if os(tvOS)
        for section in 0..<tableView.numberOfSections {
            for index in 0..<tableView.numberOfRows(inSection: section) {
                let ip = IndexPath(row: index, section: section)
                if let cell = tableView.cellForRow(at: ip) as? KeyValueCell {
                    cell.hideWeirdShadow(field: cell.valueTextField)
                }
            }
        }
        #endif
    }
}
