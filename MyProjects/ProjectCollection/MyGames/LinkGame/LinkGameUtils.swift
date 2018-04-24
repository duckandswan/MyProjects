//
//  LinkGameUtils.swift
//  LinkGame
//
//  Created by bob song on 16/11/14.
//  Copyright © 2016年 finding. All rights reserved.
//

import Foundation
class LinkGameUtils {
    
    class func generate(withSize size: Int) -> [String] {
        assert(size % 2 == 0, "size必须为偶数")
        var link_N:[String] = []
        let t = dic[category]!
        for i in t.0...t.1{
            let u = UnicodeScalar(i)!
            let c = String(describing: u)
            link_N.append(c)
        }
        link_N.random()
        
        var a = [Int](repeating: 0, count: size*size)
        for i in 0..<size * size / 2 {
            a[i] = i
            a[size * size / 2 + i] = i
        }
        
        a.random()

        var arr = [String]()
        for i in 0..<size * size {
            arr.append(link_N[a[i] % (size * size / 4)])
        }

        return arr
    }
    
    static var dic = [ "animal" : (0x1F400,0x1F43F) ]
    static var category = "animal"
}

extension Array {
    mutating func random(){
        for i in 0..<self.count {
            let j = Int(arc4random()) % (self.count - i) + i
            let h = self[i]
            self[i] = self[j]
            self[j] = h
        }
    }
}
