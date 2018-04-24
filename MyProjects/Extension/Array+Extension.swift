//
//  Array+Extension.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 30/03/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import Foundation

extension Array{
    mutating func swap(_ i:Int,_ j:Int){
        let x = self[i]
        self[i] = self[j]
        self[j] = x
    }
}
