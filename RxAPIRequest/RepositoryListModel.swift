//
//  RepositoryListModel.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/29.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Foundation
import RxSwift

struct RepositoryListModel {
    typealias ResponseType = RepositoryList

    private let apiClient: APIClient<ResponseType>

    init(apiClient: APIClient<ResponseType> = APIClient()) {
        self.apiClient = apiClient
    }

    func request(userIdentifier: String, completion: @escaping (Result<ResponseType>) -> Void) {
        let parameters = ["user_identifier": userIdentifier]
        apiClient.request(api: .repositoryList(parameters)) { result in
            completion(result)
        }
    }

    func rxRequest(userIdentifier: String) -> Observable<ResponseType> {
        let parameters = ["user_identifier": userIdentifier]
        return apiClient.rxRequest(api: .repositoryList(parameters))
    }
}
