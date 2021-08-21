// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import Foundation

extension URLSession {

    func jsonDataTask(with url: URL, completionHandler: @escaping (Any?, HTTPURLResponse?, OurError?) -> Void) -> URLSessionTask {
        let orig = self.httpDataTask(with: url) { (data, response, error) in
            if response?.statusCode != 200 {
                completionHandler(nil, response, OurError(description: "\(response!.statusCode) != 200, URL:\(url)"))
            } else {
                guard let data = data, error == nil, let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any] else {
                    print("jsonFrom error occured: \(String(describing:error))")
                    completionHandler(nil, response, OurError(error: error))
                    return
                }
                completionHandler(json, response, nil)
            }
        }
        return orig
    }

    func httpDataTask(with url: URL, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let orig = self.dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completionHandler(data, nil, error)
                return
            }
            completionHandler(data, response, error)
        }
        return orig
    }
}
