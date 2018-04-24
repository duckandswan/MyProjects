//
//  ShowAllImagController.swift
//  Work
//
//  Created by bob song on 15/8/11.
//  Copyright (c) 2015年 spring. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import WebKit

let SCREEN_W = UIScreen.main.bounds.size.width
let SCREEN_H = UIScreen.main.bounds.size.height
let STATUS_H = UIApplication.shared.statusBarFrame.size.height

func AdjustedImageSize(width iW:CGFloat,hight iH:CGFloat)->CGSize{
    if UIScreen.main.bounds.size.width == 414 {
        return CGSize(width: iW * 3, height: iH * 3)
    }else {
        return CGSize(width: iW * 2, height: iH * 2)
    }
}

func AdjustedImageSize(_ size:CGSize)->CGSize{
    if UIScreen.main.bounds.size.width == 414 {
        return CGSize(width: size.width * 3, height: size.height * 3)
    }else {
        return CGSize(width: size.width * 2, height: size.height * 2)
    }
}

class ShowAllImageController: UICollectionViewController, UICollectionViewDelegateFlowLayout{

    var photoTalkId:String? //讨论照相对应话题id
    
    let maxNumber = 9
    var selectedAssets:[PHAsset] = []
    
    var options : PHFetchOptions!
    var assetsFetchResult:PHFetchResult<PHAsset>!
    var imageManager:PHImageManager = PHImageManager()
    var pHImageRequestOptions:PHImageRequestOptions!
    
    var ShootingDate:Date!

    var editImageViewController = EditImageViewController()
    
//    func initPhotoTalkId(_ photoTalkId:String?){
//        self.photoTalkId = photoTalkId
//    }
    
    
    func cameraDidSavePhotoAtPath(_ assetURL: URL!) {
        getAssetsFetchResultAndReLoad()
    }
    
    
    func cameraDidSelectAlbumPhoto(_ image: UIImage!) {
        //ImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        setRightBarButtonItemTitle()

        collectionView?.reloadData()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell1")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem( title: "",
            style: .plain,
            target: self,
            action: #selector(ShowAllImageController.nextStep))
        
        collectionView?.backgroundColor = UIColor.white
        
        options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        options.predicate = NSPredicate(format: "pixelHeight >= 150 AND pixelWidth >= 150")
        
        assetsFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image,
            options: options)
        pHImageRequestOptions = PHImageRequestOptions()
        pHImageRequestOptions.isSynchronous = true
        pHImageRequestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        
        editImageViewController.showAllImageController = self
        
        for i in 1..<13 {
            self.editImageViewController.stickerArr.append(UIImage(named: "sticker_\(i)")!)
        }
        

    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    let taskGroup =  DispatchGroup()
    let mainQueue =  DispatchQueue.main
    
    func executeInGroup(){
        self.mainQueue.async(group: self.taskGroup, execute: { () -> Void in
            
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    func leftBarButtonItemClick(){
        _ = self.navigationController?.popViewController(animated: true)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
//    convenience required init() {
//        let flowLayout = UICollectionViewFlowLayout()
//        
//        flowLayout.minimumLineSpacing = 1
//        flowLayout.minimumInteritemSpacing = 1
//        flowLayout.scrollDirection = .vertical
//        
//        
//        self.init(collectionViewLayout: flowLayout)
//    }
    
    func setRightBarButtonItemTitle(){
       navigationItem.rightBarButtonItem?.title = "(\(selectedAssets.count)/\(maxNumber))\(NSLocalizedString("下一步", comment: ""))"
    }
    func getAssetsFetchResultAndReLoad(){
        assetsFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image,
            options: options)
        selectedAssets.append(assetsFetchResult[0])
        setRightBarButtonItemTitle()
        collectionView?.reloadData()
    }
    



    func setLowQualityImageView(_ imageView:UIImageView,asset:PHAsset){
        
        imageManager.requestImage(for: asset, targetSize:CGSize(width: 150, height: 150) , contentMode: PHImageContentMode.aspectFill
            , options:nil ) { (result, info) -> Void in
            DispatchQueue.main.async(execute: {
                if result != nil {
                    imageView.image = result
                }
                
            })
        }
    }
    
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return assetsFetchResult.count + 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) 
        
    
        if cell.contentView.viewWithTag(100) == nil {
 
            let imageview = UIImageView(frame: cell.contentView.bounds)
            imageview.tag = 100
            imageview.isUserInteractionEnabled = true
            imageview.contentMode = UIViewContentMode.scaleAspectFill
            imageview.clipsToBounds = true
            
            cell.contentView.addSubview(imageview)
            
            let selectView = UIImageView(frame: CGRect(x: cell.contentView.bounds.size.width - 30, y: 10, width: 20, height: 20))
            selectView.image = UIImage(named: "forward_select")
            selectView.tag = 101
            cell.contentView.addSubview(selectView)
            
        }
        let imageview = cell.contentView.viewWithTag(100) as! UIImageView
        let selectView = cell.contentView.viewWithTag(101) as! UIImageView
        if indexPath.row == 0 {
            imageview.image = UIImage(named: "btn_Photograph")!
        }else {
            let asset = assetsFetchResult[indexPath.row - 1] 
            
            setLowQualityImageView(imageview, asset: asset)
        }
        if indexPath.row != 0{
            if (selectedAssets as NSArray).contains(assetsFetchResult[indexPath.row - 1] ){
                selectView.isHidden = false
            }else {
                selectView.isHidden = true
            }
        }else{
            selectView.isHidden = true
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellW = (SCREEN_W - 2) / 3
        let cellH = cellW
        return CGSize(width: cellW, height: cellH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if selectedAssets.count == maxNumber {
                return
            }
//            let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
//            if status == AVAuthorizationStatus.authorized {
//                
//            } else if status == AVAuthorizationStatus.notDetermined {
//                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) -> Void in
//                    
//                })
//            } else {
//               
//            }
            
            return
        }
        
        
        if selectedAssets.count == maxNumber && !(selectedAssets as NSArray).contains(assetsFetchResult[indexPath.row - 1]) {
            return
        }
        let selectView = collectionView.cellForItem(at: indexPath)?.contentView.viewWithTag(101) as! UIImageView
        
        if !(selectedAssets as NSArray).contains(assetsFetchResult[indexPath.row - 1]) {
            selectedAssets.append((assetsFetchResult[indexPath.row - 1] ))
            selectView.isHidden = false

        }else{
            for (index, value) in selectedAssets.enumerated() {
                if value == (assetsFetchResult[indexPath.row - 1] ) {
                    selectedAssets.remove(at: index)
                    break
                }
            }
            selectView.isHidden = true
        }

        
        setRightBarButtonItemTitle()
    }
    func nextStep(){
        
        if selectedAssets.count == 0{
            return
        }
        
        resetEditedImageViewArr()
        
        if cutImageViewArr.count > 0{
            let c = CutViewController()
            c.showAllImageController = self
            c.cutImageViewArr = self.cutImageViewArr
            navigationController?.pushViewController(c, animated: true)
        }else{
            toEditImageViewController()
        }
        
        
        
    }
    
    
    func toEditImageViewController(){
        for iv in loadImageViewArr{
            setImageForMyImageView(iv)
        }
        navigationController?.pushViewController(editImageViewController, animated: false)
    }
    
    var cutImageViewArr:[MyImageView] = []
    var loadImageViewArr:[MyImageView] = []
    func resetEditedImageViewArr() {
        cutImageViewArr = []
        loadImageViewArr = []
        var tempEditedImageViewArr = editImageViewController.editedImageViewArr
        editImageViewController.editedImageViewArr = []
        
        for i in 0 ..< selectedAssets.count {
            
            
            let asset = selectedAssets[i]
            
            
            if let  j = findIndex(editImageViewController.selectedAssets,valueToFind: asset) {
                editImageViewController.editedImageViewArr.append(tempEditedImageViewArr[j])
            }else{
                
                generateImageViewForAsset(asset)
                
                
            }
            
        }
        
        editImageViewController.selectedAssets = selectedAssets
        
        
    }
    
    func setFrameAndImageForImageView(_ targetIv:UIImageView,asset:PHAsset){
        
        
        let vW = UIScreen.main.bounds.size.width
        let vH = UIScreen.main.bounds.size.width * 4/3
        
        let pixelWidth = CGFloat(asset.pixelWidth)
        let pixelHeight = CGFloat(asset.pixelHeight)
        
        var rectW : CGFloat
        var rectH : CGFloat
        
        let targetSize:CGSize!
        
        if pixelHeight <  pixelWidth {
            
            rectW = pixelWidth * vH / pixelHeight
            rectH = vH
            
        }else{
            
            rectW = vW
            rectH = pixelHeight * vW / pixelWidth
            
        }
        
        targetIv.frame = CGRect(x: 0, y: 0, width: rectW, height: rectH)
        targetSize = AdjustedImageSize(width: rectW, hight: rectH)
        
        
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: pHImageRequestOptions) { (result, info) -> Void in
            print("setFrameAndImageForImageView result:\(result)")
            targetIv.image = result
        }
        
    }
    
    func setImageForMyImageView(_ iv:MyImageView){
        
        let ratio = self.editImageViewController.ratio
        
        let vW = UIScreen.main.bounds.size.width
        let vH = floor(ratio * UIScreen.main.bounds.size.width)
        

        
        let targetSize = AdjustedImageSize(width: vW, hight: vH)



        imageManager.requestImage(for: iv.asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFit, options: pHImageRequestOptions) { (result, info) -> Void in
//            print("setImageForMyImageView asset \(iv.asset.pixelWidth)")
//            print("setImageForMyImageView result \(result!.size.width)")
//            print("setImageForMyImageView result \(result!.scale)")
            iv.image = result

            
        }

    }
    
    func generateImageViewForAsset(_ asset:PHAsset){
        
//        print("generateImageViewForAsset asset \(asset.pixelWidth)")
        let ratio = self.editImageViewController.ratio
    
        let pixelWidth = CGFloat(asset.pixelWidth)
        let pixelHeight = CGFloat(asset.pixelHeight)
        
        let vW = UIScreen.main.bounds.size.width
        let vH = floor(ratio * UIScreen.main.bounds.size.width)
        

        var ivX : CGFloat
        var ivY : CGFloat
        var ivW : CGFloat
        var ivH : CGFloat
        
        
        var iv:MyImageView!
        if pixelHeight >  2 * pixelWidth {
            
            ivW = vW
            ivH = vW*4/3
            ivX = 0
            ivY = (vH - ivH)/2
            iv = MyImageView(frame: CGRect(x: ivX, y: ivY, width: ivW, height: ivH))
            cutImageViewArr.append(iv)
            
        }else if 2 * pixelHeight < pixelWidth{
            
            ivW = vW
            ivH = vW*4/3
            ivX = 0
            ivY = (vH - ivH)/2
            iv = MyImageView(frame: CGRect(x: ivX, y: ivY, width: ivW, height: ivH))
            cutImageViewArr.append(iv)
            
        }else if pixelHeight >=  floor(ratio * pixelWidth) {
                
            ivW = pixelWidth * vH / pixelHeight
            ivH = vH
            ivX = (vW - ivW)/2
            ivY = 0
            iv = MyImageView(frame: CGRect(x: ivX, y: ivY, width: ivW, height: ivH))
            loadImageViewArr.append(iv)
                
        }else{
                
            ivW = vW
            ivH = pixelHeight * vW / pixelWidth
            ivX = 0
            ivY = (vH - ivH)/2
            iv = MyImageView(frame: CGRect(x: ivX, y: ivY, width: ivW, height: ivH))
            loadImageViewArr.append(iv)
        }

        iv.asset = asset
        
        iv.tag = 105
            
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self.editImageViewController,
            action: "handleImageTap:")
        tapGestureRecognizer.numberOfTapsRequired = 1
        iv.addGestureRecognizer(tapGestureRecognizer)
        
        self.editImageViewController.editedImageViewArr.append(iv)
            
        
        
    }

    
    
    
    func CameraClick(){
//        ShootingDate = NSDate()
        getAssetsFetchResultAndReLoad()
    }



}

