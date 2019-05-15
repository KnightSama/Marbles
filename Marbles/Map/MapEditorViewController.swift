//
//  MapEditorViewController.swift
//  Marbles
//
//  Created by ZCW on 2019/5/13.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit

class MapEditorViewController: UIViewController {
    
    /// 背景图
    private var backImageView: UIImageView!
    /// 内容视图
    private var contentView: UIView!
    /// 地图编辑
    private var mapEditorView: MapEditorView!

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
    
        // 初始化地图
        self.mapEditorView = MapEditorView(rowNum: 10, colNum: 20, height: 0, frame: self.contentView.bounds)
        self.contentView.addSubview(self.mapEditorView)
    }
    
    

}
