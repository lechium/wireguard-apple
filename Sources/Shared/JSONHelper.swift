// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

struct OurError: Error {
    var description: String?
    var error: Error?
}

func jsonFrom(url: URL, completionHandler: @escaping ([String: Any]?, OurError?) -> Void) {
    Threads.performTaskInBackground {
        let task = URLSession.shared.jsonDataTask(with: url) { (json, response, error) in
            guard let json = json as? [String: Any], error == nil else {
                print("jsonFrom error occured: \(String(describing:error))")
                completionHandler(nil, OurError(error: error))
                return
            }
            completionHandler(json, nil)
        }
        task.resume()
    }
}


struct StorageController {
    
    enum StorageError: Swift.Error {
        case fileDoesNotExist
        case otherError(error: Swift.Error)
    }
    
    let destinationURL: URL
    
    func store(_ url: URL, completion: (Result<URL, StorageError>) -> Void) throws {
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            completion(.failure(StorageError.fileDoesNotExist))
            return
        }
        try perform {
            try FileManager.default.moveItem(at: url, to: destinationURL)
            completion(.success(destinationURL))
        }
    }
    
    private func perform(_ callback: () throws -> Void) rethrows {
        do {
            try callback()
        } catch {
            throw StorageError.otherError(error: error)
        }
    }
}
