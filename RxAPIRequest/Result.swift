//
//  Result.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/30.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Foundation

enum Result<T: Codable> {
    case success(T)
    case failure(Error)
}
