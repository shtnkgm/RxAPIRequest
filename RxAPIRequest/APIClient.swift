//
//  APIClient.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/29.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Alamofire
import Foundation

struct APIClient<T: Codable> {
    enum Result<T: Codable> {
        case success(T)
        case failure(Error)
    }

    enum API {
        case userInfo
        case repositoryList(Parameters)

        var urlString: String {
            let baseUrlString = "https://raw.githubusercontent.com/shtnkgm/RxAPIRequest/master/RxAPIRequest/API/"
            switch self {
            case .userInfo: return baseUrlString + "user_info_api.json"
            case .repositoryList: return baseUrlString + "repository_list.json"
            }
        }

        var method: HTTPMethod {
            switch self {
            case .userInfo: return .get
            case .repositoryList: return .get
            }
        }

        var parameters: Parameters {
            switch self {
            case .userInfo: return [:]
            case .repositoryList(let parameters): return parameters
            }
        }
    }

    enum APIClientError: Error {
        case connectionError
        case parseError(Error)
    }

    func request(api: API, completion: @escaping (Result<T>) -> Void) {
        Alamofire.request(api.urlString, method: api.method, parameters: api.parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        print("データの取得に失敗: \(response)")
                        completion(Result.failure(APIClientError.connectionError))
                        return
                    }
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        let data = try jsonDecoder.decode(T.self, from: data)
                        print("データの取得に成功: \(data)")
                        completion(Result.success(data))
                    } catch {
                        print("JSONのデコードに失敗: \(error)")
                        completion(Result.failure(APIClientError.parseError(error)))
                    }
                case .failure(let error):
                    print("データの取得に失敗: \(error)")
                    completion(Result.failure(APIClientError.connectionError))
                }
        }
    }
}
