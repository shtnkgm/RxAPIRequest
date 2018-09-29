//
//  UserInfoModel.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/29.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Foundation
import RxSwift

struct UserInfoModel {
    typealias ResponseType = UserInfo

    private let apiClient: APIClient<ResponseType>

    init(apiClient: APIClient<ResponseType> = APIClient()) {
        self.apiClient = apiClient
    }

    func request(completion: @escaping (Result<ResponseType>) -> Void) {
        apiClient.request(api: .userInfo) { result in
            completion(result)
        }
    }

    func rxRequest() -> Observable<ResponseType> {
        return apiClient.rxRequest(api: .userInfo)
    }
}
