//
//  TRBaseController.swift
//  tramp.sina
//
//  Created by tramp on 2018/3/23.
//  Copyright © 2018年 tramp. All rights reserved.
//

import UIKit

class TRBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 1. 初始化UI
        initUi()
    }
}

// MARK: - 初始化 -
extension TRBaseController {
    
    /// 初始化Ui
    private func initUi(){
        // 1. 设置背景色
        view.backgroundColor = UIColor.white
    }
}
