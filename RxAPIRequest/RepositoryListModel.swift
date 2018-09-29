//
//  RepositoryListModel.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/29.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Foundation

struct RepositoryListModel {
    private let apiClient: APIClient<RepositoryList>

    init(apiClient: APIClient<RepositoryList> = APIClient()) {
        self.apiClient = apiClient
    }

    func request(userIdentifier: String, completion: @escaping (RepositoryList?) -> Void) {
        let parameters = ["userIdentifier": userIdentifier]
        apiClient.request(api: .repositoryList(parameters)) { result in
            switch result {
            case .success(let value): completion(value)
            case .failure: completion(nil)
            }
        }
    }
}
