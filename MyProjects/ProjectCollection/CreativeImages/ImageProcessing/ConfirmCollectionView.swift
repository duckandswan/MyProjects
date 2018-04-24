//
//  ConfirmCollectionView.swift
//  Work
//
//  Created by bob song on 15/8/14.
//  Copyright (c) 2015年 spring. All rights reserved.
//

import UIKit
class ConfirmCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    weak var editImageViewController:EditImageViewController!
    
//    var selectedindex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editImageViewController.editedImgArr.count == 9 ? 9:editImageViewController.editedImgArr.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell4", for: indexPath) 
        
        // Configure the cell
        if cell.contentView.viewWithTag(100) == nil {
            
            let imageview = UIImageView(frame: cell.contentView.bounds)
            imageview.tag = 100
            imageview.isUserInteractionEnabled = true
            imageview.contentMode = UIViewContentMode.scaleToFill
            cell.contentView.addSubview(imageview)
            
            let w:CGFloat = cell.contentView.bounds.size.width
            let cL:CGFloat = 20
            let cancelButton = CancelButton(frame: CGRect(x: w - cL , y: 0, width: cL, height: cL))
            cancelButton.tag = 101
            cancelButton.cell = cell
            cancelButton.collectionView = collectionView
            cancelButton.setBackgroundImage(UIImage(named: "btn_photo_cancle_release"), for: UIControlState())
            cancelButton.addTarget(self, action: #selector(ConfirmCollectionViewController.cancel(_:)), for: UIControlEvents.touchUpInside)
            cell.contentView.addSubview(cancelButton)
            
        }
        let imageview = cell.contentView.viewWithTag(100) as! UIImageView
        if indexPath.row == editImageViewController.editedImgArr.count {
            imageview.image = UIImage(named: "btn_add_photo_release")
            cell.viewWithTag(101)?.isHidden = true
        }else{
            imageview.image = editImageViewController.editedImgArr[indexPath.row]
            cell.viewWithTag(101)?.isHidden = false
        }
        
        
        return cell
    }
    func cancel(_ sender:CancelButton){
        let indexPath = sender.collectionView.indexPath(for: sender.cell)!
        editImageViewController.editedImgArr.remove(at: indexPath.row)
//        sender.collectionView.deleteItemsAtIndexPaths([indexPath])
        
        sender.collectionView.reloadData()
        
        editImageViewController.showAllImageController.selectedAssets.remove(at: indexPath.row)
        editImageViewController.selectedAssets.remove(at: indexPath.row)
        editImageViewController.editedImageViewArr.remove(at: indexPath.row)
        
//        editImageViewController.isRemoved = true

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellW = collectionView.frame.size.width / 6.5
        let cellH = cellW
        return CGSize(width: cellW, height: cellH)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == editImageViewController.editedImgArr.count {
            
            editImageViewController.navigationController?.popToViewController(editImageViewController.showAllImageController, animated: true)
        
        }
    }
    

    
}



class ConfirmCollectionView: UICollectionView {
    var confirmCollectionViewController:ConfirmCollectionViewController!
    init(frame: CGRect ,editImageViewController:EditImageViewController) {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        
        
//        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        confirmCollectionViewController = ConfirmCollectionViewController()
        
        confirmCollectionViewController.editImageViewController = editImageViewController
        self.dataSource = confirmCollectionViewController
        self.delegate = confirmCollectionViewController
        
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell4")
        
//        self.backgroundColor = UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        self.backgroundColor = UIColor.white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

class CancelButton:UIButton{
    var cell:UICollectionViewCell!
    var collectionView: UICollectionView!
}
