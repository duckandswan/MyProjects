//
//  EditImageViewController.swift
//  Work
//
//  Created by bob song on 15/8/11.
//  Copyright (c) 2015年 spring. All rights reserved.
//

import UIKit
import Photos

func findIndex<T: Equatable>(_ array: [T], valueToFind: T) -> Int? {
        
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

class EditImageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    weak var showAllImageController:ShowAllImageController!
    
    var selectedAssets:[PHAsset] = []
    var editedImageViewArr:[MyImageView] = []
    var editedImgArr:[UIImage] = []
    var needToCutImageViewArr:[MyImageView] = []
    
//    var selectedImageCollectionView: MySelectedImageCollectionView!
    var selectedImageCollectionView: UICollectionView!
    var editV:UIView!
    var imgV:MyImageView!
//    var stickerCollectionView:MyStickerCollectionView!
    var stickerCollectionView:UICollectionView!
    var label:UILabel!
    
    var labelController:LabelCreateController!
    var distributeController:DistributeController!
    
    var b1:UIButton!
    var b2:UIButton!
    var b3:UIButton!
    var b4:UIButton!
    
    
    let ratio:CGFloat = 1.48
    
    var imageManager:PHImageManager!
    
    var editedLabelView:MyView!
    
    var tapedPoint:CGPoint?
    
    var stickerArr:[UIImage] = []
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    func reloadImageView(){
        if !(editedImageViewArr as NSArray).contains(imgV) {
            showImageViewAt(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
        
        reloadImageView()
        
        
        self.selectedImageCollectionView.reloadSections(IndexSet(integer: 0))
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false

        self.title = "Edit"
        
        labelController = LabelCreateController()
        distributeController = DistributeController()
        
        labelController.delegate = self
        
        imageManager = PHImageManager()
        
        view.backgroundColor = UIColor.black


        let b1W:CGFloat = SCREEN_W / 7.5
        let b1H:CGFloat = SCREEN_H / 16
        

        let b2W:CGFloat = SCREEN_W / 4.5
        
//        let b3W:CGFloat = SCREEN_W / 2
//        let b3H:CGFloat = floor(SCREEN_H / 14)

        let sX:CGFloat = b1W
        let sY:CGFloat = 0
        let sW = SCREEN_W - b1W - b2W
        let sH:CGFloat = floor(SCREEN_H / 10)
        
        let b1Y:CGFloat = sY + (sH - b1H)/2
        let imgY = sH + sY
        let imgW = SCREEN_W
        let imgH = floor(1.48*imgW)
        
        let b3W:CGFloat = SCREEN_W / 2
        let b3H:CGFloat = SCREEN_H - sH - sY - imgH
        
        let stW:CGFloat = SCREEN_W
        let stH:CGFloat = SCREEN_H/6
        
//        let aView = UIView(frame: CGRect(x: 0, y: -1, width: SCREEN_W, height: 1))
//        view.addSubview(aView)
        
//        selectedImageCollectionView = MySelectedImageCollectionView(frame: CGRect(x: sX, y: sY, width: sW, height: sH), editImageViewController: self)
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .horizontal
        selectedImageCollectionView = UICollectionView(frame: CGRect(x: sX, y: sY, width: sW, height: sH), collectionViewLayout: flowLayout)
//        selectedImageCollectionView = UICollectionView(frame: CGRect(x: sX, y: sY, width: sW, height: sH))
//        selectedImageCollectionView.collectionViewLayout = flowLayout
        selectedImageCollectionView.dataSource = self
        selectedImageCollectionView.delegate = self
        selectedImageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell2")
        view.addSubview(selectedImageCollectionView)
        
        
        editV = UIView(frame: CGRect(x: 0, y: imgY, width: imgW, height: imgH))
        editV.backgroundColor = UIColor(red: 53/255.0, green: 54/255.0, blue: 55/255.0, alpha: 1)
        view.addSubview(editV)
        
        imgV = MyImageView(frame: CGRect(x: 0, y: 0, width: imgW, height: imgH))
        imgV.isUserInteractionEnabled = true
        imgV.clipsToBounds = true
        editV.addSubview(imgV)
                

        
//        var lH:CGFloat = stH
//        label = UILabel(frame: CGRectMake(0, imgY + imgH + (stH - lH)/2, stW, lH))
        
        label = UILabel(frame: editV.frame)
        label.backgroundColor = UIColor.gray
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 3
//        label.text = "拖动可以移动标签\n点击可修改或删除标签\n双击击可镜像标签"
        label.textColor = UIColor.white
        label.text = NSLocalizedString("点击照片添加标签", comment: "")
        label.isHidden = true
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(label)
        
        b1 = UIButton(frame: CGRect(x: 0, y: b1Y, width: b1W, height: b1H))
        b1.setImage(UIImage(named: "btn_back"), for: UIControlState())
        b1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b1.addTarget(self, action: #selector(EditImageViewController.back), for: UIControlEvents.touchUpInside)
        view.addSubview(b1)
        
        b2 = UIButton(frame: CGRect(x: b1W + sW, y: b1Y, width: b2W, height: b1H))
        b2.setTitle((NSLocalizedString("下一步", comment: "")), for: UIControlState())
        b2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b2.setTitleColor(UIColor.green, for: UIControlState.highlighted)
        b2.addTarget(self, action: #selector(EditImageViewController.nextStep), for: UIControlEvents.touchUpInside)
        view.addSubview(b2)
        

        
        
        b3 = UIButton(frame: CGRect(x: SCREEN_W / 2, y: SCREEN_H - b3H, width: b3W, height: b3H))
        b3.setTitle(NSLocalizedString("贴纸", comment: ""), for: UIControlState())
        b3.backgroundColor = UIColor.black
        b3.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b3.setTitleColor(UIColor.white, for: UIControlState())
        b3.setTitleColor(UIColor.red, for: UIControlState.selected)
        b3.addTarget(self, action: #selector(EditImageViewController.showStickers), for: UIControlEvents.touchUpInside)
        b3.isSelected = true
        view.addSubview(b3)
        
        
        
        b4 = UIButton(frame: CGRect(x: 0, y: SCREEN_H - b3H, width: b3W , height: b3H))
        b4.setTitle(NSLocalizedString("标签", comment: ""), for: UIControlState())
        b4.backgroundColor = UIColor.black
        b4.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        b4.setTitleColor(UIColor.white, for: UIControlState())
        b4.setTitleColor(UIColor.red, for: UIControlState.selected)
        b4.addTarget(self, action: #selector(EditImageViewController.clickLabelButton), for: UIControlEvents.touchUpInside)
        view.addSubview(b4)
       
        let lineView = UIView(frame: CGRect(x: (SCREEN_W - 1) / 2, y: SCREEN_H - b3H + 5, width: 1, height: b3H - 10))
        lineView.backgroundColor = UIColor(red: 239/255.0, green: 243/255.0, blue: 244/255.0, alpha: 1)
        view.addSubview(lineView)
    
        let flowLayout2 = UICollectionViewFlowLayout()
        
        flowLayout2.minimumLineSpacing = 10
        flowLayout2.minimumInteritemSpacing = 10
        flowLayout2.scrollDirection = .horizontal
//        stickerCollectionView = MyStickerCollectionView(frame: CGRect(x: 0, y: SCREEN_H - stH - b3H, width: stW, height: stH), editImageViewController: self)
        stickerCollectionView = UICollectionView(frame: CGRect(x: 0, y: SCREEN_H - stH - b3H, width: stW, height: stH), collectionViewLayout: flowLayout2)
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
        stickerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell3")
        stickerCollectionView.isHidden  = false
        view.addSubview(stickerCollectionView)
        
    }
    
    func back(){
        _ = self.navigationController?.popToViewController(showAllImageController, animated: true)
    }
    
    func nextStep(){
        
        b2.isEnabled = false
//        var tempEditedImgArr = editedImgArr
        editedImgArr = []
        
//        var number = 0
        for i in 0 ..< editedImageViewArr.count  {
            let iv = editedImageViewArr[i]
            if iv.edited == false{
                editedImgArr.append(iv.editedImage)
//                print( ++number )
            }else{
                
                iv.hideModification()
                
                UIGraphicsBeginImageContextWithOptions(iv.bounds.size, true, 0.0)
//                let context = UIGraphicsGetCurrentContext();
//                CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor);
//                CGContextFillRect(context, editV.bounds);
                iv.drawHierarchy(in: iv.bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                editedImgArr.append(screenshot!)
                iv.editedImage = screenshot
                iv.edited = false
                
                iv.showModification()
            }
            
            
        }
        
        
        if distributeController.editImageViewController == nil {
            distributeController.editImageViewController = self
        }
        
        navigationController?.pushViewController(distributeController, animated: true)
        b2.isEnabled = true
        
        
    }
    
    func showStickers() {
        showLabel(false)
    }

    
    func showImageViewAt(_ index:Int){
        if editedImageViewArr.count == 0{
            return
        }
        imgV.removeFromSuperview()
        imgV = editedImageViewArr[index]
        editV.addSubview(imgV)

    }
    
    func addStickerAtIndex(_ index:Int){
        let screenW = UIScreen.main.bounds.size.width
        
        let image = stickerArr[index]
        let stickerL = screenW/4
        var stickerW : CGFloat
        var stickerH : CGFloat
        if image.size.width <= image.size.height {
            stickerW = image.size.width * stickerL / image.size.height
            stickerH = stickerL
        }else{
            stickerW = stickerL
            stickerH = image.size.height * stickerL / image.size.width
        }
        
        
        let stickerView = MyStickerView(frame: CGRect(x: 0, y: 0, width: stickerW, height: stickerH))
        stickerView.backgroundColor = UIColor.clear
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
            action: #selector(EditImageViewController.handleImagePanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        stickerView.addGestureRecognizer(panGestureRecognizer)
        
        
        let pinchGestureRecognizer =  UIPinchGestureRecognizer(target: self,
            action: #selector(EditImageViewController.handlePinches(_:)))
        stickerView.addGestureRecognizer(pinchGestureRecognizer)

        let rotationRecognizer = UIRotationGestureRecognizer(target: self,
            action: #selector(EditImageViewController.handleRotations(_:)))
        stickerView.addGestureRecognizer(rotationRecognizer)
        
        let stickerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: stickerW, height: stickerH))
        stickerImageView.autoresizingMask = [UIViewAutoresizing.flexibleWidth,UIViewAutoresizing.flexibleHeight]
    
        stickerImageView.image = image
        stickerImageView.isUserInteractionEnabled = true
        stickerView.addSubview(stickerImageView)
        
        
        
        let cL:CGFloat = 20
        
        let cancelImageView = MyCancelImageView(frame: CGRect(x: 0, y: 0, width: cL, height: cL))
        cancelImageView.image = UIImage(named: "photo_sticker_cancle");
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(EditImageViewController.handleCancelTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cancelImageView.isUserInteractionEnabled = true
        cancelImageView.addGestureRecognizer(tapGestureRecognizer)
        cancelImageView.autoresizingMask = [UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleBottomMargin]
        cancelImageView.myStickerView = stickerView
        stickerView.cancelImageView = cancelImageView
        //        stickerView.addSubview(cancelImageView)
        
        let stretchImageView = MyStretchImageView(frame: CGRect(x: stickerL - cL, y: stickerL - cL, width: cL, height: cL))
        stretchImageView.image = UIImage(named: "photo_sticker_ stretch");
        stretchImageView.isUserInteractionEnabled = true
        let stretchPanGestureRecognizer = UIPanGestureRecognizer(target: self,
            action: #selector(EditImageViewController.handleStretchPanGesture(_:)))
        stretchPanGestureRecognizer.minimumNumberOfTouches = 1
        stretchImageView.addGestureRecognizer(stretchPanGestureRecognizer)
        stretchImageView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin , UIViewAutoresizing.flexibleTopMargin]
        stretchImageView.myStickerView = stickerView
        stickerView.stretchImageView = stretchImageView
        //        stickerView.addSubview(stretchImageView)
        
        //        if editImageViewController.imgV!.v != nil {
        //            editImageViewController.imgV!.bringSubviewToFront(editImageViewController.imgV!.v!)
        //        }
        
        setStickerImageView(stickerView)
        
//        b3.selected = true
    }
    
    func handleRotations(_ sender: UIRotationGestureRecognizer){
        let stickerView = (sender.view! as! MyStickerView)

        if sender.state != .ended && sender.state != .failed{
//            stickerView.transform  = stickerView.lastTransform.rotated(by: CGFloat(sender.rotation))
            stickerView.transform  = stickerView.transform.rotated(by: CGFloat(sender.rotation))
            sender.rotation = 0
            
            stickerView.stretchImageView.center = stickerView.transformedBottomRightPoint
            stickerView.cancelImageView.center = stickerView.transformedTopLeftPoint
            
            (sender.view!.superview as! MyImageView).startAntMarchAtPath(stickerView.path)
        }else{
//            stickerView.lastTransform = stickerView.transform
            (sender.view!.superview as! MyImageView).stopAntMarch()
        }
        
        
    }
    
    func handlePinches(_ sender: UIPinchGestureRecognizer){
        let stickerView = (sender.view! as! MyStickerView)
        
        if sender.state != .ended && sender.state != .failed{
//            stickerView.transform = stickerView.lastTransform.scaledBy(x: sender.scale, y: sender.scale)
            
            stickerView.transform = stickerView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
            
            stickerView.stretchImageView.center = stickerView.transformedBottomRightPoint
            stickerView.cancelImageView.center = stickerView.transformedTopLeftPoint
            
            (sender.view!.superview as! MyImageView).startAntMarchAtPath(stickerView.path)
        }else{
//            stickerView.lastTransform = stickerView.transform
            (sender.view!.superview as! MyImageView).stopAntMarch()
        }
    }

    func setEdited(){
        imgV.edited = true
    }
    
    func setStickerImageView(_ stickerView:MyStickerView){
        stickerView.center = CGPoint(x: imgV.frame.size.width/2, y: imgV.frame.size.height/2)
        imgV.addSubview(stickerView)
        stickerView.cancelImageView.center = stickerView.frame.origin
//        stickerView.lastCenter1 = CGPointMake(-stickerView.frame.size.width/2, -stickerView.frame.size.height/2)
        imgV.addSubview(stickerView.cancelImageView)
        stickerView.stretchImageView.center = CGPoint(x: stickerView.frame.maxX, y: stickerView.frame.maxY)
//        stickerView.lastCenter2 = CGPointMake(stickerView.frame.size.width/2, stickerView.frame.size.height/2)
        
        imgV.addSubview(stickerView.stretchImageView)
        imgV.stikerViewArr.append(stickerView)
        
        for i in 0 ..< imgV.labelViewArr.count {
            imgV.bringSubview(toFront: imgV.labelViewArr[i])
        }
        
        setEdited()
    }
    
    func removerStickerImageView(_ stickerView:MyStickerView){
        stickerView.cancelImageView.removeFromSuperview()
        stickerView.stretchImageView.removeFromSuperview()
        stickerView.removeFromSuperview()
        let i = findIndex(imgV.stikerViewArr, valueToFind: stickerView)
        imgV.stikerViewArr.remove(at: i!)
        
        setEdited()
    }
    

    func handleImagePanGesture(_ sender: UIPanGestureRecognizer){
        let stickerView = sender.view! as! MyStickerView
        imgV.showModification()
        if sender.state != .ended && sender.state != .failed{
            let translation = sender.translation(in: sender.view!.superview!)
            var center = sender.view!.center
            center.x += translation.x
            center.y += translation.y
            sender.view!.center = center
            
            stickerView.cancelImageView.center = CGPoint(x: stickerView.cancelImageView.center.x + translation.x, y: stickerView.cancelImageView.center.y + translation.y)
            stickerView.stretchImageView.center = CGPoint(x: stickerView.stretchImageView.center.x + translation.x, y: stickerView.stretchImageView.center.y + translation.y)
            
            sender.setTranslation(CGPoint.zero, in: sender.view!.superview!)
            
//            (sender.view!.superview as! MyImageView).drawPath(stickerView.path)
            (sender.view!.superview as! MyImageView).startAntMarchAtPath(stickerView.path)

            
        }else {
//            (sender.view!.superview as! MyImageView).drawPath(stickerView.pathEmpty)
            (sender.view!.superview as! MyImageView).stopAntMarch()

        }
        
        setEdited()
        
    }
    
    func handleLabelPanGesture(_ sender: UIPanGestureRecognizer){
        let myView = sender.view! as! MyView
        if sender.state != .ended && sender.state != .failed{
            let translation = sender.translation(in: sender.view!.superview!)
            var center = sender.view!.center
            center.x += translation.x
            center.y += translation.y
            sender.view!.center = center
            
            sender.setTranslation(CGPoint.zero, in: sender.view!.superview!)
//            (sender.view! as! HasBorder).drawBorder()
            (sender.view!.superview as! MyImageView).startAntMarchAtPath(UIBezierPath(rect: myView.frame))
            
        }else {
//            (sender.view! as! HasBorder).drawNoneBorder()
            (sender.view!.superview as! MyImageView).stopAntMarch()
        }
        
        setEdited()
    }
    
    func handleCancelTap(_ sender: UITapGestureRecognizer){
        
        let stickerView = (sender.view! as! MyCancelImageView).myStickerView
        removerStickerImageView(stickerView!)
        
        setEdited()
        
    }
    
    
    func handleStretchPanGesture(_ sender: UIPanGestureRecognizer){
        
        let stickerView = (sender.view! as! MyStretchImageView).myStickerView!
        if sender.state != .ended && sender.state != .failed{
            
            
            
            let point2 = sender.location(in: sender.view!.superview!)
            let translation = sender.translation(in: sender.view!.superview!)
            let point1 = CGPoint(x: point2.x  - translation.x, y: point2.y - translation.y)
            let center = stickerView.center
            
            let length1 = sqrt(pow(Double(point1.x - (center.x)), 2) + pow(Double(point1.y - (center.y)), 2))
            let length2 = sqrt(pow(Double(point2.x - (center.x)), 2) + pow(Double(point2.y - (center.y)), 2))
            
//            if length2 <= 20 {
//                length2 = 20
//            }
            
            let angle1 = atan2(Float(point1.y - (center.y)), Float(point1.x - (center.x)))
            let angle2 = atan2(Float(point2.y - (center.y)), Float(point2.x - (center.x)))
            let angle = angle2 - angle1
            
            let scale = length1 < 10 ? 1 : CGFloat(length2 / length1)
            
//            print("stickerView.transform \(stickerView.transform)")
            
//            stickerView?.transform  = (stickerView?.lastTransform.rotated(by: CGFloat(angle)))!
            stickerView.transform  = (stickerView.transform.rotated(by: CGFloat(angle)))
            
            stickerView.transform = (stickerView.transform.scaledBy(x: scale, y: scale))
            
            
            sender.setTranslation(CGPoint.zero, in: sender.view!.superview!)
            
            stickerView.stretchImageView.center = (stickerView.transformedBottomRightPoint)
            stickerView.cancelImageView.center = (stickerView.transformedTopLeftPoint)
            
//            stickerView.layer.borderWidth = 1/stickerView.transform.a
//            (sender.view!.superview as! MyImageView).drawPath(stickerView.path)

            (sender.view!.superview as! MyImageView).startAntMarchAtPath((stickerView.path))
            
        }else{
//            stickerView?.lastTransform = (stickerView?.transform)!
            
//            (sender.view!.superview as! MyImageView).drawPath(stickerView.pathEmpty)
            
            (sender.view!.superview as! MyImageView).stopAntMarch()

            
        }
        
        setEdited()
        
    }
    
    func handleImageTap(_ sender: UITapGestureRecognizer){
        if b4.isSelected == true {
            tapedPoint = sender.location(in: sender.view!)
            for value in labelController.textFields {
                value.text = ""
            }
            labelController.selectedImg = imgV.image
            labelController.isEdited = false
            navigationController?.pushViewController(labelController, animated: true)
        }else{

            
            if  !imgV.containPoint(sender.location(in: sender.view!)){
                stickerCollectionView.isHidden = true
                b3.isSelected = false
                imgV.hideModification()
            }else{
//                stickerCollectionView.hidden = false
                imgV.showModification()
            }
        }
    }
    
    func clickLabelButton(){
        showLabel(true)
    }
    
    func toCreateLabel() {
        
        tapedPoint = nil
        for value in labelController.textFields {
            value.text = ""
        }
        labelController.selectedImg = imgV.image
        labelController.isEdited = false
        navigationController?.pushViewController(labelController, animated: true)
    }
    
    
    func createLabel(_ texts: [String]) {
        
        var textsAreEmpty = true
        for i in 0 ..< texts.count {
            if texts[i].trimmingCharacters(in: CharacterSet(charactersIn: " ")) != "" {
                textsAreEmpty = false
                break
            }
        }
        if textsAreEmpty == true {
            return
        }
        
        
        let labelView = MyView(frame: CGRect(x: 0, y: 0, width: 200, height: 80), texts: texts)
        if tapedPoint == nil {
            labelView.center = CGPoint(x: imgV.frame.size.width/2, y: imgV.frame.size.height/2)
        }else{
            labelView.center = tapedPoint!
        }

        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
            action: #selector(EditImageViewController.handleLabelPanGesture(_:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        labelView.addGestureRecognizer(panGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(EditImageViewController.handleLabelTaps(_:)))
        
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        labelView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let oneTapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(EditImageViewController.handleLabelOneTap(_:)))
        
        oneTapGestureRecognizer.numberOfTapsRequired = 1
        labelView.addGestureRecognizer(oneTapGestureRecognizer)
        
        oneTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
        imgV.labelViewArr.append(labelView)
        imgV.addSubview(labelView)
        
        label.isHidden = true
        
        setEdited()
    }
    
    func showLabel(_ b:Bool){
        b3.isSelected = !b
        b4.isSelected = b
        label.isHidden = !b
        stickerCollectionView.isHidden = b
    }
    
    func editLabel(_ texts: [String]){
        editedLabelView.texts = texts
        editedLabelView.resizeLabelView()
        editedLabelView.setNeedsDisplay()
        
//        showLabel(true)
        
        setEdited()
        
    }
    
    func deleteLabel(){
        
        editedLabelView.removeFromSuperview()
        let i = findIndex(imgV.labelViewArr, valueToFind: editedLabelView)
        imgV.labelViewArr.remove(at: i!)
        if imgV.labelViewArr.count == 0 {
//            b4.selected = false
//            showLabel(false)
//            label.text = "点击照片添加标签"
        }
        
        setEdited()
    }

    func handleLabelTaps(_ sender: UITapGestureRecognizer) {
        let v = sender.view as! MyView
        v.isReverse = !v.isReverse
        v.setNeedsDisplay()
        
        setEdited()
    }
    
    func handleLabelOneTap(_ sender: UITapGestureRecognizer) {
        let v = sender.view as! MyView
        editedLabelView = v
        for i in 0...2 {
           labelController.textFields[i].text = v.texts[i]
        }
        labelController.selectedImg = imgV.image
        labelController.isEdited = true
        navigationController?.pushViewController(labelController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == selectedImageCollectionView {
            return selectedAssets.count == 9 ? 9 : selectedAssets.count + 1
        }else{
            return stickerArr.count
        }
        
    }
    
    var selectedindex = 0
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selectedImageCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath)
            
            if cell.contentView.viewWithTag(100) == nil {
                
                let imageview = UIImageView(frame: cell.contentView.bounds)
                imageview.tag = 100
                imageview.isUserInteractionEnabled = true
                imageview.contentMode = UIViewContentMode.scaleAspectFill
                imageview.clipsToBounds = true
                
                cell.contentView.addSubview(imageview)
                
                //            cell.selectedBackgroundView = CustomCellBackground(frame: cell.contentView.bounds)
                //            cell.backgroundColor = UIColor.whiteColor()
                
                
            }
            let imageview = cell.contentView.viewWithTag(100) as! UIImageView
            
            if indexPath.row == selectedAssets.count {
                imageview.image = UIImage(named: "btn_add_photo")
            }else{
                let asset = selectedAssets[indexPath.row]
                showAllImageController.setLowQualityImageView(imageview, asset: asset)
            }
            
            if indexPath.row == selectedAssets.count {
                cell.backgroundColor = UIColor.clear
            }else {
                cell.backgroundColor = UIColor.white
            }
            
            if selectedindex == indexPath.row {
                cell.contentView.alpha = 0.5
            }else{
                cell.contentView.alpha = 1
            }
            
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath)
            
            // Configure the cell
            if cell.contentView.viewWithTag(100) == nil {
                
                let imageview = UIImageView(frame: cell.contentView.bounds)
                imageview.tag = 100
                imageview.isUserInteractionEnabled = true
                imageview.contentMode = UIViewContentMode.scaleToFill
                cell.contentView.addSubview(imageview)
                cell.contentView.backgroundColor = UIColor.gray
                
            }
            let imageview = cell.contentView.viewWithTag(100) as! UIImageView
            imageview.image = stickerArr[indexPath.row]
            
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == selectedImageCollectionView {
            let cellW = collectionView.frame.size.width / 4.7
            let cellH = cellW
            
            return CGSize(width: cellW, height: cellH)
        }else{
            let cellW = collectionView.frame.size.width / 5
            let cellH = cellW
            return CGSize(width: cellW, height: cellH)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == selectedImageCollectionView {
            if indexPath.row == selectedAssets.count {
                back()
                return
            }
            
            if selectedindex == indexPath.row{
                return
            }
            
            selectedindex = indexPath.row
            collectionView.reloadSections(IndexSet(integer: 0))
            
            showImageViewAt(indexPath.row)
        }else{
            addStickerAtIndex(indexPath.row)
        }
        
    }
    
    

//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        //        print("stickerArr.count:\(stickerArr.count)")
//        return stickerArr.count
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell3", forIndexPath: indexPath)
//        
//        // Configure the cell
//        if cell.contentView.viewWithTag(100) == nil {
//            
//            let imageview = UIImageView(frame: cell.contentView.bounds)
//            imageview.tag = 100
//            imageview.userInteractionEnabled = true
//            imageview.contentMode = UIViewContentMode.ScaleToFill
//            cell.contentView.addSubview(imageview)
//            cell.contentView.backgroundColor = UIColor.grayColor()
//            
//        }
//        let imageview = cell.contentView.viewWithTag(100) as! UIImageView
//        imageview.image = stickerArr[indexPath.row]
//        
//        
//        
//        return cell
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let cellW = collectionView.frame.size.width / 5
//        let cellH = cellW
//        return CGSizeMake(cellW, cellH)
//    }
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        addStickerAtIndex(indexPath.row)
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
