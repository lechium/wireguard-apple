// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit

class LogViewController: UIViewController {

    #if os(tvOS)
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [saveButton, textView]
    }
    #endif

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        button.target(forAction: #selector(saveTapped(sender:)), withSender: self)
        button.setTitle("Save", for: .normal)
        return button
    }()

    let menuTapRecognizer: UITapGestureRecognizer = {
        let mtr = UITapGestureRecognizer(target: self, action: #selector(menuTapped(sender:)))
        mtr.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        mtr.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        return mtr
    }()

    let textView: UITextView = {
        let textView = UITextView()
        #if os(iOS)
        textView.isEditable = false
        #endif
        textView.isSelectable = true
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.adjustsFontForContentSizeCategory = true
        return textView
    }()

    let busyIndicator: UIActivityIndicatorView = {
        #if os(iOS)
        if #available(iOS 13.0, *) {
            let busyIndicator = UIActivityIndicatorView(style: .medium)
            busyIndicator.hidesWhenStopped = true
            return busyIndicator
        } else {
            let busyIndicator = UIActivityIndicatorView(style: .gray)
            busyIndicator.hidesWhenStopped = true
            return busyIndicator
        }
        #else
            let busyIndicator = UIActivityIndicatorView(style: .white)
            busyIndicator.hidesWhenStopped = true
            return busyIndicator
        #endif
    }()

    let paragraphStyle: NSParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(NSParagraphStyle.default)
        paragraphStyle.lineHeightMultiple = 1.2
        return paragraphStyle
    }()

    var isNextLineHighlighted = false

    var logViewHelper: LogViewHelper?
    var isFetchingLogEntries = false
    private var updateLogEntriesTimer: Timer?

    override func loadView() {
        view = UIView()
        #if os(iOS)
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        #else
        textView.isUserInteractionEnabled = true
        textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        view.addGestureRecognizer(self.menuTapRecognizer)
        #endif

        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(busyIndicator)
        busyIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busyIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            busyIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        busyIndicator.startAnimating()

        logViewHelper = LogViewHelper(logFilePath: FileManager.logFileURL?.path)
        startUpdatingLogEntries()
    }

    override func viewDidLoad() {
        title = tr("logViewTitle")
        #if os(tvOS)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.saveButton)
        #else
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped(sender:)))
        #endif
    }

    @objc func menuTapped(sender: AnyObject) {
        NSLog("menuTapped")
    }
    #if os(tvOS)
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.type == .menu {
                if saveButton.isFocused {
                    super.pressesBegan(presses, with: event)
                } else {
                    setNeedsFocusUpdate()
                }
            } else {
                super.pressesBegan(presses, with: event)
            }
        }
    }

    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.type == .menu {
            } else {
                super.pressesEnded(presses, with: event)
            }
        }
    }
    #endif
    func updateLogEntries() {
        guard !isFetchingLogEntries else { return }
        isFetchingLogEntries = true
        logViewHelper?.fetchLogEntriesSinceLastFetch { [weak self] fetchedLogEntries in
            guard let self = self else { return }
            defer {
                self.isFetchingLogEntries = false
            }
            if self.busyIndicator.isAnimating {
                self.busyIndicator.stopAnimating()
            }
            guard !fetchedLogEntries.isEmpty else { return }
            let isScrolledToEnd = self.textView.contentSize.height - self.textView.bounds.height - self.textView.contentOffset.y < 1

            let richText = NSMutableAttributedString()
            let bodyFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
            let captionFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
            for logEntry in fetchedLogEntries {
                var bgColor: UIColor
                var fgColor: UIColor
                #if os(iOS)
                if #available(iOS 13.0, *) {
                    bgColor = self.isNextLineHighlighted ? .systemGray3 : .systemBackground
                    fgColor = .label
                } else {
                    bgColor = self.isNextLineHighlighted ? UIColor(white: 0.88, alpha: 1.0) : UIColor.white
                    fgColor = .black
                }
                #else
                    bgColor = self.isNextLineHighlighted ? UIColor(white: 0.88, alpha: 1.0) : UIColor.white
                    fgColor = .black
                #endif
                let timestampText = NSAttributedString(string: logEntry.timestamp + "\n", attributes: [.font: captionFont, .backgroundColor: bgColor, .foregroundColor: fgColor, .paragraphStyle: self.paragraphStyle])
                let messageText = NSAttributedString(string: logEntry.message + "\n", attributes: [.font: bodyFont, .backgroundColor: bgColor, .foregroundColor: fgColor, .paragraphStyle: self.paragraphStyle])
                richText.append(timestampText)
                richText.append(messageText)
                self.isNextLineHighlighted.toggle()
            }
            self.textView.textStorage.append(richText)
            if isScrolledToEnd {
                let endOfCurrentText = NSRange(location: (self.textView.text as NSString).length, length: 0)
                self.textView.scrollRangeToVisible(endOfCurrentText)
            }
        }
    }

    func startUpdatingLogEntries() {
        updateLogEntries()
        updateLogEntriesTimer?.invalidate()
        let timer = Timer(timeInterval: 1 /* second */, repeats: true) { [weak self] _ in
            self?.updateLogEntries()
        }
        updateLogEntriesTimer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    @objc func saveTapped(sender: AnyObject) {
        guard let destinationDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withTimeZone] // Avoid ':' in the filename
        let timeStampString = dateFormatter.string(from: Date())
        let destinationURL = destinationDir.appendingPathComponent("wireguard-log-\(timeStampString).txt")

        DispatchQueue.global(qos: .userInitiated).async {

            if FileManager.default.fileExists(atPath: destinationURL.path) {
                let isDeleted = FileManager.deleteFile(at: destinationURL)
                if !isDeleted {
                    ErrorPresenter.showErrorAlert(title: tr("alertUnableToRemovePreviousLogTitle"), message: tr("alertUnableToRemovePreviousLogMessage"), from: self)
                    return
                }
            }

            let isWritten = Logger.global?.writeLog(to: destinationURL.path) ?? false
            NSLog("log is written")
            DispatchQueue.main.async {
                guard isWritten else {
                    ErrorPresenter.showErrorAlert(title: tr("alertUnableToWriteLogTitle"), message: tr("alertUnableToWriteLogMessage"), from: self)
                    return
                }
                #if os(iOS)
                let activityVC = UIActivityViewController(activityItems: [destinationURL], applicationActivities: nil)
                if let sender = sender as? UIBarButtonItem {
                    activityVC.popoverPresentationController?.barButtonItem = sender
                }
                activityVC.completionWithItemsHandler = { _, _, _, _ in
                    // Remove the exported log file after the activity has completed
                    _ = FileManager.deleteFile(at: destinationURL)
                }
                self.present(activityVC, animated: true)
                #elseif os(tvOS)
                if let url = URL(string: "airdropper://\(destinationURL.path)?sender=com.nito.wireguard-ios") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                #endif
            }
        }
    }
}
