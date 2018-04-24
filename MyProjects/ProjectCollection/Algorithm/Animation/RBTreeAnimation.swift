//
//  RBTree.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 30/03/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit

class RBNodeAnimation<T:Comparable>{
    let element:T
    var b = UIButton()
    var leftLine = CAShapeLayer()
    var rightLine = CAShapeLayer()
    var isBlack = true
    init(element e:T,isBlack bool:Bool = true) {
        element = e
        isBlack = bool
    }
    
    var left:RBNodeAnimation<T>?
    var right:RBNodeAnimation<T>?
    weak var parent:RBNodeAnimation<T>?
    
    deinit {
        print("a node is deleted!")
    }
}

class RBTreeAnimation<T:Comparable>{
    var root:RBNodeAnimation<T>?
    
    var nodeNeedInsertAdjust:RBNodeAnimation<T>?
    
    func insertAdjust(){
        //it's parent are red
        if nodeNeedInsertAdjust == nil {
            return
        }
        let current = nodeNeedInsertAdjust!
        var parent = nodeNeedInsertAdjust!.parent!
        if !parent.isBlack {
            let grandparent = parent.parent!
            if parent === grandparent.left{//1 parent is left child
                if grandparent.right == nil || grandparent.right!.isBlack { //1.1 grandparent n's right is nil or black
                    if current === parent.right{ // 1.1.1 current is parent's right child
                        rotateToLeft(n: current)
                        parent = current
                    }
                    rotateToRight(n: parent) // 1.1.2 current is parent's left child
                    parent.isBlack = true
                    parent.right!.isBlack = false
                    nodeNeedInsertAdjust = nil
                    //
                }else { //1.2 grandparent's right is red
                    reverseColor(n: grandparent) // 1.2.1reverse color
                    if grandparent === root!{
                        grandparent.isBlack = true
                        nodeNeedInsertAdjust = nil
                    }else if !grandparent.parent!.isBlack{ //1.2.2 grandparent's parent is red after reverse
                        nodeNeedInsertAdjust = grandparent
                    }else{ //1.2.3 grandparent's parent is black after reverse
                        nodeNeedInsertAdjust = nil
                    }
                }
            }else{ //2 parent is right child
                if grandparent.left == nil || grandparent.left!.isBlack { //1.1 grandparent n's left is nil or black
                    if current === parent.left{
                        rotateToRight(n: current)
                        parent = current
                    }
                    rotateToLeft(n: parent)
                    parent.isBlack = true
                    parent.left!.isBlack = false
                    nodeNeedInsertAdjust = nil
                    //
                }else { //1.2 grandparent's left is red
                    reverseColor(n: grandparent) // 1.2.1reverse color
                    if grandparent === root!{
                        grandparent.isBlack = true
                        nodeNeedInsertAdjust = nil
                    }else if !grandparent.parent!.isBlack{ //1.2.2 grandparent's parent is red after reverse
                        nodeNeedInsertAdjust = grandparent
                    }else{ //1.2.3 grandparent's parent is black after reverse
                        nodeNeedInsertAdjust = nil
                    }
                }
            }
        }else{
            nodeNeedInsertAdjust = nil
        }
    }
    
    func insert(e:T,delayAdjust:Bool = false){
        if root == nil {
            let n = RBNodeAnimation<T>(element: e)
            root = n
        }else{
            var p = root!
            while true {
                if e < p.element {
                    if p.left == nil{
                        let n = RBNodeAnimation<T>(element: e,isBlack: false)
                        p.left = n
                        n.parent = p
                        //                        if !delayAdjust{
                        ////                            adjust(n: n)
                        //                            while nodeNeedInsertAdjust != nil {
                        //                                insertAdjust()
                        //                            }
                        ////                            adjust()
                        //                        }else{
                        if !n.parent!.isBlack {
                            nodeNeedInsertAdjust = n
                        }
                        //                        }
                        if !delayAdjust{
                            //                            adjust(n: n)
                            while nodeNeedInsertAdjust != nil {
                                insertAdjust()
                            }
                        }
                        
                        
                        break
                    }else{
                        p = p.left!
                    }
                }else if e > p.element {
                    if p.right == nil {
                        let n = RBNodeAnimation<T>(element: e,isBlack: false)
                        p.right = n
                        n.parent = p
                        //                        if !delayAdjust{
                        ////                            adjust(n: n)
                        //                            while nodeNeedInsertAdjust != nil {
                        //                                insertAdjust()
                        //                            }
                        ////                            adjust()
                        //                        }else{
                        if !n.parent!.isBlack {
                            nodeNeedInsertAdjust = n
                        }
                        //                        }
                        if !delayAdjust{
                            //                            adjust(n: n)
                            while nodeNeedInsertAdjust != nil {
                                insertAdjust()
                            }
                        }
                        
                        break
                    }else{
                        p = p.right!
                    }
                }else {
                    break
                }
            }
        }
    }
    
    func adjustToEnd(){
        while true {
            if nodeNeedInsertAdjust != nil {
                //                treeArr.append(t.copy())
                insertAdjust()
            }else if nodeNeedDeleteAdjust != nil {
                //                treeArr.append(t.copy())
                deleteAdjust()
            }else{
                break
            }
        }
        
    }
    
    private func minChild(n:RBNodeAnimation<T>) -> RBNodeAnimation<T>{
        var x = n
        while x.left != nil {
            x = x.left!
        }
        return x
    }
    
    
    
    
    
    var childNeedDeleteAdjust:RBNodeAnimation<T>?
    var nodeNeedDeleteAdjust:RBNodeAnimation<T>?
    
    func delete(e:T){
        if root == nil {
            return
        }else{
            var n = root!
            while true {
                if e < n.element {
                    if n.left == nil{
                        break
                    }else{
                        n = n.left!
                    }
                }else if e > n.element {
                    if n.right == nil {
                        break
                    }else{
                        n = n.right!
                    }
                }else { // e == n.element
                    
                    if n.left == nil{
                        if n.right != nil {// n is black,n's left is nil, n's right is red
                            //                            n.right!.isBlack = true
                            nodeNeedDeleteAdjust = n.parent
                            childNeedDeleteAdjust = n.right
                            trans(for: n, substitute: n.right)
                        }else{// n is a leaf
                            if !n.isBlack{// n is red leaf
                                trans(for: n, substitute: nil)
                            }else{// n is black leaf, brother is black
                                //                                if n === root!{
                                //                                    root = nil
                                //                                    return
                                //                                }
                                //                                let parent = n.parent!
                                nodeNeedDeleteAdjust = n.parent
                                childNeedDeleteAdjust = nil
                                trans(for: n, substitute: nil)
                                //                                deleteLeafFix(n: parent)
                            }
                        }
                    }else if n.right == nil { //left child is red，right is nil
                        //                        n.left!.isBlack = true
                        nodeNeedDeleteAdjust = n.parent
                        childNeedDeleteAdjust = n.left
                        trans(for: n, substitute: n.left)
                    }else{ // n has two children
                        let y = minChild(n: n.right!)
                        //                        var p = y.parent!
                        nodeNeedDeleteAdjust = y.parent
                        childNeedDeleteAdjust = y.right
                        //                        let x = y.right
                        if y.parent === n{
                            trans(for: n, substitute: y)
                            //                            p = y
                            nodeNeedDeleteAdjust = y
                        }else{
                            trans(for: y, substitute: y.right)
                            trans(for: n, substitute: y)
                            y.right = n.right
                            n.right!.parent = y
                        }
                        y.left = n.left
                        n.left?.parent = y
                        let originalColorIsBlack = y.isBlack
                        y.isBlack = n.isBlack
                        if !originalColorIsBlack{
                            nodeNeedDeleteAdjust = nil
                        }
                    }
                    break
                }
            }
        }
    }
    
    func deleteAdjust(){
        if nodeNeedDeleteAdjust == nil {
            return
        }
        
        //        if nodeNeedDeleteAdjust === root!{
        //            root = nil
        //            return
        //        }
        
        if childNeedDeleteAdjust === root || ( childNeedDeleteAdjust != nil && !childNeedDeleteAdjust!.isBlack) {
            childNeedDeleteAdjust!.isBlack = true
            nodeNeedDeleteAdjust = nil
            return
        }
        
        let p = nodeNeedDeleteAdjust!
        //        let x:RBNode<T>? = nil
        if p.right !== childNeedDeleteAdjust {
            var r  = p.right!
            if !r.isBlack { // r is red
                r.isBlack = true
                p.isBlack = false
                rotateToLeft(n: r)
            }else if (r.left == nil && r.right == nil) ||
                ((r.left != nil && r.right != nil)&&(r.left!.isBlack && r.right!.isBlack)){
                r.isBlack = false
                //                if p === root! || !p.isBlack {
                //                    p.isBlack = true
                //                    nodeNeedDeleteAdjust = nil
                //                }else{
                //                    x = p
                //                    p = p.parent!
                
                //                }
                childNeedDeleteAdjust = p
                nodeNeedDeleteAdjust = p.parent
            }else{// r.left is red
                if (r.right == nil) || (r.right != nil && r.right!.isBlack) {
                    r.isBlack = false
                    let rl = r.left!
                    rl.isBlack = true
                    rotateToRight(n: rl)
                    r = rl
                }
                r.isBlack = p.isBlack
                p.isBlack = true
                r.right!.isBlack = true
                rotateToLeft(n: r)
                nodeNeedDeleteAdjust = nil
            }
        }else{
            var l  = p.left!
            if !l.isBlack { // r is red
                l.isBlack = true
                p.isBlack = false
                rotateToRight(n: l)
            }else if (l.left == nil && l.right == nil) ||
                ((l.left != nil && l.right != nil)&&(l.left!.isBlack && l.right!.isBlack)){
                l.isBlack = false
                //                if p === root! || !p.isBlack {
                //                    p.isBlack = true
                //                    nodeNeedDeleteAdjust = nil
                //                }else{
                //                    x = p
                //                    p = p.parent!
                //                }
                childNeedDeleteAdjust = p
                nodeNeedDeleteAdjust = p.parent
            }else{// r.left is red
                if (l.left == nil) || (l.left != nil && l.left!.isBlack) {
                    l.isBlack = false
                    let lr = l.right!
                    lr.isBlack = true
                    rotateToLeft(n: lr)
                    l = lr
                }
                l.isBlack = p.isBlack
                p.isBlack = true
                l.left!.isBlack = true
                rotateToRight(n: l)
                nodeNeedDeleteAdjust = nil
            }
            
        }
    }
    
    func trans(for n1:RBNodeAnimation<T> ,substitute n2:RBNodeAnimation<T>?){
        n2?.parent = n1.parent
        if n1.parent == nil {
            root = n2
        }else{
            let parent = n1.parent!
            if n1 === parent.left{
                parent.left = n2
            }else{
                parent.right = n2
            }
        }
    }
    
    
    //assume n is red
    //    private func adjust(n:RBNode<T>){
    //        //it's parent are red
    //        var current = n
    //        var parent = n.parent!
    //        if !parent.isBlack {
    //            var grandparent = n.parent!.parent!
    //            while true {
    //                if parent === grandparent.left{//1 parent is left child
    //                    if grandparent.right == nil || grandparent.right!.isBlack { //1.1 grandparent n's right is nil or black
    //                        if current === parent.right{ // 1.1.1 current is parent's right child
    //                            rotateToLeft(n: current)
    //                            parent = current
    //                        }
    //                        rotateToRight(n: parent) // 1.1.2 current is parent's left child
    //                        parent.isBlack = true
    //                        parent.right!.isBlack = false
    //                        break
    //                        //
    //                    }else { //1.2 grandparent's right is red
    //                        reverseColor(n: grandparent) // 1.2.1reverse color
    //                        if grandparent === root!{
    //                            grandparent.isBlack = true
    //                            break
    //                        }else if !grandparent.parent!.isBlack{ //1.2.2 grandparent's parent is red after reverse
    //                            current = grandparent
    //                            parent = grandparent.parent!
    //                            grandparent = parent.parent!
    //                        }else{ //1.2.3 grandparent's parent is black after reverse
    //                            break
    //                        }
    //                    }
    //                }else{ //2 parent is right child
    //                    if grandparent.left == nil || grandparent.left!.isBlack { //1.1 grandparent n's left is nil or black
    //                        if current === parent.left{
    //                            rotateToRight(n: current)
    //                            parent = current
    //                        }
    //                        rotateToLeft(n: parent)
    //                        parent.isBlack = true
    //                        parent.left!.isBlack = false
    //                        break
    //                        //
    //                    }else { //1.2 grandparent's left is red
    //                        reverseColor(n: grandparent) // 1.2.1reverse color
    //                        if grandparent === root!{
    //                            grandparent.isBlack = true
    //                            break
    //                        }else if !grandparent.parent!.isBlack{ //1.2.2 grandparent's parent is red after reverse
    //                            current = grandparent
    //                            parent = grandparent.parent!
    //                            grandparent = parent.parent!
    //                        }else{ //1.2.3 grandparent's parent is black after reverse
    //                            break
    //                        }
    //                    }
    //
    //                }
    //            }
    //        }
    //
    //    }
    
    private func reverseColor(n:RBNodeAnimation<T>){
        n.isBlack = false
        n.left!.isBlack = true
        n.right!.isBlack = true
    }
    
    //assume n's right is nil
    private func rotateToRight(n:RBNodeAnimation<T>){
        let parent = n.parent!
        parent.left = n.right
        n.right?.parent = parent
        n.right = parent
        if parent === root!{
            root = n
            n.parent = nil
        }else{
            let grandparent = parent.parent! // grandparent is black
            if n.parent! === grandparent.left{
                grandparent.left = n
            }else{
                grandparent.right = n
            }
            n.parent = grandparent
        }
        parent.parent = n
    }
    
    private func rotateToLeft(n:RBNodeAnimation<T>){
        let parent = n.parent!
        parent.right = n.left
        n.left?.parent = parent
        n.left = parent
        if parent === root!{
            root = n
            n.parent = nil
        }else{
            let grandparent = parent.parent! // grandparent is black
            if n.parent! === grandparent.left{
                grandparent.left = n
            }else{
                grandparent.right = n
            }
            n.parent = grandparent
        }
        parent.parent = n
    }
    
    func copy()->RBTreeAnimation<T>{
        let t = RBTreeAnimation<T>()
        t.root = copy(n: root,t:t)
        return t
    }
    
    private func copy(n:RBNodeAnimation<T>? , t:RBTreeAnimation<T>)->RBNodeAnimation<T>?{
        if n == nil {
            return nil
        }else{
            let copiedN = RBNodeAnimation<T>(element: n!.element)
            copiedN.left = copy(n: n!.left,t:t)
            copiedN.right = copy(n: n!.right,t:t)
            copiedN.left?.parent = copiedN
            copiedN.right?.parent = copiedN
            copiedN.isBlack = n!.isBlack
            copiedN.b = n!.b
            copiedN.leftLine = n!.leftLine
            copiedN.rightLine = n!.rightLine
            if  n === nodeNeedInsertAdjust{
                t.nodeNeedInsertAdjust = copiedN
            }
            if n === childNeedDeleteAdjust{
                t.childNeedDeleteAdjust = copiedN
            }
            if n === nodeNeedDeleteAdjust{
                t.nodeNeedDeleteAdjust = copiedN
            }
            return copiedN
        }
    }
    
    func setButtonEnable(isEnable:Bool){
        setButtonEnable(n: root, isEnable: isEnable)
    }
    
    private func setButtonEnable(n:RBNodeAnimation<T>?,isEnable:Bool){
        if n != nil {
            n!.b.isEnabled = isEnable
            //            n!.b.alpha = isEnable ? 1 : 0.75
            setButtonEnable(n: n!.left, isEnable: isEnable)
            setButtonEnable(n: n!.right, isEnable: isEnable)
        }
    }
    
    
    
    
    
    
}

