//
//  CutViewController.swift
//  finding
//
//  Created by bob song on 15/10/20.
//  Copyright © 2015年 zhangli. All rights reserved.
//

import UIKit

class CutViewController: UIViewController {
    weak var showAllImageController:ShowAllImageController!
    var currentNeedToCutImageIndex = 0
    var cutImageViewArr:[MyImageView] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        if cutImageViewArr.count > 0{
            maskView.isHidden = false
            cutLabel.text = "裁切( \(currentNeedToCutImageIndex + 1)/\(cutImageViewArr.count) )"
            nextImageButton.setTitle("下一张", for: UIControlState())
            if currentNeedToCutImageIndex == cutImageViewArr.count - 1{
                nextImageButton.setTitle("完成", for: UIControlState())
            }
            
            setMoveImageView()
            
        }else{
            maskView.isHidden = true
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b1W:CGFloat = SCREEN_W / 5
        let b1H:CGFloat = 25
        
        
        
        let sH:CGFloat = floor(SCREEN_H / 10)
        

        let imgW = SCREEN_W
        let imgH = floor(1.48*imgW)
        

        
        
        maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor.gray
        view.addSubview(maskView)
        let v1W = SCREEN_W
        let v1H = v1W * 4 / 3
        let v1Y = (imgH - v1H ) / CGFloat(2) + sH
        
        
        

        
        v1 = UIView(frame: CGRect(x: 0, y: v1Y, width: v1W, height: v1H))
        maskView.addSubview(v1)
        
        
        
        moveImageView = UIImageView(frame: view.bounds)
        
        moveImageView.isUserInteractionEnabled = true
        moveImageView.clipsToBounds = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
            action: #selector(CutViewController.handleMoveImagePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        moveImageView.addGestureRecognizer(panGestureRecognizer)
        v1.addSubview(moveImageView)
        
        v2 = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: sH))
        v2.backgroundColor = UIColor.black
        nextImageButton = UIButton(frame: CGRect( x: SCREEN_W - b1W - 20, y: (sH - b1H)/2, width: b1W, height: b1H))
        nextImageButton.setTitle("下一张", for: UIControlState())
        nextImageButton.setTitleColor(UIColor.green, for: UIControlState.highlighted)
        if currentNeedToCutImageIndex == cutImageViewArr.count - 1{
            nextImageButton.setTitle("完成", for: UIControlState())
        }
        nextImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextImageButton.addTarget(self, action: #selector(CutViewController.nextImage), for: UIControlEvents.touchUpInside)
        v2.addSubview(nextImageButton)
        
        cutLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_W/3, height: 21))
        cutLabel.center = v2.center
        cutLabel.textColor = UIColor.white
        cutLabel.font = UIFont.systemFont(ofSize: 15)
        cutLabel.textAlignment = NSTextAlignment.center
        cutLabel.text = "裁切( 1/\(cutImageViewArr.count)) "
        v2.addSubview(cutLabel)
        
        maskView.addSubview(v2)
        v3 = UIView(frame: CGRect(x: 0, y: sH, width: SCREEN_W, height: v1Y - sH ))
        v3.backgroundColor = UIColor.black
        v3.alpha = 0.5
        maskView.addSubview(v3)
        v4 = UIView(frame: CGRect(x: 0, y: v1Y + v1H, width: SCREEN_W, height: SCREEN_H - (v1Y + v1H) ))
        v4.backgroundColor = UIColor.black
        v4.alpha = 0.5
        maskView.addSubview(v4)
    }
    var v1:UIView!
    var v2:UIView!
    var v3:UIView!
    var v4:UIView!
    var moveImageView:UIImageView!
    var scrollView:UIScrollView!
    var maskView:UIView!
    var nextImageButton:UIButton!
    var cutLabel:UILabel!
    func handleMoveImagePanGesture(_ sender: UIPanGestureRecognizer){
        let size = (sender.view as! UIImageView).image!.size
        if sender.state != .ended && sender.state != .failed{
            let translation = sender.translation(in: sender.view!.superview!)
            
            var frame = sender.view!.frame
            
            if size.height > size.width{
                frame.origin.y += translation.y
                
                if frame.origin.y > 0 {
                    frame.origin.y = CGFloat(0)
                }
                if (frame.origin.y + frame.size.height) < sender.view!.superview!.frame.size.height{
                    frame.origin.y = sender.view!.superview!.frame.size.height - frame.size.height
                }
            }else{
                frame.origin.x += translation.x
                
                if frame.origin.x > 0 {
                    frame.origin.x = 0
                }
                if (frame.origin.x + frame.size.width) < sender.view!.superview!.frame.size.width{
                    frame.origin.x = sender.view!.superview!.frame.size.width - frame.size.width
                }
            }
            
            sender.view!.frame = frame
           
            
            
            
            
            
            
            sender.setTranslation(CGPoint.zero, in: sender.view!.superview!)
            
        }
    }
    func setMoveImageView(){
        moveImageView.image = nil
        showAllImageController.setFrameAndImageForImageView(moveImageView,asset: cutImageViewArr[currentNeedToCutImageIndex].asset)
    }
    func nextImage(){
        UIGraphicsBeginImageContextWithOptions(v1.bounds.size, true, 0.0)
        v1.drawHierarchy(in: v1.bounds, afterScreenUpdates: true)
        cutImageViewArr[currentNeedToCutImageIndex].image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        currentNeedToCutImageIndex += 1
        
        
        if currentNeedToCutImageIndex < cutImageViewArr.count{
            
            setMoveImageView()
            if currentNeedToCutImageIndex == cutImageViewArr.count - 1{
                nextImageButton.setTitle("完成", for: UIControlState())
            }
        }else{
            maskView.isHidden = true
            cutImageViewArr = []
            currentNeedToCutImageIndex = 0
            showAllImageController.toEditImageViewController()
        }
        cutLabel.text = "裁切( \(currentNeedToCutImageIndex + 1)/\(cutImageViewArr.count) )"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
