//
//  GameMap.swift
//  Marbles
//
//  Created by zhang on 16/1/20.
//  Copyright © 2016年 KnightSama. All rights reserved.
//

import UIKit

class GameMap: NSObject {
    
     class func getMapArrayByNumber(number: NSNumber) -> Array<Array<NSNumber>>?{
        switch(number){
        case 0 :
            return [[0,0,0,0,0,0,0],
                    [0,0,0,1,0,0,0],
                    [0,0,1,0,1,0,0],
                    [0,0,1,0,1,0,0],
                    [0,0,0,1,0,0,0]];
        case 1:
            return [[0,0,0,0,0,0,0],
                    [1,1,1,1,1,1,1],
                    [1,1,1,1,1,1,1],
                    [1,1,0,0,0,1,1],
                    [0,0,0,0,0,0,0]];
        default :
            return nil;
        }
    }
}
