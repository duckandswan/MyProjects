//
//  LinkGame.swift
//  LinkGame
//
//  Created by bob song on 16/11/14.
//  Copyright © 2016年 finding. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class LinkGameButton: UIButton {
    var r = 0
    var c = 0
}

class LinkGameView:UIView{
    var bezierPath = UIBezierPath()
    
    var buttonLength:CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        bezierPath.stroke()
    }
    
    func clear(){
        for v in subviews {
            v.removeFromSuperview()
        }
        bezierPath.removeAllPoints()
        setNeedsDisplay()
    }
    
    func drawPath(tuples: [(Int,Int)]){
        bezierPath.removeAllPoints()
        bezierPath.move(to: point(t: tuples[0]))
        for i in 1..<tuples.count {
            let t = tuples[i]
           bezierPath.addLine(to: point(t: t))
        }
        setNeedsDisplay()
    }
    
    func point(t: (r: Int, c: Int)) -> CGPoint {
        return CGPoint(x: 0 + buttonLength * (CGFloat(t.c) + 0.5), y: 0 + buttonLength * (CGFloat(t.r) + 0.5))
    }
    
}

class LinkGame: UIViewController {

    @IBOutlet weak var gameView: LinkGameView!
    var number = 10
    var a:[Array<Int>] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "连连看"
        self.loadGame()
    }

    @IBAction func restart() {
        for i in 0..<number {
            for j in 0..<number {
                if a[i][j] == 1 {
                    a[i][j] = 0
                }
            }
        }
        gameView.clear()
        self.loadGame()
    }

    var buttonLength:CGFloat = 0
    func loadGame() {
        
        for _ in 0..<number + 2{
            a.append([Int](repeating: 0, count: number + 2))
        }

        var ary = LinkGameUtils.generate(withSize: number)
        
        buttonLength = view.frame.width / CGFloat(number + 2)
        gameView.buttonLength = buttonLength

        for i in 0..<number {
            for j in 0..<number {
                
                let b = LinkGameButton()
                b.r = i + 1
                b.c = j + 1
                b.frame = CGRect(x: CGFloat(b.c) * buttonLength, y: CGFloat(b.r) * buttonLength, width: buttonLength, height: buttonLength)
                b.setTitle(ary[j + i * number], for: .normal)
                b.backgroundColor = UIColor.gray
                b.addTarget(self, action: #selector(self.click), for: .touchUpInside)
                gameView.addSubview(b)
                a[b.r][b.c] = 1
            }
        }
    }
    
    var firstButton:LinkGameButton?
    func click(_ sender: LinkGameButton) {
        print("r:\(sender.r) c:\(sender.c)")
        if self.firstButton == nil {
            sender.backgroundColor = UIColor.yellow
            self.firstButton = sender
        }
        else {
            if self.tryRemove(b1: self.firstButton!, b2: sender) {
                self.firstButton = nil
            }
            else {
                self.firstButton!.backgroundColor = UIColor.gray
                sender.backgroundColor = UIColor.yellow
                self.firstButton = sender
            }
        }
    }
    
    func removeButtons(b1: LinkGameButton, b2: LinkGameButton){
        b1.removeFromSuperview()
        b2.removeFromSuperview()
        a[b1.r][b1.c] = 0
        a[b2.r][b2.c] = 0
    }
    
    func tryRemove( b1: LinkGameButton, b2: LinkGameButton) -> Bool {
        if b1 != b2 && (b1.titleLabel!.text! == b2.titleLabel!.text!) == true {
            if b1.r == b2.r || b1.c == b2.c {
                let tuples = [(b1.r, b1.c),(b2.r, b2.c)]
                if isClearBetween(tuples: tuples ) {
                    gameView.drawPath(tuples: tuples )
                    removeButtons(b1: b1, b2: b2)
                    return true
                }
            }
            //
            if a[b1.r][b2.c] == 0 {
                let tuples = [(b1.r, b1.c),(b1.r, b2.c),(b2.r, b2.c)]
                if isClearBetween(tuples: tuples ) {
                    gameView.drawPath(tuples: tuples )
                    removeButtons(b1: b1, b2: b2)
                    return true
                }
            }
            //
            if a[b2.r][b1.c] == 0 {
                let tuples = [(b1.r, b1.c),(b2.r, b1.c),(b2.r, b2.c)]
                if isClearBetween(tuples: tuples ) {
                    gameView.drawPath(tuples: tuples )
                    removeButtons(b1: b1, b2: b2)
                    return true
                }
            }
            //
            for j in 0..<number + 2 {
                if a[b1.r][j] == 0 && a[b2.r][j] == 0 {
                    let tuples = [(b1.r, b1.c),(b1.r, j),(b2.r, j),(b2.r, b2.c)]
                    if isClearBetween(tuples: tuples ) {
                        gameView.drawPath(tuples: tuples )
                        removeButtons(b1: b1, b2: b2)
                        return true
                    }
                }
            }
            
            for i in 0..<number + 2 {
                if a[i][b1.c] == 0 && a[i][b2.c] == 0 {
                    let tuples = [(b1.r, b1.c),(i, b1.c),(i, b2.c),(b2.r, b2.c)]
                    if isClearBetween(tuples: tuples ) {
                        gameView.drawPath(tuples: tuples )
                        removeButtons(b1: b1, b2: b2)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func isClearBetween(tuples: [(Int,Int)]) -> Bool {
        var t1 = tuples[0]
        for i in 1..<tuples.count {
            let t2 = tuples[i]
            if isClearBetween(r1: t1.0, c1: t1.1, r2: t2.0, c2: t2.1) == false {
                return false
            }
            t1 = t2
        }
        return true
    }
    
    func isClearBetween(r1: Int, c1: Int, r2: Int, c2: Int) -> Bool {
        if r1 == r2 {
            if c1 < c2 {
                for j in c1 + 1..<c2 {
                    if a[r1][j] == 1 {
                        return false
                    }
                }
            }
            else if c1 > c2 {
                var j = c1 - 1
                while j > c2 {
                    if a[r1][j] == 1 {
                        return false
                    }
                    j -= 1
                }
            }
            return true
        }
        if c1 == c2 {
            if r1 < r2 {
                for i in r1 + 1..<r2 {
                    if a[i][c1] == 1 {
                        return false
                    }
                }
            }
            else if r1 > r2 {
                var i = r1 - 1
                while i > r2 {
                    if a[i][c1] == 1 {
                        return false
                    }
                    i -= 1
                }
            }
            return true
        }
        return false
    }
}

