// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit

class TextCell: UITableViewCell {
    var message: String {
        get { return textLabel?.text ?? "" }
        set(value) { textLabel!.text = value }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTextColor(_ color: UIColor) {
        textLabel?.textColor = color
    }

    func setTextAlignment(_ alignment: NSTextAlignment) {
        textLabel?.textAlignment = alignment
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        message = ""
        #if os(iOS)
        if #available(iOS 13.0, *) {
            setTextColor(.label)
        } else {
            setTextColor(.black)
        }
        //#else
          //  setTextColor(.black)
        #endif
        setTextAlignment(.left)
    }
}
