//
//  BTree.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 09/09/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit

class BNode<T:Comparable>{
    static var t : Int { return 2 }
    var b = UIButton()
    var lines:[CAShapeLayer] = []
    var isLeaf = true
    init() {
        
    }
    
    var children:[BNode<T>] = []
    var keys:[T] = []
    
    deinit {
        print("a node(\(keys)) is deleted!")
    }
}

class BTree<T:Comparable>{
    var root:BNode<T> = BNode<T>()
    
    func insert(k:T){
        let x = root
        if x.keys.count == 2*BNode<T>.t - 1{
            let s = BNode<T>()
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
    
    func split(n:BNode<T>,i:Int){
        let x = n.children[i]
        let s = BNode<T>.t - 1
        let key = x.keys[s]
        let n1 = BNode<T>()
        var arr = x.keys[0..<s]
        n1.keys = Array( arr )
        let n2 = BNode<T>()
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
    
    func insertWithNonfull(n:BNode<T>, k:T){
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
            if n.children[j].keys.count == 2*BNode<T>.t - 1{
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
    

    
    
//    func delete(n:BNode<T>,k:T){
//        var childIndex:Int
//        if let (j,_) = n.keys.enumerated().first(where: {(index,key) in key >= k}){
//            childIndex = j
//            if n.keys[childIndex] == k{
//                deleteNodeWithKeyIndex(n: n, i: childIndex)
//                return
//            }
//        }else{
//            childIndex = n.children.count
//        }
//
//        if n.children[childIndex].keys.count > BNode<T>.t - 1{
//            delete(n: n.children[childIndex], k: k)
//        }else{
//            var keyIndex:Int
//            var brotherIndex:Int
//            if childIndex != n.children.count{
//                brotherIndex = childIndex + 1
//                keyIndex = childIndex
//                let brother = n.children[brotherIndex]
//                if brother.keys.count > BNode<T>.t - 1 {
//                    transToLeft(n: n, i: keyIndex)
//                }else{
//                    merge(n: n, i: keyIndex)
//                }
//                delete(n: n.children[keyIndex], k: k)
//            }else{
//                brotherIndex = childIndex - 1
//                keyIndex = brotherIndex
//                let brother = n.children[brotherIndex]
//                if brother.keys.count > BNode<T>.t - 1 {
//                    transToRight(n: n, i: keyIndex)
//                    delete(n: n.children[keyIndex + 1], k: k)
//                }else{
//                    merge(n: n, i: keyIndex)
//                    delete(n: n.children[keyIndex], k: k)
//                }
//            }
//        }
//    }
    
    func delete(k:T){
        let x = root
        delete(n: x, k: k)
    }
    
    private func delete(n:BNode<T>,k:T){
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

    
    private func deleteNodeWithKeyIndex(n:BNode<T>,i:Int){
        if n.isLeaf{
            n.keys.remove(at: i)
        }else{
            if n.children[i].keys.count > BNode<T>.t - 1{
                n.keys[i] = deleteMaxKey(n: n.children[i])
            }else if n.children[i + 1].keys.count > BNode<T>.t - 1{
                n.keys[i] = deleteMinKey(n: n.children[i+1])
            }else{
                let node = merge(n: n, i: i)
                deleteNodeWithKeyIndex(n: node, i:(BNode<T>.t - 1))
            }
        }
    }
    
    private func merge(n:BNode<T>,i:Int)->BNode<T>{
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
    
    private func transToRight(n:BNode<T>,i:Int)->BNode<T>{
        let n1 = n.children[i]
        let n2 = n.children[i+1]
        if n2.keys.count > BNode<T>.t - 1{
            return n2
        }else{
            if n1.keys.count > BNode<T>.t - 1{
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
    
    private func transToLeft(n:BNode<T>,i:Int)->BNode<T>{
        let n1 = n.children[i]
        let n2 = n.children[i+1]
        if n1.keys.count > BNode<T>.t - 1{
            return n1
        }else{
            if n2.keys.count > BNode<T>.t - 1{
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
    
    private func deleteMaxKey(n:BNode<T>)->T{
        if n.isLeaf{
            return n.keys.removeLast()
        }else{
            let node = transToRight(n: n, i: n.keys.count - 1)
            return deleteMaxKey(n: node)
        }
    }
    
    private func deleteMinKey(n:BNode<T>)->T{
        if n.isLeaf{
            return n.keys.remove(at: 0)
        }else{
            let node = transToLeft(n: n, i: 0)
            return deleteMinKey(n: node)
        }
    }



    
//    func transToRight(n:BNode<T>,i:Int){
//        let n1 = n.children[i]
//        let n2 = n.children[i+1]
//        let key = n.keys[i]
//        let child = n1.children.removeLast()
//        n.keys[i] = n1.keys.removeLast()
//        n2.keys.insert(key, at: 0)
//        n2.children.insert(child, at: 0)
//    }
//
//    func transToLeft(n:BNode<T>,i:Int){
//        let n1 = n.children[i]
//        let n2 = n.children[i+1]
//        let key = n2.keys[0]
//        let child = n2.children.remove(at: 0)
//        n.keys[i] = n2.keys.remove(at: 0)
//        n1.keys.append(key)
//        n1.children.append(child)
//    }
    
//    func deleteMaxKey(n:BNode<T>)->T{
//        if n.isLeaf{
//            return n.keys.removeLast()
//        }else{
//            let lastChild = n.children.last!
//            if lastChild.keys.count > BNode<T>.t - 1{
//                return deleteMaxKey(n: n.children.last!)
//            }else{
//                let secondLastChild = n.children[n.children.count - 2]
//                if secondLastChild.keys.count > BNode<T>.t - 1{
//                    let key = n.keys.last!
//                    let child = secondLastChild.children.removeLast()
//                    n.keys[n.keys.count - 1] = secondLastChild.keys.removeLast()
//                    lastChild.keys.insert(key, at: 0)
//                    lastChild.children.insert(child, at: 0)
//                    return deleteMaxKey(n: lastChild)
//                }else{
//                    merge(n: n, i: n.keys.count - 1)
//                    return deleteMaxKey(n: n.children.last!)
//                }
//            }
//        }
//    }
    
//    func deleteMinKey(n:BNode<T>)->T{
//        if n.isLeaf{
//            return n.keys.remove(at: 0)
//        }else{
//            let firstChild = n.children.first!
//            if firstChild.keys.count > BNode<T>.t - 1{
//                return deleteMinKey(n: n.children.first!)
//            }else{
//                let secondFirstChild = n.children[1]
//                if secondFirstChild.keys.count > BNode<T>.t - 1{
//                    let key = n.keys.first!
//                    let child = secondFirstChild.children.remove(at: 0)
//                    n.keys[0] = secondFirstChild.keys.remove(at: 0)
//                    firstChild.keys.append(key)
//                    firstChild.children.append(child)
//                    return deleteMinKey(n: firstChild)
//                }else{
//                    merge(n: n, i: 0)
//                    return deleteMinKey(n: n.children.first!)
//                }
//            }
//        }
//    }
    
    private func deepTraverse(n:BNode<T>){
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

    }






