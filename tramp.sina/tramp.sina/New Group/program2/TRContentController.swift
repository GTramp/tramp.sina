//
//  TRContentController.swift
//  tramp.sina
//
//  Created by tramp on 2018/3/23.
//  Copyright © 2018年 tramp. All rights reserved.
//

import UIKit

class TRContentController: TRBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
    }

    var text: String? {
        didSet {
            label.text = text
        }
    }

    private lazy var label: UILabel = {
        let label = UILabel.init()
        return label
    }()
    
    
}
