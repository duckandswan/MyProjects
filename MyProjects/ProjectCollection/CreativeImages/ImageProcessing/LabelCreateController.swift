//
//  LabelCreateController.swift
//  Work
//
//  Created by bob song on 15/8/13.
//  Copyright (c) 2015年 spring. All rights reserved.
//

import UIKit

//protocol LabelCreateDelegate : NSObjectProtocol {
//    func createLabel(texts : [String])
//    func deleteLabel()
//    func editLabel(texts: [String])
//}

class LabelCreateController: UIViewController,UITextFieldDelegate {
    var selectedImg:UIImage!
    var textFields:[UITextField] = []
    
    weak var delegate: EditImageViewController?
    var b2:UIButton!

    var isEdited = false
    var backgroundImageView:UIImageView!
    
    var blurView:UIVisualEffectView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBarHidden = false
//        self.navigationController?.navigationBar.hidden = false
//        navigationController?.navigationBar.translucent = false
//        navigationController?.isNavigationBarHidden = true
        if isEdited == false {
            b2.isHidden = true
        }else{
            b2.isHidden = false
        }
        
        backgroundImageView.image = selectedImg
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_back@3x"), style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        navigationController?.isNavigationBarHidden = true
        automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
        
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = selectedImg
        view.addSubview(backgroundImageView)
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        let v = UIView(frame: view.bounds)
        v.backgroundColor = UIColor.black
        v.alpha = 0.5
        view.addSubview(v)
        
//        let sW = view.frame.size.width
//        let sH = view.frame.size.height
        
        let sW = UIScreen.main.bounds.size.width
        let sH = UIScreen.main.bounds.size.height
        
        let backW:CGFloat = sW / 7.5
        let backH:CGFloat = sH / 16
        
        let barH:CGFloat = floor(sH / 9)

        let iW:CGFloat = 20
        let iH:CGFloat = 20
        
        
        let tW:CGFloat = sW/2
        let tH:CGFloat = sH/15
        let tX = (sW - tW)/2
        let tY:CGFloat = barH + sH/15
        let tS:CGFloat = sH/30
        let itS:CGFloat = 20
        
//        let barV = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_W, height: barH))
//        barV.backgroundColor = UIColor.black
//        view.addSubview(barV)
        
        let backButton = UIButton(frame: CGRect(x: 0, y: (barH - backH)/2, width: backW, height: backH))
        backButton.setImage(UIImage(named: "btn_back"), for: UIControlState())
        backButton.addTarget(self, action: #selector(LabelCreateController.back), for: UIControlEvents.touchUpInside)
        view.addSubview(backButton)
        
        let tf1 = UITextField(frame: CGRect(x: tX, y: tY, width: tW, height: tH))
        configTextField(tf1,string: "店名/品牌")
        
        let iv1 = UIImageView(frame: CGRect(x: tX - itS - iW, y: tY + (tH - iH)/2, width: iW, height: iH))
        iv1.image = UIImage(named: "photo_tag_brand")
        configImageView(iv1)
        
        let tf2 = UITextField(frame: CGRect(x: tX, y: tY + (tH + tS), width: tW, height: tH))
        configTextField(tf2,string: "城市")
        
        let iv2 = UIImageView(frame: CGRect(x: tX - itS - iW, y: tY + (tH - iH)/2 + (tH + tS), width: iW, height: iH))
        iv2.image = UIImage(named: "photo_tag_position")
        configImageView(iv2)
        
        let tf3 = UITextField(frame: CGRect(x: tX, y: tY + (tH + tS) * 2, width: tW, height: tH))
        configTextField(tf3,string: "随便说说")
        
        let iv3 = UIImageView(frame: CGRect(x: tX - itS - iW, y: tY + (tH - iH)/2 + (tH + tS) * 2, width: iW, height: iH))
        iv3.image = UIImage(named: "photo_tag_word")
        configImageView(iv3)
        
        let bW:CGFloat = sW/2.5
        let bH:CGFloat = sH/15
        
        let b1 = UIButton(frame: CGRect(x: (sW - bW)/2, y: tY + (tH - iH)/2 + (tH + tS) * 3, width: bW, height: bH))
        b1.setTitle("完成", for: UIControlState())
        b1.addTarget(self, action: #selector(LabelCreateController.complete), for: UIControlEvents.touchUpInside)
        b1.backgroundColor = UIColor(red: 226/255.0, green: 74/255.0, blue: 44/255.0, alpha: 1)
        configButton(b1)
        
        b2 = UIButton(frame: CGRect(x: (sW - bW)/2, y: tY + (tH - iH)/2 + (tH + tS) * 3 + ( bH + 20 ), width: bW, height: bH))
        b2.setTitle("删除", for: UIControlState())
        b2.addTarget(self, action: #selector(LabelCreateController.delete as (LabelCreateController) -> () -> ()), for: UIControlEvents.touchUpInside)
        b2.backgroundColor = UIColor.clear
        b2.layer.borderColor = UIColor.white.cgColor
        b2.layer.borderWidth = 1
        
        configButton(b2)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
   
    func configTextField( _ tf:UITextField ,string:String){
        textFields.append(tf)
        
        tf.backgroundColor = UIColor.clear
        tf.layer.borderColor = UIColor.white.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.textColor = UIColor.white
        tf.addTarget(self, action: #selector(LabelCreateController.closeKeyboard), for: UIControlEvents.editingDidEndOnExit)
        tf.clearButtonMode = UITextFieldViewMode.whileEditing
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        tf.leftView = paddingView
        tf.leftViewMode = UITextFieldViewMode.always
        
//        let result = NSMutableAttributedString(string: string)
//        let attributesForFirstWord = [
//            NSFontAttributeName : UIFont.boldSystemFontOfSize(10),
//            NSForegroundColorAttributeName : UIColor.whiteColor(),
//            NSBackgroundColorAttributeName : UIColor.blackColor()
//        ]
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.placeholder = string
        tf.attributedPlaceholder = NSAttributedString(string:tf.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)])
        
        let clearButton = tf.value(forKey: "_clearButton") as! UIButton
//        clearButton.layer.cornerRadius = (clearButton.frame.size.height - 1)/2
//        clearButton.backgroundColor = UIColor.whiteColor()
        clearButton.setImage(UIImage(named: "photo_tag_cancle"), for: UIControlState())
        clearButton.setImage(UIImage(named: "photo_tag_cancle"), for: UIControlState.highlighted)
        
        tf.delegate = self
        
//        tf.setValue(UIColor.whiteColor(), forKeyPath: "_placeholderLabel.textColor")
        view.addSubview(tf)
    }
    
    func configImageView(_ iv:UIImageView){
        iv.backgroundColor = UIColor.clear
        view.addSubview(iv)
    }
    
    func configButton(_ b:UIButton){
        b.setTitleColor(UIColor.white, for: UIControlState())
        b.layer.cornerRadius = 5
        view.addSubview(b)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//            textField.backgroundColor = UIColor.lightGrayColor()
         textField.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 0.25)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
            textField.backgroundColor = UIColor.clear
    }
    
    func back() {
        _ = navigationController?.popViewController(animated: false)
    }
    
    func complete(){
        var texts:[String] = []
        for value in textFields {
            texts.append(value.text!)
        }
        if isEdited == false {
            delegate!.createLabel(texts)
        }else{
            delegate!.editLabel(texts)
        }
        
        closeKeyboard()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func delete(){
        delegate!.deleteLabel()
        _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func closeKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

}

class ClearButton:UIButton {
    var tf:UITextField!
}

