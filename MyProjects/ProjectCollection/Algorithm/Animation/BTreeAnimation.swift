//
//  BTreeAnimation.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 09/09/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit

class BNodeAnimation<T:Comparable>{
    static var t : Int { return 5 }
    var b = UIButton()
    var lines:[CAShapeLayer] = []
    var isLeaf = true
    init() {
        
    }
    
    var children:[BNodeAnimation<T>] = []
    var keys:[T] = []
    
    deinit {
        print("a node(\(keys)) is deleted!")
    }
}

class BTreeAnimation<T:Comparable>{
    var root:BNodeAnimation<T> = BNodeAnimation<T>()
    
    func insert(k:T){
        let x = root
        if x.keys.count == 2*BNodeAnimation<T>.t - 1{
            let s = BNodeAnimation<T>()
            root = s
            s.children.append(x)
            split(n: s, i: 0)
            s.isLeaf = false
            var m = 0
            if k > s.keys[0]{
                m += 1
            }
            insertWithNonfull(n: s.children[m], k: k)
        }else{
            insertWithNonfull(n: x, k: k)
        }
    }
    
    func split(n:BNodeAnimation<T>,i:Int){
        let x = n.children[i]
        let s = BNodeAnimation<T>.t - 1
        let key = x.keys[s]
        let n1 = BNodeAnimation<T>()
        var arr = x.keys[0..<s]
        n1.keys = Array( arr )
        let n2 = BNodeAnimation<T>()
        arr = x.keys[(s+1)...]
        n2.keys = Array(arr)
        if !x.isLeaf{
            n1.isLeaf = false
            var arr2 = x.children[0...s]
            n1.children = Array(arr2)
            arr2 = x.children[(s+1)...]
            n2.children = Array(arr2)
            n2.isLeaf = false
        }
        n.keys.insert(key, at: i)
        n.children.remove(at: i)
        n.children.insert(n2, at: i)
        n.children.insert(n1, at: i)
    }
    
    func insertWithNonfull(n:BNodeAnimation<T>, k:T){
        if n.isLeaf {
            if let (i,_) = n.keys.enumerated().first(where: {(index,key) in key > k}){
                n.keys.insert(k, at: i)
            }else{
                n.keys.append(k)
            }
        }else{
            var j:Int
            if let (i,_) = n.keys.enumerated().first(where: {(index,key) in key > k}){
                j = i
            }else{
                j = n.keys.count
            }
            if n.children[j].keys.count == 2*BNodeAnimation<T>.t - 1{
                split(n: n, i: j)
                var m = j
                if k > n.keys[j]{
                    m += 1
                }
                insertWithNonfull(n: n.children[m], k: k)
            }else{
                insertWithNonfull(n: n.children[j], k: k)
            }
        }
    }
    
    func delete(k:T){
        let x = root
        delete(n: x, k: k)
    }
    
    private func delete(n:BNodeAnimation<T>,k:T){
        if let (i,_) = n.keys.enumerated().first(where: {(index,key) in key >= k}){
            if n.keys[i] == k{
                deleteNodeWithKeyIndex(n: n, i: i)
                return
            }
            let node = transToLeft(n: n, i: i)
            delete(n: node, k: k)
        }else{
            let i = n.keys.count - 1
            let node = transToRight(n: n, i: i)
            delete(n: node, k: k)
        }
    }
    
    
    private func deleteNodeWithKeyIndex(n:BNodeAnimation<T>,i:Int){
        if n.isLeaf{
            n.keys.remove(at: i)
        }else{
            if n.children[i].keys.count > BNodeAnimation<T>.t - 1{
                n.keys[i] = deleteMaxKey(n: n.children[i])
            }else if n.children[i + 1].keys.count > BNodeAnimation<T>.t - 1{
                n.keys[i] = deleteMinKey(n: n.children[i+1])
            }else{
                let node = merge(n: n, i: i)
                deleteNodeWithKeyIndex(n: node, i:(BNodeAnimation<T>.t - 1))
            }
        }
    }
    
    private func merge(n:BNodeAnimation<T>,i:Int)->BNodeAnimation<T>{
        let key = n.keys.remove(at: i)
        let n1 = n.children[i]
        let n2 = n.children.remove(at: i+1)
        n1.keys.append(key)
        for key in n2.keys{
            n1.keys.append(key)
        }
        for child in n2.children{
            n1.children.append(child)
        }
        
        if n === root && n.keys.count == 0{
            root = n1
        }
        return n1
    }
    
    private func transToRight(n:BNodeAnimation<T>,i:Int)->BNodeAnimation<T>{
        let n1 = n.children[i]
        let n2 = n.children[i+1]
        if n2.keys.count > BNodeAnimation<T>.t - 1{
            return n2
        }else{
            if n1.keys.count > BNodeAnimation<T>.t - 1{
                let key = n.keys[i]
                n.keys[i] = n1.keys.removeLast()
                n2.keys.insert(key, at: 0)
                if !n1.isLeaf{
                    let child = n1.children.removeLast()
                    n2.children.insert(child, at: 0)
                }
                return n2
            }else{
                let node = merge(n: n, i: i)
                return node
            }
        }
    }
    
    private func transToLeft(n:BNodeAnimation<T>,i:Int)->BNodeAnimation<T>{
        let n1 = n.children[i]
        let n2 = n.children[i+1]
        if n1.keys.count > BNodeAnimation<T>.t - 1{
            return n1
        }else{
            if n2.keys.count > BNodeAnimation<T>.t - 1{
                let key = n.keys[i]
                if !n2.isLeaf{
                    let child = n2.children.remove(at: 0)
                    n1.children.append(child)
                }
                n.keys[i] = n2.keys.remove(at: 0)
                n1.keys.append(key)
                return n1
            }else{
                let node = merge(n: n, i: i)
                return node
            }
        }
    }
    
    private func deleteMaxKey(n:BNodeAnimation<T>)->T{
        if n.isLeaf{
            return n.keys.removeLast()
        }else{
            let node = transToRight(n: n, i: n.keys.count - 1)
            return deleteMaxKey(n: node)
        }
    }
    
    private func deleteMinKey(n:BNodeAnimation<T>)->T{
        if n.isLeaf{
            return n.keys.remove(at: 0)
        }else{
            let node = transToLeft(n: n, i: 0)
            return deleteMinKey(n: node)
        }
    }
    
    private func deepTraverse(n:BNodeAnimation<T>){
        if n.isLeaf{
            for key in n.keys{
                print(key, terminator:" ")
            }
        }else{
            for i in 0..<n.keys.count{
                deepTraverse(n: n.children[i])
                print(n.keys[i], terminator:" ")
            }
            deepTraverse(n: n.children.last!)
        }
    }
    
    
    func traverse(){
        print("traverse")
        deepTraverse(n: root)
        print("end")
    }
    
    func level()->Int{
        var i = 0
        var x = root
        while !x.isLeaf{
            x = x.children.first!
            i += 1
        }
        return i
    }
    
    
    
}







