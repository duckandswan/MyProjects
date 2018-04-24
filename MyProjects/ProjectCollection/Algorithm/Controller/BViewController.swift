//
//  BViewController.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 10/10/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit

class BViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var subtractButton: UIBarButtonItem!
    
    @IBOutlet weak var adjustButton: UIBarButtonItem!
    
    @IBOutlet weak var preButton: UIBarButtonItem!
    
    @IBOutlet weak var tf: UITextField!
    var tree = BTreeAnimation<Int>()
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        scrollView.frame = view.bounds
        scrollView.contentSize = view.bounds.size
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        
        let pinchGestureRecognizer =  UIPinchGestureRecognizer(target: self,
                                                               action: #selector(RBViewController.handlePinches(_:)))
        scrollView.addGestureRecognizer(pinchGestureRecognizer)
        
        randomWithFixedSeed()
        
        drawBTree(t: tree, isAnimated: false)
    }
    
    func randomWithFixedSeed(){
        var arr:[Int] = []
        ALGUtils.randomArrWithNewSeed(n: 100).forEach{i in
            arr.append(i)
            tree.insert(k: i)
        }
        arr.sort()
        for i in arr {
            print(i, terminator:" ")
        }
        tree.traverse()
        
    }
    
    func randomWithNewSeed(){
        
    }
    
    func handlePinches(_ sender: UIPinchGestureRecognizer){
        
        if sender.state != .ended && sender.state != .failed{
            scrollView.transform = scrollView.transform.scaledBy(x: sender.scale, y: sender.scale)
            scrollView.frame = UIScreen.main.bounds
            sender.scale = 1
        }else{
            
        }
    }
    
    var treeArr:[BTreeAnimation<Int>] = []

    
    
    @objc @IBAction func subtract(_ sender: UIBarButtonItem) {
        
    }
    
    var isContinuous = true
    
    @IBAction func resolve(_ sender: UIBarButtonItem) {
        if sender.title == "✂︎" {
            sender.title = "➤"
            isContinuous = false
        }else{
            sender.title = "✂︎"
            isContinuous = true
        }
    }
    
    var timeInterval:TimeInterval = 0
    let keyW:CGFloat = 25
    var nodeL:CGFloat = 0
    func drawBTree<T>(t:BTreeAnimation<T>, isAnimated:Bool = false){
        for v in scrollView.subviews{
            v.removeFromSuperview()
        }
        
        if let layers = scrollView.layer.sublayers{
            for l in layers {
                l.removeFromSuperlayer()
            }
        }
        
        timeInterval = isAnimated ? 1.5 : 0
        
        let level = t.level()
        let t = BNodeAnimation<T>.t
        nodeL = keyW * CGFloat(2*t-1)
        var fullLength = nodeL * pow(CGFloat(2*t), CGFloat(level)) + 2 * keyW
        if fullLength < SCREEN_W{
            fullLength = SCREEN_W
        }
        let center = CGPoint(x: fullLength / 2, y: 3 * keyW / 2)
        
        scrollView.contentSize.width = fullLength
        
        draw(n: tree.root, center: center, level: level)
        
    }
    
    var colorArr = [UIColor.lightGray,UIColor.gray,UIColor.darkGray]
    
    func draw<T>(n:BNodeAnimation<T>,center:CGPoint,level:Int,color:UIColor = UIColor.lightGray){
        
        let t = BNodeAnimation<T>.t
        //next level gap
        
        let bgv = UIView(frame: CGRect(x: 0, y: 0, width: nodeL, height: keyW))
        bgv.backgroundColor = color
        scrollView.addSubview(bgv)
        
        func addKeyButton(k:T,center:CGPoint){
            let button = UIButton()
            button.frame.size = CGSize(width: keyW, height: keyW)
            button.isEnabled = true
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.aqua, for: .disabled)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            button.setTitle(String(describing: k), for: .normal)
            button.layer.cornerRadius = keyW / 2
            UIView.animate(withDuration: timeInterval) {
                button.center = center
            }
            button.backgroundColor = UIColor.black
            scrollView.addSubview(button)
            
            button.addTarget(self, action: #selector(BViewController.clickToDelete(b:)), for: .touchUpInside)
            
        }
        
        func addLine(p1:CGPoint,p2:CGPoint){
            let line = CAShapeLayer()
            line.zPosition = -1000
            let linePath = UIBezierPath()
            linePath.move(to: p1)
            linePath.addLine(to: p2)
            line.lineWidth = 1.0
            let originalPath = line.path
            line.path = linePath.cgPath
            line.strokeColor = UIColor.black.cgColor
            scrollView.layer.addSublayer(line)
            
            let pathAppear = CABasicAnimation(keyPath: "path")
            pathAppear.duration = timeInterval
            pathAppear.fromValue = originalPath
            pathAppear.toValue = linePath.cgPath
            line.add(pathAppear, forKey: "make the path appear")
        }
        
        var center1 = CGPoint(x: center.x - nodeL/2 + keyW/2, y: center.y )
        bgv.center = center
        for key in n.keys{
            addKeyButton(k: key, center: center1)
            center1.x += keyW
        }
        if !n.isLeaf{
            let childL = nodeL * pow(CGFloat(2*t), CGFloat(level-1))
            var center2 = CGPoint(x: center.x - childL * CGFloat(t) + childL/2, y: center.y + 2*keyW)
            var p1 = CGPoint(x: center.x - nodeL/2, y: center.y )
            for (i,child) in n.children.enumerated(){
                draw(n: child, center: center2, level: level - 1,color:colorArr[i%3])
                addLine(p1: p1, p2: center2)
                center2.x += childL
                p1.x += keyW
            }
        }
        
    }
    
    @objc func clickToDelete(b:UIButton){
        
    }

    
    override func viewDidLayoutSubviews() {
        print("UIScreen.main.bounds: \(UIScreen.main.bounds)")
        scrollView.frame = UIScreen.main.bounds
    }
    
    
    
}


