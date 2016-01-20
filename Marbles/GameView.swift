//
//  GameView.swift
//  Marbles
//
//  Created by zhang on 16/1/20.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

import UIKit

//小球半径
let radiu = 10.0
//小球单位时间移动的距离
let length = 4.0
//砖块高度
let blockH = 10

class GameView: UIView ,UIAlertViewDelegate{
    
    //视图的大小
    var width :CGFloat;
    var height :CGFloat;
    //跳板的大小
    var boardX :CGFloat;
    var boardY :CGFloat;
    var boardW :CGFloat;
    var boardH :CGFloat;
    //小球的位置
    var ballX :CGFloat;
    var ballY :CGFloat;
    //小球的方向角
    var ballAngle :CGFloat;
    //定时器
    var timer :NSTimer?;
    //开始按钮
    var startBtn :UIButton;
    //游戏是否开始
    var isStart :Bool;
    //砖块信息
    lazy var blockArr = Array<Array<NSNumber>>();
    //砖块的长度
    var blockW :CGFloat;
    //砖块的数量
    var blockNum :NSInteger;
    //当前游戏关卡
    var gameNum :NSInteger;
    
    override init(frame: CGRect) {
        width = 0
        height = 0
        boardH = 0;
        boardY = 0;
        boardW = 0;
        boardX = 0;
        ballX = 0;
        ballY = 0;
        ballAngle = 0;
        blockW = 0;
        blockNum = 0;
        startBtn = UIButton.init(frame: CGRectMake(0, 0, 100, 50))
        startBtn.backgroundColor = UIColor.grayColor()
        startBtn.setTitle("开 始", forState: UIControlState.Normal)
        isStart = false;
        gameNum = 0;
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor();
        self.addSubview(self.startBtn)
        startBtn.addTarget(self, action: Selector("startButtonPress:"), forControlEvents: UIControlEvents.TouchUpInside)
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("moveBoard:"))
        self.addGestureRecognizer(panGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        width = self.frame.size.width
        height = self.frame.size.height
        self.prepareForGame()
    }
    
    func prepareForGame() {
        boardH = 10;
        boardY = height - boardH;
        boardW = 100;
        boardX = width/2.0 - boardW/2.0;
        
        ballX = width/2.0;
        ballY = boardY - CGFloat(radiu);
        startBtn.hidden = false;
        self.blockArr = GameMap.getMapArrayByNumber(gameNum)!
        startBtn.frame = CGRectMake(width/2.0 - startBtn.frame.size.width/2.0, height/2.0-startBtn.frame.size.height/2.0, startBtn.frame.size.width, startBtn.frame.size.height)
        if ((self.timer) == nil) {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1/60.0, target: self, selector: Selector("reDraw"), userInfo: nil, repeats: true)
        }
    }
    
    func startButtonPress(btn: UIButton) {
        btn.hidden = true;
        isStart = true;
        blockNum = 0;
        for (_,value) in self.blockArr.enumerate(){
            for (_,value) in value.enumerate(){
                if (value.isEqualToNumber(1)) {
                    blockNum++;
                }
            }
        }
        self.gameStart();
    }
    
    func moveBoard(panGesture :UIPanGestureRecognizer) {
        let movePoint = panGesture.translationInView(self)
        if (!isStart) {
            ballX = ballX + movePoint.x;
            if (ballX<=boardW/2) {
                ballX = boardW/2;
            }else if(ballX>=width-boardW/2){
                ballX = width-boardW/2;
            }
        }
        boardX = boardX + movePoint.x;
        if (boardX<=0) {
            boardX=0;
        }else if(boardX>=width-boardW){
            boardX = width-boardW;
        }
        panGesture.setTranslation(CGPointZero, inView: self)
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        // 画底面的跳板
        let board = UIBezierPath(rect: CGRectMake(boardX, boardY, boardW, boardH))
        UIColor.grayColor().setFill()
        board.fill()
        
        //画小球
        let ball = UIBezierPath(arcCenter: CGPointMake(ballX, ballY), radius: CGFloat(radiu), startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: true)
        UIColor.redColor().setFill()
        ball.fill()
        
        //画砖块
        var row = 0;
        var list = 0;
        blockW = width/CGFloat(self.blockArr[0].count)
        for (_,value) in self.blockArr.enumerate(){
            list = 0;
            for (_,value) in value.enumerate(){
                if (value.isEqualToNumber(1)) {
                    let block = UIBezierPath(rect: CGRectMake(CGFloat(list)*blockW, CGFloat(row)*CGFloat(blockH), blockW, CGFloat(blockH)))
                    UIColor.grayColor().setFill()
                    UIColor.blackColor().setStroke()
                    block.fill()
                    block.stroke()
                }
                list++
            }
            row++
        }
    }
    
    func gameStart() {
        ballAngle = CGFloat(M_PI_4)
    }
    
    //重新绘制
    func reDraw() {
        //计算小球下一个位置
        if (isStart) {
            ballX = ballX + CGFloat(length*sin(Double(ballAngle)));
            ballY = ballY - CGFloat(length*cos(Double(ballAngle)));
        }
        //重绘视图
        self.setNeedsDisplay();
        //检测
        if (isStart) {
            self.gameCheck()
        }
    }
    
    //游戏检测
    func gameCheck() {
        self.boardCheck()
        self.blockCheck()
        self.GameEndCheck()
    }
    
    //边界检测
    func boardCheck() {
        //上侧
        if (ballY-CGFloat(radiu)<=0) {
            ballAngle = -(CGFloat(M_PI) + ballAngle);
            return;
        }
        //左侧和右侧
        if (ballX-CGFloat(radiu)<=0||ballX+CGFloat(radiu)>=width) {
            ballAngle = -ballAngle;
            return;
        }
        //下侧
        if (ballY+CGFloat(radiu)>=boardY&&ballX>=boardX&&ballX<=boardX+boardW){
            //在板上
            ballAngle = CGFloat(M_PI) - ballAngle;
            return;
        }else if(ballY+CGFloat(radiu)>=height){
            //不在板上
            self.gameOver()
        }
    }
    
    //砖块检测
    func blockCheck() {
        var checkP = CGPointZero;
        //向上
        checkP = CGPointMake(ballX, ballY-CGFloat(radiu));
        if (self.isNeedBounce(checkP)) {
            ballAngle = -(CGFloat(M_PI) + ballAngle);
            return;
        }
        //向下
        checkP = CGPointMake(ballX, ballY+CGFloat(radiu));
        if (self.isNeedBounce(checkP)) {
            ballAngle = CGFloat(M_PI) - ballAngle;
            return;
        }
        //向左
        checkP = CGPointMake(ballX-CGFloat(radiu), ballY);
        if (self.isNeedBounce(checkP)) {
            ballAngle = -ballAngle;
            return;
        }
        //向右
        checkP = CGPointMake(ballX+CGFloat(radiu), ballY);
        if (self.isNeedBounce(checkP)) {
            ballAngle = -ballAngle;
            return;
        }
    }
    
    //胜利检测
    func GameEndCheck() {
        if (isStart && blockNum==0) {
            self.timer!.invalidate()
            self.timer = nil;
            isStart = false;
            var message = "进入下一关";
            gameNum++;
            if (GameMap.getMapArrayByNumber(gameNum)==nil) {
                gameNum=0;
                message = "从第一关开始";
            }
            let alert = UIAlertView(title: "提示", message: "你赢了", delegate: self, cancelButtonTitle:"重新开始", otherButtonTitles:message)
            alert.tag = 2;
            alert.show()
        }
    }
    
    //是否需要反弹
    func isNeedBounce(checkP :CGPoint) ->Bool{
        let row = NSInteger(checkP.y/CGFloat(blockH))
        let list = NSInteger(checkP.x/CGFloat(blockW))
        if (row+1>self.blockArr.count) {
            return false
        }
        if (list>=self.blockArr[row].count) {
            return false
        }
        let number = self.blockArr[row][list]
        if (number.isEqualToNumber(1)) {
            var tmpArr = self.blockArr[row]
            tmpArr[list] = 0
            blockNum--;
            self.blockArr[row] = tmpArr
            return true;
        }
        if (number.isEqualToNumber(2)) {
            return true
        }
        return false
    }
    
    //游戏结束
    func gameOver() {
        self.timer!.invalidate()
        self.timer = nil;
        isStart = false;
        let alert = UIAlertView(title: "提示", message: "你输了", delegate: self, cancelButtonTitle: "重新开始")
        alert.tag = 1;
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.prepareForGame()
    }
    
    
}