//
//  ViewController.swift
//  Marbles
//
//  Created by zhang on 16/1/20.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white;
        let view = GameView(frame: self.view.bounds)
        self.view.addSubview(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(_ sender: Any) {
//        self.present(GameViewController(), animated: true, completion: nil)
    }
    
}

