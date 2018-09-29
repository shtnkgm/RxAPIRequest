//
//  UserInfoModel.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/29.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Alamofire
import Foundation

struct UserInfoModel {
    private let apiClient: APIClient<UserInfo>

    init(apiClient: APIClient<UserInfo> = APIClient()) {
        self.apiClient = apiClient
    }

    func request(completion: @escaping (UserInfo?) -> Void) {
        apiClient.request(api: .userInfo) { result in
            switch result {
            case .success(let value): completion(value)
            case .failure: completion(nil)
            }
        }
    }
}
