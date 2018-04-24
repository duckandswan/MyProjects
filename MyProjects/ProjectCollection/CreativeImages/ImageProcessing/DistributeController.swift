//
//  distributeController.swift
//  Work
//
//  Created by bob song on 15/8/14.
//  Copyright (c) 2015年 spring. All rights reserved.
//

import UIKit

class DistributeController: UIViewController,UITextViewDelegate,UIScrollViewDelegate {

    var textView:UITextView!
    
    weak var editImageViewController:EditImageViewController!
    var confirmCollectionView: ConfirmCollectionView!
    
    var isSubmit = false
    
    var userIsInDistributing = false
    
    var talkButton:UIButton!
    
    var backgroundtextView:UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        confirmCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        
        view.addSubview(scrollView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem( title: NSLocalizedString("发布", comment: ""),
            style: .plain,
            target: self,
            action: #selector(DistributeController.performDistribution))
        
        
        
        
        
        let sW = view.frame.size.width
        let sH = view.frame.size.height
        
        let tX:CGFloat = sW/20
        let tY:CGFloat = 0
        let tW = sW - 2 * tX
        let tH:CGFloat = SCREEN_H / 4.7
        
        //        let tbS:CGFloat = 5
        //        let bX:CGFloat = tX
        //        let bY:CGFloat = tY + tH + tbS
        //        let bW = sW/8.5
        //        let bH:CGFloat = SCREEN_H / 32
        
        let tcS:CGFloat = 0
        let cX:CGFloat = tX
        let cY:CGFloat = tY + tH + tcS
        let cW:CGFloat = sW - 2 * tX
        let cH:CGFloat = cW / 5
        
        let whiteH = cY + cH
        
        //        var label = UILabel(frame: CGRectMake(lX, lY, lW, lH))
        //        label.text = "说点什么..."
        //        label.textColor = UIColor.grayColor()
        //        view.addSubview(label)
        
        let whiteV = UIView(frame: CGRect(x: 0, y: 0, width: sW, height: whiteH))
        whiteV.backgroundColor = UIColor.white
        scrollView.addSubview(whiteV)
        
        let greenV = UIView(frame: CGRect(x: 0, y: whiteH, width: sW, height: sH - whiteH))
        greenV.backgroundColor = UIColor(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        scrollView.addSubview(greenV)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
            action: #selector(DistributeController.handleTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        greenV.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        backgroundtextView = UITextView(frame: CGRect(x: tX, y: tY, width: tW, height: tH))
        backgroundtextView.text = NSLocalizedString("说点什么...", comment: "")
        backgroundtextView.font = UIFont.systemFont(ofSize: 14)
        backgroundtextView.isEditable = false
        whiteV.addSubview(backgroundtextView)
        
        textView = UITextView(frame: CGRect(x: tX, y: tY, width: tW, height: tH))
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.alpha = 0.5
        textView.delegate = self
        whiteV.addSubview(textView)
        
        
        confirmCollectionView = ConfirmCollectionView(frame: CGRect(x: cX, y: cY, width: cW, height: cH), editImageViewController: editImageViewController!)
        whiteV.addSubview(confirmCollectionView)
        
        let cvS:CGFloat = 20
        let vX:CGFloat = 0
        let vY:CGFloat = cY + cH + cvS
        let vW:CGFloat = sW
        let vH:CGFloat = 50
        let v = UIView(frame: CGRect(x: vX, y: vY, width: vW, height: vH))
        v.backgroundColor = UIColor.white
        
        let b1W:CGFloat = 100
        let b1H:CGFloat = 25
        let b1 = UIButton(frame: CGRect(x: 15, y: (vH - b1H)/2, width: b1W, height: b1H))
        b1.setTitle(" 关联商品", for: UIControlState())
        b1.setTitleColor(UIColor.gray, for: UIControlState())
        b1.setImage(UIImage(named: "btn_add_release"), for: UIControlState())
        b1.addTarget(self, action: #selector(DistributeController.relateToCommodity), for: UIControlEvents.touchUpInside)
        v.addSubview(b1)
        
        let b2W:CGFloat = vH/2
        let b2H:CGFloat = b2W
        let b2 = UIButton(frame: CGRect(x: vW - 2 * b2W, y: (vH - b2H)/2, width: b2W, height: b2H))
        b2.setBackgroundImage(UIImage(named: "disclosure_arrow_gray"), for: UIControlState())
        v.addSubview(b2)
        
        scrollView.addSubview(v)
        
        v.isHidden = true
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    func handleTap(){
        view.endEditing(true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "" {
            backgroundtextView.isHidden = true
            textView.alpha = 1
        }else{
            backgroundtextView.isHidden = false
            textView.alpha = 0.5
        }
    }

    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func back() {
        if editImageViewController!.editedImgArr.count == 0 {
            _ = navigationController?.popToViewController(editImageViewController!.showAllImageController, animated: true)
        }else{
            _ = navigationController?.popViewController(animated: false)
        }
        
    }
    
    func performDistribution() {
        let set = CharacterSet(charactersIn: " \n\r\t")
        if textView.text.trimmingCharacters(in: set) == ""{
            let controller = UIAlertController(title: nil,
                message: "请输入文字！",
                preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(title: "OK",
                style: .default,
                handler: nil))
            
            self.present(controller, animated: true, completion: nil)
            
            return
        }
        
        if editImageViewController?.editedImgArr.count == 0{
            let controller = UIAlertController(title: nil,
                message: "请选取图片！",
                preferredStyle: .alert)
            
            controller.addAction(UIAlertAction(title: "OK",
                style: .default,
                handler: nil))
            
            self.present(controller, animated: true, completion: nil)
            
            return
        }
        
        distributeToServer()
        
        
        

    }
    
    
    func distributeToServer(){
        
    }
    
    
    func dismiss(_ timer:Timer){
        (timer.userInfo as! UIAlertController).dismiss(animated: true, completion: nil)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
 
    
    func relateToCommodity() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
