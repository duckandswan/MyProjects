//
//  MyHeap.swift
//  TestAlgorithm
//
//  Created by Song Bo on 02/01/2017.
//  Copyright © 2017 finding. All rights reserved.
//

import Foundation

class MyHeap<T:Comparable> {
    private var heapArr:[T] = []
    init(arr:[T]){
        heapArr = arr
        buildHeap()
    }
    
    private func buildHeap(){
        for i in (0...(heapArr.count / 2)).reversed() {
            heapify(i: i)
        }
    }
    //move down
    private func heapify(i:Int){
        var p = i
        var c:Int
        while true {
            let c1 = p*2 + 1
            let c2 = p*2 + 2
            if c2 < heapArr.count{
                c = heapArr[c1] < heapArr[c2] ? c1 : c2
            }else if c1 < heapArr.count{
                c = c1
            }else{
                break
            }
            
            if heapArr[p] > heapArr[c]{
                heapArr.swap(p,c)
                p = c
            }else{
                break
            }
        }
        
    }
    
    func assertHeap(){
        print("\nheap is :\n")
        heapArr.enumerated().forEach { (i,e) in
            print("\(e) ",terminator: "")
            if [0,2,6,14,30,62,126].first(where: {return $0 == i})
                != nil {
                print("\n")
            }
        }
        for i in 1..<heapArr.count - 1 {
            assert(heapArr[i] >= heapArr[(i-1)/2], "\(i) have errors")
        }
        print("\n")
    }
    
    func sort(){
        var arr:[T] = []
        while true{
            if let e = pop(){
                arr.append(e)
            }else{
                ALGUtils.assertOrder(arr: arr)
                break
            }
        }
    }
    
    private func pop()->T?{
        if heapArr.count > 0 {
            heapArr.swap(0,heapArr.count - 1)
            let e = heapArr.popLast()
            heapify(i: 0)
            return e
            
        }else{
            return nil
        }
    }
    //move up
    func insert(t:T){
        heapArr.append(t)
        var p = (heapArr.count - 2)/2
        var c:Int
        while true {
            let c1 = p*2 + 1
            let c2 = p*2 + 2
            if c2 < heapArr.count{
                c = heapArr[c1] < heapArr[c2] ? c1 : c2
            }else if c1 < heapArr.count{
                c = c1
            }else{
                break
            }
            
            if heapArr[p] > heapArr[c]{
                heapArr.swap(p,c)
                if p == 0 {
                    break
                }
                p = (p - 1)/2
            }else{
                break
            }
        }
    }
    
    static func HeapSort(arr:[T]){
        let h = MyHeap(arr: arr)
        h.sort()
    }
}


