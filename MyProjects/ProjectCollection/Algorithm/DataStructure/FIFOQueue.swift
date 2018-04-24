//
//  Queue.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 31/03/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import Foundation

protocol Queue {
    
    associatedtype Element
    
    mutating func enqueue(_ newElement: Element)
    
    mutating func dequeue() -> Element?
}

struct FIFOQueue<Element>: Queue {
    fileprivate var left: [Element] = []
    fileprivate var right: [Element] = []
    
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}
