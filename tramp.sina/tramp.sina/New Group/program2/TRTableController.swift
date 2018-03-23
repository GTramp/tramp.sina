//
//  TRTableController.swift
//  tramp.sina
//
//  Created by tramp on 2018/3/23.
//  Copyright © 2018年 tramp. All rights reserved.
//

import UIKit
import SnapKit

class TRTableController: TRBaseController {
    // MARK: - 生命周期 -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 1. 初始化Ui
        initUi()
        // 2. 加载数据
        loadData()
        // 3. 添加手势
        addGesture()
    }
    
    // MARK: - 属性 -
    
    private var dataSource: Array<String>?
    
    private lazy var collisionArea: UIView = {
        let view = UIView.init()
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var table: UITableView = {
        let table = UITableView.init(frame: CGRect.zero, style: UITableViewStyle.plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        table.backgroundColor = UIColor.darkGray
        return table
    }()
    
    private var currentCell:UITableViewCell?
    private var startPoint: CGPoint?
    private var lastTransfrom: CGAffineTransform?
}

// MARK: - 方法 -
extension TRTableController {
    
    /// 添加长按手势
    private func addGesture() {
        // 1. 创建手势
        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressInTableAction(_:)))
        // 2. 添加手势
        table.addGestureRecognizer(gesture)
        
    }
    
    /// 长按手势响应方法
    ///
    /// - Parameter sender: 手势
    @objc private func longPressInTableAction(_ sender: UILongPressGestureRecognizer) {
        // 1. 获取当前坐标
        let point = sender.location(in: sender.view)
        
        
        if sender.state == UIGestureRecognizerState.began {
            // 2. 获取当前indexpath
            let indexPath = table.indexPathForRow(at: point)
            guard let currentIndexPath = indexPath  else {
                return
            }
            
            // 3. 获取当前cell
            currentCell = table.cellForRow(at: currentIndexPath)
            // 4. 展示碰撞区
            UIView.animate(withDuration: 0.25, animations: {
                self.collisionArea.transform = CGAffineTransform.init(translationX: 0, y: -80)
            })
            // 5. 记录起始点
            startPoint = point
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled || sender.state == UIGestureRecognizerState.failed {
            
            let window = UIApplication.shared.keyWindow
            if let cellReact = window?.convert((currentCell?.frame)!, from: table) ,
                let collisionReact = window?.convert(collisionArea.frame, from: view) {
                if cellReact.intersects(collisionReact) {
                    let controller = TRContentController.init()
                    controller.text = currentCell?.textLabel?.text
                    navigationController?.pushViewController(controller, animated: true)
                }
            }
            
            
            UIView.animate(withDuration: 0.25, animations: {
                self.collisionArea.transform = CGAffineTransform.identity
            })
            currentCell?.transform = CGAffineTransform.identity
        } else if sender.state == UIGestureRecognizerState.changed {
            
            if point.x >= UIScreen.main.bounds.width - 16 || point.x <= 16  || point.y <= 64 || point.y >= UIScreen.main.bounds.height{
                if let transform = lastTransfrom {
                    currentCell?.transform = transform
                }
                return
            }
            
            let detal_x = point.x - (startPoint?.x)!
            let detal_y = point.y - (startPoint?.y)!
            currentCell?.transform = CGAffineTransform.init(translationX:detal_x, y: detal_y)
            lastTransfrom = currentCell?.transform
        }
        
    }
}

// MARK: - UITableViewDelegate / UITableViewDataSource -
extension TRTableController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.textLabel?.text = dataSource?[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.insert
    }
}

// MARK: - 初始化 -
extension TRTableController {
    /// 加载数据
    private func loadData(){
        if dataSource == nil {
            dataSource = Array.init()
        }
        
        DispatchQueue.global().async {
            for index in 0..<20 {
                self.dataSource?.append("row => \(index)")
            }
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    
    /// 初始化Ui
    private func initUi(){
        
        // 1. table
        view.addSubview(table)
        table.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        // 2. 碰撞检测
        view.addSubview(collisionArea)
        collisionArea.snp.makeConstraints { (maker) in
            maker.width.equalTo(240)
            maker.height.equalTo(80)
            maker.left.equalToSuperview()
            maker.bottom.equalToSuperview().offset(80)
        }
    }
}
