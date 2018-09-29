//
//  ViewController.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/28.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

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

    private let userInfoModel: UserInfoModel
    private let repositoryListModel: RepositoryListModel
    private let disposeBag = DisposeBag()
    private var repositoryList: RepositoryList?

    init(userInfoModel: UserInfoModel = UserInfoModel(),
         repositoryListModel: RepositoryListModel = RepositoryListModel()) {
        self.userInfoModel = userInfoModel
        self.repositoryListModel = repositoryListModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        requestButton.rx.tap.subscribe(onNext: {

        }).disposed(by: disposeBag)
    }

    @IBAction private func requestButtonTapped(_ sender: UIButton) {
        print("リクエストボタンタップ")
        userInfoModel.request { [weak self] result in
            switch result {
            case .success(let userInfo):
                print("UserInfoリクエスト成功")
                self?.repositoryListModel.request(userIdentifier: userInfo.identifier) { result in
                    switch result {
                    case .success(let repositoryList):
                        print("RepositoryListリクエスト成功")
                        self?.repositoryList = repositoryList
                    case .failure(let error):
                        print("\(error)")
                    }
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}
