//
//  GameViewController.swift
//  Marbles
//
//  Created by ZCW on 2019/5/13.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit

class GameViewController: UIViewController,MapViewDelegate,BallViewDelegate,BoardViewDelegate {
    
    /// 背景图
    private var backImageView: UIImageView!
    /// 内容视图
    private var contentView: UIView!
    /// 地图视图
    private var mapView: MapView!
    /// 小球视图
    private var ballView:BallView!
    /// 跳板视图
    private var boardView:BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        // 初始化背景
        self.backImageView = UIImageView(frame: self.view.bounds)
        self.backImageView.backgroundColor = UIColor.gray
        self.view.addSubview(self.backImageView)
        
        // 设置内容视图的边距
        var contentEdge = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        if #available(iOS 11.0, *) {
            contentEdge = UIEdgeInsets(top: UIApplication.shared.keyWindow!.safeAreaInsets.top + 15, left: 15, bottom: UIApplication.shared.keyWindow!.safeAreaInsets.bottom + 15, right: 15)
        }
        // 初始化内容视图
        self.contentView = UIView(frame: CGRect(x: contentEdge.left, y: contentEdge.top, width: self.view.frame.width - contentEdge.left - contentEdge.right, height: self.view.frame.height - contentEdge.top - contentEdge.bottom))
        self.contentView.backgroundColor = UIColor.white
        self.view.addSubview(self.contentView)
        
        // 初始化小球视图
        self.ballView = BallView(frame: self.contentView.bounds)
        self.ballView.delegate = self
        self.contentView.addSubview(self.ballView)
        
        // 初始化地图
        self.mapView = MapView(frame: self.contentView.bounds)
        self.mapView.delegate = self
        self.contentView.addSubview(self.mapView)
        
        // 初始化跳板
        self.boardView = BoardView(frame: self.contentView.bounds)
        self.boardView.delegate = self
        self.contentView.addSubview(self.boardView)
        
        // 初始化跳板位置
        self.boardView.board.frame = CGRect(x: self.boardView.center.x - 75, y: self.boardView.frame.height - 15, width: 150, height: 15)
        // 初始化小球的位置
        self.ballView.changeBall(location: CGPoint(x: self.boardView.center.x, y: self.boardView.board.frame.minY - self.ballView.ballRadius))
        
        // 加载地图数据
        DispatchQueue.global().async {
            let mapArr = MapManager.share.loadMap()
            if mapArr != nil && mapArr!.count > 0 {
                DispatchQueue.main.async {
                    // 加载第一张
                    self.loadGameView(level: mapArr!.first!)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "提示", message: "地图加载失败", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 界面消失暂停
        self.ballView.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // 加载游戏界面
    func loadGameView(level:MapModel) {
        // 初始化跳板位置
        self.boardView.board.frame = CGRect(x: self.boardView.center.x - 75, y: self.boardView.frame.height - 15, width: 150, height: 15)
        // 初始化小球的位置
        self.ballView.changeBall(location: CGPoint(x: self.boardView.center.x, y: self.boardView.board.frame.minY - self.ballView.ballRadius))
        // 初始化地图
        self.mapView.model = level
    }
    
    // 触摸屏幕游戏开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.ballView.start()
    }
    
    // 游戏结束
    func gameOver(win:Bool) {
        self.ballView.stop()
    }
    
    func mapViewAllBlockDissmiss() {
        // 游戏结束胜利
        self.gameOver(win: true)
    }
    
    // 碰撞检测
    func ballViewCheckCollisionLocation(location: CGPoint, direction: BallDirection) -> Bool {
        // 检查是否与砖块碰撞
        if self.mapView.CheckBlockCollision(point: location) {
            return true
        }
        switch direction {
        case .up:
            // 检测上方
            // 检查是否与地图边界碰撞
            if location.y <= 0 {
                return true
            }
        case .left:
            // 检测左方
            // 检查是否与地图边界碰撞
            if location.x <= 0 {
                return true
            }
        case .right:
            // 检测右方
            // 检查是否与地图边界碰撞
            if location.x >= self.mapView.frame.width {
                return true
            }
        case .down:
            // 检测下方
            // 检测是否与跳板相撞
            if location.x >= self.boardView.board.frame.minX && location.x <= self.boardView.board.frame.maxX && location.y >= self.boardView.board.frame.minY {
                return true
            }
            // 检查是否与地图边界碰撞
            if location.y >= self.mapView.frame.height {
                // 游戏结束失败
                self.gameOver(win: false)
                return true
            }
        default:
            return false
        }
        return false
    }
    
    func boardViewDidMove(newFrame: CGRect) {
        
    }

}
