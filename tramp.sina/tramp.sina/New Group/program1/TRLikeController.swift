//
//  TRLikeController.swift
//  tramp.sina
//
//  Created by tramp on 2018/3/23.
//  Copyright © 2018年 tramp. All rights reserved.
//

import UIKit



class TRLikeController: TRBaseController {
    // MARK: - 生命周期 -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // 1. 初始化Ui
        initUi()
    }
    
    // MARK: - 属性 -
    private lazy var tipLabel:UILabel = {
        let label = UILabel.init()
        label.text = "请猛戳"
        label.font = UIFont.systemFont(ofSize: 28)
        return label
    }()
    
    private lazy var line: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    private let origin_x: CGFloat = UIScreen.main.bounds.width - 100
    private let origin_y: CGFloat = UIScreen.main.bounds.height - 32
    private let duration: CGFloat = 2.5
    
}


// MARK: - 响应方法 -
extension TRLikeController : CAAnimationDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1. 点赞
        like()
    }
    
    /// 点赞
    private func like(){
        let name = String.init(format: "%03d", arc4random() % 34 + 1)
        let imageView = TRImageView.init(image: UIImage.init(named: name))
        imageView.layer.add(animationGroup(), forKey: "tramp")
        view.addSubview(imageView)
    }
    
    /// 动画组
    ///
    /// - Returns: CAAnimationGroup
    private func animationGroup()-> CAAnimationGroup {
        let group = CAAnimationGroup.init()
        group.duration = CFTimeInterval(duration);
        group.repeatCount = 1;
        group.animations = [positionAnimation(),alphaAnimation()]
        group.delegate = self
        
        return group
    }
    
    /// 渐隐效果
    ///
    /// - Returns: CABasicAnimation
    private func alphaAnimation() -> CABasicAnimation {
        // 1. 创建动画
        let animation = CABasicAnimation.init(keyPath: "opacity")
        
        // 2. 动画选项设定
        animation.duration = CFTimeInterval(duration)
        animation.isRemovedOnCompletion = false
        
        animation.fromValue = 1.0
        animation.toValue = 0
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        animation.beginTime = 0.1
        
        return animation
    }
    
    /// CAKeyframeAnimation
    ///
    /// - Returns: CAKeyframeAnimation
    private func positionAnimation()-> CAKeyframeAnimation {
        // 1. 创建贝塞尔曲线
        let path = UIBezierPath.init()
        // 2. 移动到初始位置
        path.move(to: CGPoint.init(x: origin_x, y: origin_y))
        // 3. 绘制
        var detal_x: CGFloat = UIScreen.main.bounds.width - CGFloat(arc4random() % 100 + 50)
        var control_x: CGFloat = UIScreen.main.bounds.width - CGFloat(arc4random() % 100 + 75)
        var detal_y: CGFloat = UIScreen.main.bounds.height
        
        let spring_x:CGFloat  = 50
        let spring_min_x:CGFloat = spring_x * 0.5
        
        // 绘制路径 方法
        func change(){
            detal_x > origin_x ? (detal_x = origin_x - spring_x) : (detal_x = origin_x + spring_x)
            detal_x < origin_x ? (detal_x = origin_x + spring_x) : (detal_x = origin_x - spring_x)
            
            control_x > control_x ? (control_x = origin_x - spring_min_x) : (control_x = control_x + spring_min_x)
            control_x < control_x ? (control_x = origin_x + spring_min_x) : (control_x = control_x - spring_min_x)
            
            detal_y  = detal_y - 100
            path.addQuadCurve(to: CGPoint.init(x: detal_x, y: detal_y),
                              controlPoint: CGPoint.init(x: control_x, y: detal_y + 50))
        }
        
        // 5 次绘制
        change()
        change()
        change()
        change()
        change()
        
        
        let animation = CAKeyframeAnimation.init()
        animation.keyPath = "position"
        animation.path = path.cgPath
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = CFTimeInterval(duration)
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        
        return animation
    }
    
    
    /// 动画结束
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        for item in view.subviews {
            if item.isKind(of: TRImageView.self) {
                item.removeFromSuperview()
                return
            }
        }
    }
}


// MARK: - 初始化 -
extension TRLikeController {
    /// 初始化Ui
    private func initUi(){
        // 0. title
        navigationItem.title = "点赞效果"
        // 1. 提示
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        
        // 2. 辅助线
        view.addSubview(line)
        line.snp.makeConstraints { (maker) in
            maker.left.equalTo(origin_x)
            maker.bottom.top.equalToSuperview()
            maker.width.equalTo(1)
        }
    }
    
}
