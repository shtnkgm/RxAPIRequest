//
//  UserInfo.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/29.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let identifier: String
    let firstName: String
    let lastName: String
    let imageUrl: String
}
