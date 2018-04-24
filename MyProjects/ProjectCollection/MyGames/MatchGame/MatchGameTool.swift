//
//  Tool.swift
//  MyAppCollection
//
//  Created by tarena on 15/7/13.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

import UIKit


class MatchGameTool:NSObject{
    static var imageNames:[String] = []
    
    static var images:[UIImage] = []
    
    static func pairedArray<T>(_ n: Int, ary:[T] )->[T]{
        var selectedArr:[T] = []
        for i in 0 ..< n  {
            selectedArr.append(ary[i])
        }
        randomizeArray(&selectedArr)
        
        var pairedArray = Array<T>(repeating: ary[0], count: n * 2)
        for i in 0 ..< n  {
            pairedArray[i] = selectedArr[i]
            pairedArray[n + i] = selectedArr[i]
        }
        randomizeArray(&pairedArray)
        
        
        return pairedArray
    }
    
    static func randomizeArray<T>(_ ary:inout [T]){
        for i in 0 ..< ary.count {
            let j = Int(arc4random_uniform(UInt32(ary.count - i))) + i;
            if i != j{
                swap(&ary[i], &ary[j])
            }
            
        }
    }
    
    static func setImageNames() {
//        let paths = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: nil)
//        for path in paths {
//            let name = (path as NSString).lastPathComponent
//            if name.hasPrefix("lol"){
//                imageNames.append(name)
//            }
//        }
        for i in 1...10 {
             imageNames.append("lol\(i)")
        }
        imageNames.random()
    }
    
    static func getPairedImages(_ n:Int)->[UIImage]{
        if imageNames.count == 0 {
            setImageNames()
            
            print(imageNames)
            for name in imageNames {
                images.append(UIImage(named: name)!)
            }
        }
        
        
        return pairedArray(n, ary: images)
    }

}




//extension UIButton{
//    func open(){
//        let anim = CABasicAnimation(keyPath: "transform")
//        anim.fromValue = NSValue(caTransform3D: CATransform3DRotate(CATransform3DIdentity, CGFloat(0), 0.0, 1.0, 0.0))
//        
//        anim.toValue = NSValue(caTransform3D:CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI), 0.0, 1.0, 0.0))
//        anim.duration = timeInterval
//        self.layer.add(anim, forKey: nil)
//        
//        Timer.scheduledTimer(timeInterval: timeInterval/2, target: self, selector: #selector(UIButton.selected as (UIButton) -> () -> ()), userInfo: nil, repeats: false)
//    }
//    func selected(){
//        self.isSelected = true
//        self.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI), 0.0, 1.0, 0.0)
//    }
//    func close(){
//        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(UIButton.closeAnimate), userInfo: nil, repeats: false)
//        
//    }
//    func closeAnimate(){
//        let anim = CABasicAnimation(keyPath: "transform")
//        anim.fromValue = NSValue(caTransform3D:CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI), 0.0, 1.0, 0.0))
//        
//        anim.toValue = NSValue(caTransform3D:CATransform3DRotate(CATransform3DIdentity, CGFloat(0), 0.0, 1.0, 0.0))
//        anim.duration = timeInterval
//        self.layer.add(anim, forKey: nil)
//        Timer.scheduledTimer(timeInterval: timeInterval/2, target: self, selector: #selector(UIButton.deselected), userInfo: nil, repeats: false)
//    }
//    func deselected(){
//        self.isSelected = false
//        self.layer.transform = CATransform3DIdentity
//    }
//}

class MatchGameButton:UIButton{
    static var timeInterval:TimeInterval = 0.5
    func open(){
        let anim = CABasicAnimation(keyPath: "transform")
        anim.fromValue = NSValue(caTransform3D: CATransform3DRotate(CATransform3DIdentity, CGFloat(0), 0.0, 1.0, 0.0))
        
        anim.toValue = NSValue(caTransform3D:CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI), 0.0, 1.0, 0.0))
        anim.duration = MatchGameButton.timeInterval
        self.layer.add(anim, forKey: nil)
        
        Timer.scheduledTimer(timeInterval: MatchGameButton.timeInterval/2, target: self, selector: #selector(MatchGameButton.selected as (MatchGameButton) -> () -> ()), userInfo: nil, repeats: false)
    }
    func selected(){
        self.isSelected = true
        self.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI), 0.0, 1.0, 0.0)
    }
    func close(){
        Timer.scheduledTimer(timeInterval: MatchGameButton.timeInterval, target: self, selector: #selector(MatchGameButton.closeAnimate), userInfo: nil, repeats: false)
        
    }
    func closeAnimate(){
        let anim = CABasicAnimation(keyPath: "transform")
        anim.fromValue = NSValue(caTransform3D:CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI), 0.0, 1.0, 0.0))
        
        anim.toValue = NSValue(caTransform3D:CATransform3DRotate(CATransform3DIdentity, CGFloat(0), 0.0, 1.0, 0.0))
        anim.duration = MatchGameButton.timeInterval
        self.layer.add(anim, forKey: nil)
        Timer.scheduledTimer(timeInterval: MatchGameButton.timeInterval/2, target: self, selector: #selector(MatchGameButton.deselected), userInfo: nil, repeats: false)
    }
    func deselected(){
        self.isSelected = false
        self.layer.transform = CATransform3DIdentity
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle(title, for: state)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 100.0)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.15
    }
}

class MyTimeLabel:UILabel{
    static var maxTime = 60
    var time = 0
    var timer:Timer?
    var passed = false
    
    func reset(){
        text = String(MyTimeLabel.maxTime)
        stop()
    }
    func start(){
        time = MyTimeLabel.maxTime
        passed = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MyTimeLabel.timing), userInfo: nil, repeats: true)
    }
    func timing(){
        time -= 1
        if time >= 0 {
            text = String(time)
        }else{
            timer?.invalidate()
            passed = true
        }
    }
    func stop(){
        timer?.invalidate()
    }
}

extension UIImageView{
    //Method 2
    func changeToBlurImage()
    {
        if let imageToBlur = image {
            let initialImage = CIImage(cgImage: imageToBlur.cgImage!)
            
            let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")!
            gaussianBlurFilter.setValue(CIImage(cgImage: imageToBlur.cgImage!), forKey:kCIInputImageKey)
            
            
            let filter = CIFilter(name: "CIExposureAdjust")!
            filter.setValue(gaussianBlurFilter.outputImage, forKey:kCIInputImageKey)
            filter.setValue(2.5, forKey: kCIInputEVKey)

            
            let finalImage = filter.outputImage
            let finalImagecontext = CIContext(options: nil)
            
            let finalCGImage = finalImagecontext.createCGImage(finalImage!, from: initialImage.extent)
            self.image = UIImage(cgImage: finalCGImage!)
        }
    }
}
