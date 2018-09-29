//
//  RepositoryList.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/29.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Foundation

struct RepositoryList: Codable {
    let repositories: [Repository]
}

extension RepositoryList {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        repositories = try container.decode([Repository].self)
    }
}

extension RepositoryList: Collection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return repositories.count }

    public subscript (index: Int) -> Repository {
        return repositories[index]
    }

    public func index(after index: Index) -> Int {
        return index + 1
    }
}
