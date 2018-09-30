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
    private let userIdentifierParameterKey = "user_identifier"

    init(apiClient: APIClient<ResponseType> = APIClient()) {
        self.apiClient = apiClient
    }

    func request(userIdentifier: String, completion: @escaping (Result<ResponseType>) -> Void) {
        let parameters = [userIdentifierParameterKey: userIdentifier]
        apiClient.request(api: .repositoryList(parameters)) { result in
            completion(result)
        }
    }

    func rxRequest(userIdentifier: String) -> Observable<ResponseType> {
        let parameters = [userIdentifierParameterKey: userIdentifier]
        return apiClient.rxRequest(api: .repositoryList(parameters))
    }
}
