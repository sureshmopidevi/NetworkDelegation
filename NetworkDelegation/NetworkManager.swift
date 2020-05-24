//
//  NetworkManager.swift
//  NetworkDelegation
//
//  Created by APPLE  on 23/05/20.
//  Copyright © 2020 Suresh Mopidevi. All rights reserved.
//

import Foundation

protocol NetworkDelegate {
    func didStartedAPICall()
    func didFailedToGetResponse(error: String)
    func didReceivedResponse(response: String)
    func didEndAPICall()
}

class NetworkManager {
    private init() {}
    var delegate: NetworkDelegate?
    static let shared = NetworkManager()

    func fetch(urlString: String = "https://jsonplaceholder.typicode.com/users") {
        delegate?.didStartedAPICall()
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: URL(string: urlString)!) { data, _, err in
                if let error = err {
                    self.delegate?.didFailedToGetResponse(error: error.localizedDescription)
                }
                if let response = data, let asString = String(data: response, encoding: .utf8) {
                    self.delegate?.didReceivedResponse(response: asString)
                }
                self.delegate?.didEndAPICall()
            }.resume()
        }
    }
}
