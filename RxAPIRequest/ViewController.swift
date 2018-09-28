//
//  ViewController.swift
//  RxAPIRequest
//
//  Created by Shota Nakagami on 2018/09/28.
//  Copyright © 2018年 Shota Nakagami. All rights reserved.
//

import UIKit

/**
 ### XIBとの紐付け方法
 - UIViewを貼り付け
 - xibでFile's OwnerのClassをViewControllerに設定
 - File's OwnerのOutletsのviewを作成したUIViewと紐付け
 */
final class ViewController: UIViewController {
    @IBOutlet private weak var requestButton: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

