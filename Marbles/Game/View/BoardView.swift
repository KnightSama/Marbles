//
//  BoardView.swift
//  Marbles
//
//  Created by ZCW on 2019/5/10.
//  Copyright © 2019年 KnightSama. All rights reserved.
//

import UIKit

protocol BoardViewDelegate {
    /// 当板子移动时调用方法
    func boardViewDidMove(newFrame:CGRect)
}

class BoardView: UIView {
    /// 代理
    var delegate : BoardViewDelegate?
    /// 跳板视图
    var board = CALayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.board.backgroundColor = UIColor.gray.cgColor
        self.layer.addSublayer(self.board)
        self.backgroundColor = UIColor.clear;
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(GameView.moveBoard(panGesture:)))
        self.addGestureRecognizer(panGesture)
    }

    @objc func moveBoard(panGesture :UIPanGestureRecognizer) {
        let movePoint = panGesture.translation(in: self)
        self.board.frame.origin.x = self.board.frame.minX + movePoint.x;
        if self.board.frame.minX <= 0 {
            self.board.frame.origin.x = 0
        }else if self.board.frame.maxX >= self.frame.width {
            self.board.frame.origin.x = self.frame.width - self.board.frame.width;
        }
        panGesture.setTranslation(CGPoint.zero, in: self)
        
        if let delegate = self.delegate {
            delegate.boardViewDidMove(newFrame: self.board.frame)
        }
    }
}
