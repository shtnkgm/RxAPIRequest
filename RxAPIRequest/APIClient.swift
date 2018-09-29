//
//  APIClient.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/29.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

struct APIClient<T: Codable> {
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
        case emptyResponseError
        case connectionError(Error)
        case parseError(Error)
    }

    func request(api: API, completion: @escaping (Result<T>) -> Void) {
        Alamofire.request(api.urlString, method: api.method, parameters: api.parameters)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(Result.failure(APIClientError.emptyResponseError))
                        return
                    }
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        let data = try jsonDecoder.decode(T.self, from: data)
                        completion(Result.success(data))
                    } catch {
                        completion(Result.failure(APIClientError.parseError(error)))
                    }
                case .failure(let error):
                    completion(Result.failure(APIClientError.connectionError(error)))
                }
        }
    }

    func rxRequest(api: API) -> Observable<T> {
        return Observable<T>.create { observer -> Disposable in
            Alamofire.request(api.urlString, method: api.method, parameters: api.parameters)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let jsonData):
                        do {
                            guard let jsonData = jsonData as? Data else {
                                observer.onError(APIClientError.emptyResponseError)
                                return
                            }
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                            let data = try jsonDecoder.decode(T.self, from: jsonData)
                            observer.onNext(data)
                        } catch {
                            observer.onError(APIClientError.parseError(error))
                        }
                    case .failure(let error):
                        observer.onError(APIClientError.connectionError(error))
                    }
            }
            return Disposables.create()
        }
    }
}
