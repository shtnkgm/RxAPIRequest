//
//  ViewController.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/28.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import Alamofire
import RxCocoa
import RxSwift
import UIKit

/**
 ### XIBとの紐付け方法
 - UIViewを貼り付け
 - xibでFile's OwnerのClassをViewControllerに設定
 - File's OwnerのOutletsのviewを作成したUIViewと紐付け
 */
final class ViewController: UIViewController {
    @IBOutlet private weak var requestButton: UIButton!

    private let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        requestButton.rx.tap.subscribe(onNext: { [weak self] in
            print("リクエストボタンタップ")
            self?.getUserInfo()
        }).disposed(by: disposeBag)
    }

    func getUserInfo() {
        let urlString = "https://raw.githubusercontent.com/shtnkgm/RxAPIRequest/master/RxAPIRequest/API/user_info_api.json"
        Alamofire.request(urlString, method: .get).responseJSON { response in
            guard let data = response.data else {
                print("データの取得に失敗: \(response.response?.statusCode ?? 0)")
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let userInfo = try jsonDecoder.decode(UserInfo.self, from: data)
                print("データの取得に成功: \(userInfo)")
            } catch {
                print("JSONのデコードに失敗: \(error)")
            }
        }
    }
}
