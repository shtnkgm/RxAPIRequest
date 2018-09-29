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
    func request(completion: @escaping (UserInfo?) -> Void) {
        let urlString = "https://raw.githubusercontent.com/shtnkgm/RxAPIRequest/master/RxAPIRequest/API/user_info_api.json"
        Alamofire.request(urlString, method: .get).responseJSON { response in
            guard let data = response.data else {
                print("データの取得に失敗: \(response)")
                completion(nil)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let userInfo = try jsonDecoder.decode(UserInfo.self, from: data)
                print("データの取得に成功: \(userInfo)")
                completion(userInfo)
            } catch {
                print("JSONのデコードに失敗: \(error)")
                completion(nil)
            }
        }
    }
}
