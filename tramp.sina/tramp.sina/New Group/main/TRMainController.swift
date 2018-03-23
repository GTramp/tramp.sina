//
//  TRMainController.swift
//  tramp.sina
//
//  Created by tramp on 2018/3/23.
//  Copyright © 2018年 tramp. All rights reserved.
//

import UIKit
import SnapKit

class TRMainController: TRBaseController {
// MARK: - 生命周期 -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 1. 初始化UI
        initUi()
    }
    
    
    // MAKR: - 属性 -
    private lazy var toolBarButton: UIButton = {
        let buton = UIButton.init(type: UIButtonType.custom)
        buton.setTitle("自定义ToolBar", for: UIControlState.normal)
        buton.backgroundColor = UIColor.orange
        buton.addTarget(self, action: #selector(buttonDidClickedAction(_:)), for: UIControlEvents.touchUpInside)
        buton.tag = 10003
        return buton
    }()
    
    private lazy var tableButton: UIButton = {
        let buton = UIButton.init(type: UIButtonType.custom)
        buton.setTitle("列表拖动", for: UIControlState.normal)
        buton.backgroundColor = UIColor.orange
        buton.addTarget(self, action: #selector(buttonDidClickedAction(_:)), for: UIControlEvents.touchUpInside)
        buton.tag = 10002
        return buton
    }()
    
    private lazy var likeButton: UIButton = {
        let buton = UIButton.init(type: UIButtonType.custom)
        buton.setTitle("点赞效果", for: UIControlState.normal)
        buton.backgroundColor = UIColor.orange
        buton.addTarget(self, action: #selector(buttonDidClickedAction(_:)), for: UIControlEvents.touchUpInside)
        buton.tag = 10001
        return buton
    }()
}

// MARK: - 响应方法 -
extension TRMainController {
    @objc private func buttonDidClickedAction(_ sender: UIButton) {
        switch sender.tag {
        case 10001:
            navigationController?.pushViewController(TRLikeController(), animated: true)
            break
        case 10002:
            navigationController?.pushViewController(TRTableController(), animated: true)
            break
        case 10003:
            navigationController?.pushViewController(TRToolBarController(), animated: true)
            break
        default:
            break
        }
        
    }
}

// MARK: - 初始化 -
extension TRMainController {
    /// 初始化Ui
    private func initUi(){
        // 0. title
        navigationItem.title = "编程题"
        
        // 1. 点赞效果
        view.addSubview(likeButton)
        likeButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-70)
            maker.width.equalTo(view.bounds.width * 0.8)
            maker.height.equalTo(48)
        }
        
        // 2. 列表拖动
        view.addSubview(tableButton)
        tableButton.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.size.equalTo(likeButton)
        }
        
        // 3. 自定义toolbar
        view.addSubview(toolBarButton)
        toolBarButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(70)
            maker.size.equalTo(likeButton)
        }
    }
}
