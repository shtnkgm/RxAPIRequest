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
    @IBOutlet private weak var rxRequestButton: UIButton!
    @IBOutlet private weak var label: UILabel!

    private let userInfoModel: UserInfoModel
    private let repositoryListModel: RepositoryListModel
    private let disposeBag = DisposeBag()

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

        rxRequestButton.rx.tap
            .do(onNext: { _ in
                self.label.text = "loading..."
                print("Rxリクエストボタンタップ")
            })
            .flatMapLatest { self.userInfoModel.rxRequest() }
            .do(onNext: { _ in print("UserInfoリクエスト成功") })
            .flatMap { self.repositoryListModel.rxRequest(userIdentifier: $0.identifier) }
            .do(onNext: { _ in print("RepositoryListリクエスト成功") })
            .do(onError: { print($0) })
            .map { $0.map { $0.title }.joined(separator: "\n") }
            .bind(to: self.label.rx.text)
            .disposed(by: disposeBag)
    }

    @IBAction private func requestButtonTapped(_ sender: UIButton) {
        print("リクエストボタンタップ")
        label.text = "loading..."
        getUserInfo()
    }

    private func getUserInfo() {
        userInfoModel.request { [weak self] result in
            switch result {
            case .success(let userInfo):
                print("UserInfoリクエスト成功")
                self?.repositoryListModel.request(userIdentifier: userInfo.identifier) { result in
                    switch result {
                    case .success(let repositoryList):
                        print("RepositoryListリクエスト成功")
                        self?.label.text = repositoryList.map { $0.title }.joined(separator: "\n")
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
