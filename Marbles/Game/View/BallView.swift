//
//  BallView.swift
//  Marbles
//
//  Created by ZCW on 2019/2/25.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit

enum BallDirection {
    case up,down,left,right,none
    /// 翻转
    mutating func reversal() {
        switch self {
        case .down:
            self = .up
        case .up:
            self = .down
        case .left:
            self = .right
        case .right:
            self = .left
        default:
            self = .none
        }
    }
}

protocol BallViewDelegate : AnyObject {
    /// 检查指定的点是否在指定方向存在碰撞
    func ballViewCheckCollisionLocation(location:CGPoint,direction:BallDirection) -> Bool;
}

class BallView: UIView {
    /// 代理
    weak var delegate : BallViewDelegate?
    /// π
    let pi = CGFloat(Double.pi)
    /// 球的半径
    var ballRadius : CGFloat = 10.0
    /// 球的中心点位置
    var ballLocation = CGPoint.zero
    /// 球运动的角度
    private var ballRunAngle : CGFloat = CGFloat(Double.pi) / 4.0
    /// 小球的横向运动方向
    private var ballHorizontalDirection : BallDirection = .right
    /// 小球的纵向运动方向
    private var ballVerticalDirection : BallDirection = .up
    /// 小球运动的速度(每次移动的距离)
    var ballSpeed: CGFloat = 4.0
    /// 当前的运动状态
    var isRun : Bool = false
    /// 定时器
    var displayLink :CADisplayLink?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    /// 开始移动小球
    func start() {
        if isRun {
            return
        }
        isRun = true
        self.displayLink = self.displayLink ?? CADisplayLink.init(target: self, selector: #selector(reloadView))
        self.displayLink?.add(to: .current, forMode: .common)
    }
    
    /// 停止移动小球
    func stop() {
        if !isRun {
            return
        }
        isRun = false
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
    
    /// 暂停移动小球
    func pause() {
        if !isRun {
            return
        }
        self.displayLink?.isPaused = true
    }
    
    /// 恢复小球移动
    func resume() {
        if !isRun {
            return
        }
        self.displayLink?.isPaused = false
    }
    
    /// 更改小球的当前位置
    func changeBall(location:CGPoint) {
        self.ballLocation = location
        self.setNeedsDisplay()
    }
    
    /// 设置小球的运行方向
    func changeBall(runAngle:CGFloat) {
        self.ballRunAngle = runAngle
        // 将角度换算到 0 - 2π 之间
        while self.ballRunAngle > 2 * pi {
            self.ballRunAngle = self.ballRunAngle - 2 * pi
        }
        while self.ballRunAngle < 0 {
            self.ballRunAngle = self.ballRunAngle + 2 * pi
        }
        // 设置运行方向
        if self.ballRunAngle < pi / 2.0 && self.ballRunAngle > pi / 2.0 * 3.0  {
            self.ballVerticalDirection = .up
        } else {
            self.ballVerticalDirection = .down
        }
        
        if self.ballRunAngle > 0 && self.ballRunAngle < pi {
            self.ballHorizontalDirection = .right
        } else {
            self.ballHorizontalDirection = .left
        }
    }
    
    /// 计算刷新视图
    @objc func reloadView() {
        // 计算下一时刻小球的位置
        self.ballLocation.x = self.ballLocation.x + (ballSpeed * sin(self.ballRunAngle));
        self.ballLocation.y = self.ballLocation.y - (ballSpeed * cos(self.ballRunAngle));
        
        // 刷新视图
        self.setNeedsDisplay()
        
        // 反弹检查
        if let delegate = self.delegate {
            
            // 检查上方的碰撞
            if self.ballVerticalDirection == .up &&
                delegate.ballViewCheckCollisionLocation(location: CGPoint(x:self.ballLocation.x,y:(self.ballLocation.y - self.ballRadius)), direction: BallDirection.up) {
                // 变更方向
                self.ballRunAngle = -(pi + self.ballRunAngle)
                self.ballVerticalDirection.reversal()
                return;
            }
            // 检查下方的碰撞
            if self.ballVerticalDirection == .down &&
                delegate.ballViewCheckCollisionLocation(location: CGPoint(x:self.ballLocation.x,y:(self.ballLocation.y + self.ballRadius)), direction: BallDirection.down) {
                // 变更方向
                self.ballRunAngle = pi - self.ballRunAngle
                self.ballVerticalDirection.reversal()
                return;
            }
            // 检查左方的碰撞
            if self.ballHorizontalDirection == .left &&
                delegate.ballViewCheckCollisionLocation(location: CGPoint(x:(self.ballLocation.x - self.ballRadius),y:self.ballLocation.y), direction: BallDirection.left) {
                // 变更方向
                self.ballRunAngle = -self.ballRunAngle
                self.ballHorizontalDirection.reversal()
                return;
            }
            // 检查右方的碰撞
            if self.ballHorizontalDirection == .right &&
                delegate.ballViewCheckCollisionLocation(location: CGPoint(x:(self.ballLocation.x + self.ballRadius),y:self.ballLocation.y), direction: BallDirection.right) {
                // 变更方向
                self.ballRunAngle = -self.ballRunAngle;
                self.ballHorizontalDirection.reversal()
                return;
            }
        }
    }
    
    /// 绘图
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //画小球
        let ball = UIBezierPath(arcCenter: self.ballLocation, radius: self.ballRadius, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
        UIColor.red.setFill()
        ball.fill()
    }

}
