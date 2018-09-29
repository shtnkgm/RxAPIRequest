//
//  RepositoryListModel.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/29.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Alamofire
import Foundation

struct RepositoryListModel {
    func request(userId: String, completion: @escaping (RepositoryList?) -> Void) {
        let urlString = "https://raw.githubusercontent.com/shtnkgm/RxAPIRequest/master/RxAPIRequest/API/repository_list.json"
        Alamofire.request(urlString, method: .get).responseJSON { response in
            guard let data = response.data else {
                print("データの取得に失敗: \(response)")
                completion(nil)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let repositoryList = try jsonDecoder.decode(RepositoryList.self, from: data)
                print("データの取得に成功: \(repositoryList)")
                completion(repositoryList)
            } catch {
                print("JSONのデコードに失敗: \(error)")
                completion(nil)
            }
        }
    }
}
