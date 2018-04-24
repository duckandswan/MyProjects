//
//  SelectedImageController.swift
//  Work
//
//  Created by bob song on 15/8/11.
//  Copyright (c) 2015年 spring. All rights reserved.
//

import UIKit



//class SelectedImageController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
//    weak var editImageViewController:EditImageViewController!
//    var selectedindex = 0
//
//
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.useLayoutToLayoutNavigationTransitions = false
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
//        return editImageViewController.selectedAssets.count == 9 ? 9 : editImageViewController.selectedAssets.count + 1
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) 
//
//    
//        // Configure the cell
//        if cell.contentView.viewWithTag(100) == nil {
//            
//            let imageview = UIImageView(frame: cell.contentView.bounds)
//            imageview.tag = 100
//            imageview.isUserInteractionEnabled = true
//            imageview.contentMode = UIViewContentMode.scaleAspectFill
//            imageview.clipsToBounds = true
//            
//            cell.contentView.addSubview(imageview)
//            
////            cell.selectedBackgroundView = CustomCellBackground(frame: cell.contentView.bounds)
////            cell.backgroundColor = UIColor.whiteColor()
//            
//            
//        }
//        let imageview = cell.contentView.viewWithTag(100) as! UIImageView
//        
//        
//        if indexPath.row == editImageViewController.selectedAssets.count {
//            imageview.image = UIImage(named: "btn_add_photo")
//        }else{
//            let asset = editImageViewController.selectedAssets[indexPath.row]
////            imageview.image = editImageViewController.showAllImageController.getLowQualityImageFromAsset(asset)
//            editImageViewController.showAllImageController.setLowQualityImageView(imageview, asset: asset)
//        }
//        if indexPath.row == editImageViewController.selectedAssets.count {
//            cell.backgroundColor = UIColor.clear
//        }else {
//            cell.backgroundColor = UIColor.white
//        }
//        
//        if selectedindex == indexPath.row {
//            cell.contentView.alpha = 0.5
//        }else{
//            cell.contentView.alpha = 1
//        }
//        
//    
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellW = collectionView.frame.size.width / 4.7
//        let cellH = cellW
//        
//        return CGSize(width: cellW, height: cellH)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == editImageViewController.selectedAssets.count {
//            editImageViewController.back()
//            return
//        }
//        
//        if selectedindex == indexPath.row{
//            return
//        }
////        var preIndex = selectedindex
//        
//        selectedindex = indexPath.row
//        collectionView.reloadSections(IndexSet(integer: 0))
//        
//        
//        
//        editImageViewController.showImageViewAt(indexPath.row)
//        
//    }
//    
//
//}
//
//class MySelectedImageCollectionView: UICollectionView {
//    var selectedImageController:SelectedImageController!
//    init(frame: CGRect ,editImageViewController:EditImageViewController) {
//        
//        let flowLayout = UICollectionViewFlowLayout()
//        
//        
//        flowLayout.minimumInteritemSpacing = 10
////        flowLayout.sectionInset =
////            UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
//        
//        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
//        
//        
//        
//        super.init(frame: frame, collectionViewLayout: flowLayout)
//        
//        selectedImageController = SelectedImageController()
//
//        
//        selectedImageController.editImageViewController = editImageViewController
//        self.dataSource = selectedImageController
//        self.delegate = selectedImageController
//        
//        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell2")
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class CustomCellBackground : UIView{
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(rect: rect)
        
        let fillColor = UIColor.white
        fillColor.setFill()
        path.fill()
    }
}
