//
//  MyStickerController.swift
//  Work
//
//  Created by bob song on 15/8/12.
//  Copyright (c) 2015年 spring. All rights reserved.
//

import UIKit
import Photos

//class StickerController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
////    var stickerArr:[UIImage] = []
//    weak var editImageViewController:EditImageViewController!
//    
//    let mimL:CGFloat = 50
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//        
//        
//
//        // Do any additional setup after loading the view.
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
////        print("stickerArr.count:\(stickerArr.count)")
//        return editImageViewController.stickerArr.count
//        
////        return editImageViewController.stickerModels.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) 
//        
//        // Configure the cell
//        if cell.contentView.viewWithTag(100) == nil {
//            
//            let imageview = UIImageView(frame: cell.contentView.bounds)
//            imageview.tag = 100
//            imageview.isUserInteractionEnabled = true
//            imageview.contentMode = UIViewContentMode.scaleToFill
//            cell.contentView.addSubview(imageview)
//            cell.contentView.backgroundColor = UIColor.gray
//            
//        }
//        let imageview = cell.contentView.viewWithTag(100) as! UIImageView
//        imageview.image = editImageViewController.stickerArr[indexPath.row]
//        
//
//        
//        return cell
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        editImageViewController.addStickerAtIndex(indexPath.row)
//        
//    }
//    
//    
//    
//}
//
//class MyStickerCollectionView: UICollectionView {
//    
//    var stickerController:StickerController!
//    init(frame: CGRect, editImageViewController:EditImageViewController) {
//        
//        let flowLayout = UICollectionViewFlowLayout()
//        
//        
//        
//        flowLayout.minimumLineSpacing = 10
//        flowLayout.minimumInteritemSpacing = 10
//        flowLayout.sectionInset =
//            UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        let cellW = frame.size.width / 5
//        let cellH = cellW
//        flowLayout.itemSize = CGSize(width: cellW, height: cellH)
//        
//        super.init(frame: frame, collectionViewLayout: flowLayout)
//        
//        stickerController = StickerController()
//        stickerController.editImageViewController = editImageViewController
//
//        self.dataSource = stickerController
//        self.delegate = stickerController
//        
////        self.dataSource = editImageViewController
////        self.delegate = editImageViewController
//        
//        
//        
//        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell3")
//        
//        self.backgroundColor = UIColor.clear
////        self.backgroundColor = UIColor(red: 239/255.0, green: 243/255.0, blue: 244/255.0, alpha: 1)
//     
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

class MyImageView:UIImageView{
    var stikerViewArr:[MyStickerView] = []
    var labelViewArr:[MyView] = []
    var edited:Bool = true
    var editedImage:UIImage!
    var asset:PHAsset!
    var borderLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(borderLayer)
        borderLayer.lineWidth = 1;
        borderLayer.strokeColor = UIColor.white.cgColor;
        borderLayer.fillColor = UIColor.clear.cgColor;
        borderLayer.lineDashPattern = [3,3]
        borderLayer.lineDashPhase = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var timer:Timer!
    func startAntMarchAtPath(_ path:UIBezierPath){
        borderLayer.path = path.cgPath
        if timer == nil{
            timer = Timer(timeInterval: 0.05, target: self, selector: #selector(MyImageView.march), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        
    }
    func march(){
        borderLayer.lineDashPhase += 1
        borderLayer.setNeedsDisplay()
    }
    func stopAntMarch(){
        timer.invalidate()
        timer = nil
        borderLayer.path = UIBezierPath().cgPath
        borderLayer.setNeedsDisplay()
    }
    
    func drawPath(_ path:UIBezierPath){
        
        borderLayer.path = path.cgPath
        
        borderLayer.setNeedsDisplay()
        
        
//        [self.layer setValue:borderLayer forKey:BorderLayerKey];
    }
    
    func hideModification() {
        for j in 0  ..< stikerViewArr.count {
            let v = stikerViewArr[j]
            v.cancelImageView.isHidden = true
            v.stretchImageView.isHidden = true
        }
    }
    func showModification(){
        for j in 0  ..< stikerViewArr.count {
            let v = stikerViewArr[j]
            v.cancelImageView.isHidden = false
            v.stretchImageView.isHidden = false
        }
    }
    
    func containPoint(_ p:CGPoint)->Bool{
        for v in stikerViewArr{
            if v.frame.contains(p)||v.cancelImageView.frame.contains(p)||v.stretchImageView.frame.contains(p){
                return true
            }
        }
        
//        for var v in labelViewArr{
//            if v.frame.contains(p){
//                return true
//            }
//        }
        
        return false
    }
    
}

protocol HasBorder{
    var hasBorder:Bool{get set}
    
    func drawBorder()
    
    func drawNoneBorder()
}

class MyCancelImageView:UIImageView{
    weak var myStickerView:MyStickerView!
}
class MyStretchImageView:UIImageView{
    weak var myStickerView:MyStickerView!
}

class MyStickerView:UIView,HasBorder{
//    var lastTransform:CGAffineTransform = CGAffineTransform.identity
//    var lastCenter1:CGPoint!
//    var lastCenter2:CGPoint!
    var topLeftPoint:CGPoint!
    var topRightPoint:CGPoint!
    var bottomLeftPoint:CGPoint!
    var bottomRightPoint:CGPoint!
    var transformedTopLeftPoint:CGPoint{
        return transformedPointInSuperView(topLeftPoint)
    }
    var transformedTopRightPoint:CGPoint{
        return transformedPointInSuperView(topRightPoint)
    }
    var transformedBottomLeftPoint:CGPoint{
        return transformedPointInSuperView(bottomLeftPoint)
    }
    var transformedBottomRightPoint:CGPoint{
        return transformedPointInSuperView(bottomRightPoint)
    }
    var path:UIBezierPath{
        let path = UIBezierPath()
        path.move(to: transformedTopLeftPoint)
        path.addLine(to: transformedTopRightPoint)
        path.addLine(to: transformedBottomRightPoint)
        path.addLine(to: transformedBottomLeftPoint)
        path.close()
        return path
    }
    var pathEmpty = UIBezierPath()
    var cancelImageView:MyCancelImageView!
    var stretchImageView:MyStretchImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        topLeftPoint = CGPoint(x: -frame.size.width/2, y: -frame.size.height/2)
        topRightPoint = CGPoint(x: frame.size.width/2, y: -frame.size.height/2)
        bottomLeftPoint = CGPoint(x: -frame.size.width/2, y: frame.size.height/2)
        bottomRightPoint = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
    }
    
    func transformedPointInSuperView(_ p:CGPoint)->CGPoint{
        let p1 = p.applying(transform)
        return CGPoint(x: p1.x + center.x, y: p1.y + center.y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var hasBorder = false
    
    func drawBorder(){
        hasBorder = true
        setNeedsDisplay()
    }
    
    func drawNoneBorder(){
        hasBorder = false
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if hasBorder == true {
            let path = UIBezierPath(rect: rect)
            UIColor.white.setStroke()
            path.lineWidth = 1.5
            path.stroke()
        }
        
    }
}


class MyView: UIView,HasBorder {
    
    var texts: [String]!
    var w:CGFloat!
    var h:CGFloat!
    var l:CGFloat!
    var bl:CGFloat!
    
    var cX:CGFloat!
    var cY:CGFloat!
    
//    var fontSize:CGFloat!
    var sW:CGFloat!
    var sH:CGFloat!
    
    var dic: [String : NSObject]!
//    var path: UIBezierPath!
    
    var isReverse = false
    
    var hasBorder = false
    
    static var shadow:NSShadow {
        get{
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.darkGray
            shadow.shadowOffset = CGSize(width: 1, height: 1)
            return shadow
        }
    }
    static var font = UIFont(name: "Heiti SC", size: 14)!
    static var dic = [NSFontAttributeName : MyView.font, NSForegroundColorAttributeName : UIColor.white, NSShadowAttributeName : MyView.shadow,]
    
    func drawBorder(){
        hasBorder = true
        setNeedsDisplay()
    }
    
    func drawNoneBorder(){
        hasBorder = false
        setNeedsDisplay()
    }
    
    
    
    convenience init(frame: CGRect,texts: [String]) {
        self.init(frame: frame)
        self.texts = texts
        self.backgroundColor = UIColor.clear
        
        h = self.frame.size.height
        w = self.frame.size.width
        
        sH = h/4
        sW = sH
        
        
        l = 6
        bl = l * 2
        
        cX = w/2
        cY = h/2
        
//        let shadow = NSShadow()
//        shadow.shadowColor = UIColor.darkGrayColor()
//        shadow.shadowOffset = CGSize(width: 2, height: 2)
//        
//        dic = [NSFontAttributeName : UIFont.systemFontOfSize(14),NSForegroundColorAttributeName : UIColor.whiteColor(), NSShadowAttributeName : shadow,]
        
        resizeLabelView()
    }
    
    func resizeLabelView(){
        var maxW:CGFloat = 0
        
        for text in texts {
            if text.trimmingCharacters(in: CharacterSet(charactersIn: " ")) != "" {
            
            let strW = ((text as NSString).size(attributes: MyView.dic)).width
            if maxW < strW {
                maxW = strW
            }
            }
            
        }
        
        let preCenter = center
        frame.size.width = 2 * ( maxW + sW + 10 )
        center = preCenter
        
        w = self.frame.size.width
        
        cX = w/2
        cY = h/2
    }
    
    override func draw(_ rect: CGRect)
    {
        let path2 = UIBezierPath(ovalIn: CGRect(x: cX - bl/2, y: cY - bl/2, width: bl , height: bl))
        UIColor.gray.setFill()
        path2.fill()
        
        let path1 = UIBezierPath(ovalIn: CGRect(x: cX - l/2, y: cY - l/2, width: l, height: l))
        UIColor.white.setFill()
        path1.fill()
        
        UIColor.white.setStroke()
        
//        var arrangedTexts:[String] = ["","",""]
//        
//        for var i = 0,j = 0;j < 3;j += 1 {
//            
//            if texts[j].trimmingCharacters(in: CharacterSet(charactersIn: " ")) != "" {
//                arrangedTexts[i] = texts[j]
//                i += 1
//            }
//                
//        }
        var arrangedTexts = texts.map { (str) -> String in
            return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        drawString(arrangedTexts[0], up: false, right: !isReverse)
        drawString(arrangedTexts[1], up: true, right: !isReverse)
        drawString(arrangedTexts[2], up: false, right: isReverse)
        
        if hasBorder == true {
            let path = UIBezierPath(rect: rect)
            UIColor.white.setStroke()
            path.lineWidth = 1.5
            path.stroke()
        }
        
        
    }
    
    
    func drawString(_ str:String, up:Bool, right:Bool){
        if str != "" {
//            path.moveToPoint(CGPointMake(cX, cY))
//            path.addLineToPoint(CGPointMake(cX + (right ? sW : -1 * sW), cY + (up ? -1 * sH : sH)))
//            var strW = ((str as NSString).sizeWithAttributes(MyView.dic)).width
//            path.addLineToPoint(CGPointMake(cX + (right ? (sW + strW + 5) : -1 * (sW + strW + 5)), cY + (up ? -1 * sH : sH)))
            
            let path2 = UIBezierPath()
            UIColor.gray.setStroke()
            let offsetY:CGFloat = 1
            path2.move(to: CGPoint(x: cX, y: cY + offsetY))
            path2.addLine(to: CGPoint(x: cX + (right ? sW : -1 * sW), y: cY + offsetY + (up ? -1 * sH : sH)))
            let strW = ((str as NSString).size(attributes: MyView.dic)).width
            path2.addLine(to: CGPoint(x: cX + (right ? (sW + strW + 5) : -1 * (sW + strW + 5)), y: cY + offsetY + (up ? -1 * sH : sH)))
            path2.stroke()

            let path = UIBezierPath()
            UIColor.white.setStroke()
            path.move(to: CGPoint(x: cX, y: cY))
            path.addLine(to: CGPoint(x: cX + (right ? sW : -1 * sW), y: cY + (up ? -1 * sH : sH)))
            path.addLine(to: CGPoint(x: cX + (right ? (sW + strW + 5) : -1 * (sW + strW + 5)), y: cY + (up ? -1 * sH : sH)))
            path.stroke()
            
            let font = MyView.dic[NSFontAttributeName] as! UIFont
            (str as NSString).draw(at: CGPoint(x: cX + (right ? (sW + 1) : -1 * (sW + strW + 4)) , y: cY + (up ? -1 * sH : sH) - font.pointSize - 5),
                withAttributes: MyView.dic)
        }
    }
    
}


