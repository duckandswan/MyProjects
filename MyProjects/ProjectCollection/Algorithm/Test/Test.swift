//
//  Test.swift
//  TestAlgorithm
//
//  Created by Song Bo on 01/01/2017.
//  Copyright © 2017 finding. All rights reserved.
//

import Foundation

func testPartition(){
    for _ in 0..<5000{
        var arr = ALGUtils.randIntArr(3)
        //        print("before partition arr: \(arr)")
        
        //let q = partition(&arr, p: 0, r: arr.count - 1)
        //let q = randomPartition(&arr, p: 0, r: arr.count - 1)
        //        let q = betterRandomPartition(&arr, p: 0, r: arr.count - 1)
        let q = betterPartition(&arr, p: 0, r: arr.count - 1)
        //        print("after partition arr: \(arr)")
        
        for i in 0..<q {
            assert(arr[i] <= arr[q], "\(i) element \(arr[i]) has error")
        }
        
        for i in q+1..<arr.count {
            assert(arr[i] >= arr[q], "\(i) element \(arr[i]) has error")
        }
    }
}

func testSort(){
    for _ in 0..<1000{
        var arr = ALGUtils.randIntArr(50)
        print("before sort arr: \n\(arr)")
        
        //        quickSort(&arr, p: 0, r: arr.count - 1)
        insertSort(&arr, p: 0, r: arr.count - 1)
        print("after sort arr: \n\(arr)")
        
        ALGUtils.assertOrder(arr: arr)
        
    }
}

func testHeap(){
    let arr = ALGUtils.randIntArr(75)
    print("before build heap arr: \n\(arr)")
    let h = MyHeap(arr: Array<Int>())
    for e in arr {
        h.insert(t: e)
    }
    h.assertHeap()
    h.sort()
    print("after sort arr: \n\(arr)")
}

