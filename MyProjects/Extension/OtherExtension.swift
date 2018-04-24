//
//  Extension.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 10/04/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit

extension UIViewController{
    var isPortrait:Bool {
        return  UIScreen.main.bounds.width < UIScreen.main.bounds.height
    }
    
    var long:CGFloat {
        return UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
    }
    
    var short:CGFloat {
        return UIScreen.main.bounds.width < UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
    }
}

extension Sequence {
    public func all(matching predicate: (Iterator.Element) -> Bool) -> Bool {
        // Every element matches a predicate if no element doesn't match it:
        return !contains { !predicate($0) }
    }
}


