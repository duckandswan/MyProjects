//
//  RBViewController.swift
//  AlgorithmExercise
//
//  Created by Song Bo on 31/03/2017.
//  Copyright © 2017 Song Bo. All rights reserved.
//

import UIKit
import GameKit


class RBViewController: UIViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var subtractButton: UIBarButtonItem!
    
    @IBOutlet weak var adjustButton: UIBarButtonItem!
    
    @IBOutlet weak var preButton: UIBarButtonItem!
    
    
    @IBOutlet weak var tf: UITextField!
    var t = RBTreeAnimation<Int>()
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
        
        drawRBTree(t: t, isAnimated: false)
        enableOrDisableButtons()
    }
    
    func randomWithFixedSeed(){
        var arr:[Int] = []
        (1...120).forEach{_ in
            let i = Int(arc4random_uniform(1000))
            t.insert(e: i)
            arr.append(i)
        }
        print("arr:\(arr)")
    }
    
    func randomWithNewSeed(){
        stride(from: 500, through: 100, by: -10).forEach { (i) in
            t.insert(e: i)
        }

        var arr:[Int] = []
        let rs = GKMersenneTwisterRandomSource()
        rs.seed = 104
        let rd = GKRandomDistribution(randomSource: rs, lowestValue: 0, highestValue: 1000)

        (1...500).forEach{_ in
            let i = rd.nextInt()
            t.insert(e: i)
            arr.append(i)
        }
        print("arr:\(arr)")
    }
    
    @objc func handlePinches(_ sender: UIPinchGestureRecognizer){
        
        if sender.state != .ended && sender.state != .failed{
            scrollView.transform = scrollView.transform.scaledBy(x: sender.scale, y: sender.scale)
            scrollView.frame = UIScreen.main.bounds
            sender.scale = 1
        }else{

        }
    }
    
    var treeArr:[RBTreeAnimation<Int>] = []
    
    func addTree(newTree:RBTreeAnimation<Int>){
        treeArr.append(newTree)
        if treeArr.count > 250{
            treeArr.remove(at: 0)
        }
    }
    
    @IBAction func preStep(_ sender: UIBarButtonItem) {
        if treeArr.count > 0 {
            t = treeArr.removeLast()
            drawRBTree(t: t)
            enableOrDisableButtons()
        }
    }
    
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        if t.nodeNeedInsertAdjust != nil {
            return
        }

        let i = Int(tf.text!) ?? Int(arc4random_uniform(1000))
        addTree(newTree: t.copy())
        t.insert(e: i,delayAdjust: true)
        if isContinuous{
            adjustToEnd()
        }
        drawRBTree(t: t)

        view.endEditing(true)
        enableOrDisableButtons()
    }
    
    @IBAction func subtract(_ sender: UIBarButtonItem) {
        if let i = Int(tf.text!){
            delete(i: i)
        }
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
    
    @IBAction func rotate(_ sender: UIBarButtonItem){
        if t.nodeNeedInsertAdjust != nil {
            addTree(newTree: t.copy())
            t.insertAdjust()
        }else if t.nodeNeedDeleteAdjust != nil {
            addTree(newTree: t.copy())
            t.deleteAdjust()
        }else{
            return
        }
        
        drawRBTree(t: t)
        enableOrDisableButtons()
    }
    
    func adjustToEnd(){
//        while true {
//            if t.nodeNeedInsertAdjust != nil {
////                treeArr.append(t.copy())
//                t.insertAdjust()
//            }else if t.nodeNeedDeleteAdjust != nil {
////                treeArr.append(t.copy())
//                t.deleteAdjust()
//            }else{
//                break
//            }
//        }
        t.adjustToEnd()
        
        drawRBTree(t: t)
        enableOrDisableButtons()
    }
    
    func delete(i:Int){
        addTree(newTree: t.copy())
        
        t.delete(e: i)
        drawRBTree(t: t)
        enableOrDisableButtons()
        if isContinuous{
            adjustToEnd()
        }
    }
    
    @objc func clickToDelete(b:UIButton){
        if t.nodeNeedDeleteAdjust != nil {
            return
        }
        if let i = Int(b.titleLabel!.text!){
            delete(i: i)
        }
    }
    
    func enableOrDisableButtons(){
        if t.nodeNeedInsertAdjust == nil && t.nodeNeedDeleteAdjust == nil{
            addButton.isEnabled = true
            subtractButton.isEnabled = true
            adjustButton.isEnabled = false
            t.setButtonEnable(isEnable: true)
        }else{
            addButton.isEnabled = false
            subtractButton.isEnabled = false
            adjustButton.isEnabled = true
            t.setButtonEnable(isEnable: false)
        }
        preButton.isEnabled = treeArr.count > 0
        view.endEditing(false)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func drawRBTree<T>(t:RBTreeAnimation<T>, isAnimated:Bool = true){
        for v in scrollView.subviews{
            v.removeFromSuperview()
        }
        
        if let layers = scrollView.layer.sublayers{
            for l in layers {
                l.removeFromSuperlayer()
            }
        }
        
        let nodeW:CGFloat = 25
        let rowH = nodeW
        
        let timeInterval:TimeInterval = isAnimated ? 1.5 : 0
        
        func addLine(p1:CGPoint,p2:CGPoint,line:CAShapeLayer){
//            let line = CAShapeLayer()
            let linePath = UIBezierPath()
            let r = nodeW / 2
            let sin = (p2.y - p1.y) / (p2.distanceTo(p1))
            let cos = (p2.x - p1.x) / (p2.distanceTo(p1))
            let v = CGVector(dx: r * cos, dy: r * sin)
            let a1 = p1 + v
            let a2 = p2 - v
            linePath.move(to: a1)
            linePath.addLine(to: a2)
            line.lineWidth = 1.0
            let originalPath = line.path
            line.path = linePath.cgPath
            line.strokeColor = UIColor.blue.cgColor
            scrollView.layer.addSublayer(line)

            let pathAppear = CABasicAnimation(keyPath: "path")
            pathAppear.duration = timeInterval
            pathAppear.fromValue = originalPath
            pathAppear.toValue = linePath.cgPath
            line.add(pathAppear, forKey: "make the path appear")
        }

        func addRBNode(n:RBNodeAnimation<T>,center:CGPoint,i:Int){
//            let button = UIButton()
            let button = n.b
            button.frame.size = CGSize(width: nodeW, height: nodeW)
            button.isEnabled = true
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.aqua, for: .disabled)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            button.setTitle(String(describing: n.element), for: .normal)
            button.layer.cornerRadius = nodeW / 2
            UIView.animate(withDuration: timeInterval) {
                button.center = center
            }
            button.backgroundColor = n.isBlack ? UIColor.black : UIColor.red
            scrollView.addSubview(button)
            
            button.addTarget(self, action: #selector(RBViewController.clickToDelete(b:)), for: .touchUpInside)
            
            if n.left != nil {
                let p1 = center
                let p2 = CGPoint(x: p1.x - pow(2, CGFloat(i - 1)) * (nodeW / 2), y: p1.y + rowH)
                addLine(p1: p1, p2: p2, line: n.leftLine)
            }
            
            if n.right != nil {
                let p1 = center
                let p2 = CGPoint(x: p1.x + pow(2, CGFloat(i - 1)) * (nodeW / 2), y: p1.y + rowH)
                addLine(p1: p1, p2: p2,line: n.rightLine)
            }
        }
        
        guard let n = t.root else{
            return
        }
        
        var row1:[RBNodeAnimation<T>?] = [n]
        var rowArr = [row1]
        while true {
            var row2:[RBNodeAnimation<T>?] = []
            for n in row1 {
                row2.append(n?.left)
                row2.append(n?.right)
            }
            if row2.contains(where: { $0 != nil}){
                rowArr.append(row2)
                row1 = row2
            }else{
                break
            }
        }
        
        let rowNumber = rowArr.count
        var curX:CGFloat
        var curY:CGFloat = rowH * CGFloat(rowNumber + 1) - nodeW * 1 / 2
        if (curY + rowH)  > scrollView.contentSize.height{
            scrollView.contentSize.height = curY + rowH
        }
        for (i,row) in rowArr.reversed().enumerated(){
            curX = i == 0 ? (nodeW * 1 / 2) : (nodeW * pow(2, CGFloat(i - 1 )))
            for n in row{
                if n != nil {
                    addRBNode(n: n!, center: CGPoint(x: curX, y: curY),i: i)
                }
                let spaceX = nodeW * pow(2, CGFloat(i))

                if curX > scrollView.contentSize.width{
                    scrollView.contentSize.width = curX
                }
                curX += spaceX
            }
            if curY > scrollView.contentSize.height{
                scrollView.contentSize.height = curY
            }
            curY -= rowH
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        print("UIScreen.main.bounds: \(UIScreen.main.bounds)")
        scrollView.frame = UIScreen.main.bounds
    }
    


}

