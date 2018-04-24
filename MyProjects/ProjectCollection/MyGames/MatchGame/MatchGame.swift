//
//  MatchGame.swift
//  MyAppCollection
//
//  Created by tarena on 15/7/13.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

import UIKit

class MatchGame: UIViewController {
    var number = 4;
    var buttons:[MatchGameButton] = []
    var array:[UIImage] = []
    var firstButton:MatchGameButton?
    var secondButton:MatchGameButton?
    
    @IBOutlet weak var gameView: UIView!
    var matchedNumber = 0
    
    var clicked = false

    var scoreDic = Dictionary<String,Int>()
    var playerNames:[String] = []
    
    @IBOutlet weak var timeLabel: MyTimeLabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBAction func refresh() {
        loadGame()
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "翻牌游戏"
        super.viewDidLoad()
        
        setBackgroundImageView()
        
        layoutButtons()
        
        loadGame()

    }
    
    func setBackgroundImageView(){
//        backgroundImageView.changeToBlurImage()
//        view.sendSubview(toBack: backgroundImageView)
    }
    
// MARK:
    func loadGame(){
        
        timeLabel.reset()
        
        array = MatchGameTool.getPairedImages(number * number / 2)
        for i in 0 ..< buttons.count {
            buttons[i].isSelected = false
            buttons[i].setBackgroundImage(array[i], for: UIControlState.selected)
        }
        
        matchedNumber = 0
        clicked = false
        
        clearFirstAndSecondButton()

    }

    func layoutButtons(){
        let margin:CGFloat = 10
        let buttonWidth = (view.frame.size.width -  CGFloat(number + 1) * margin) / CGFloat(number)
        let buttonHeight = buttonWidth
        let size : CGSize = CGSize(width: buttonWidth, height: buttonHeight)
        
        buttons = []
        for i in 0 ..< number * number {
            let point = CGPoint(x: margin + CGFloat(i % number) * (buttonWidth + margin) , y: margin + CGFloat(i / number)*(margin + buttonHeight))
            let frame = CGRect(origin:point , size: size)
            let button = MatchGameButton(frame: frame)
            button.backgroundColor = UIColor.white
            button.setBackgroundImage(UIImage(named: "card_back"), for: UIControlState.normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .fill
            button.contentVerticalAlignment = .fill
            gameView.addSubview(button)
            button.addTarget(self, action:#selector(self.click), for: UIControlEvents.touchUpInside)
            buttons.append(button)
        }
        
        backgroundImageView.isUserInteractionEnabled = true
    }
    
// MARK
    func click(sender:MatchGameButton!){
        if sender.isSelected == true {
            return
        }
        if firstButton != nil && secondButton != nil {
            return
        }
        if clicked == false {
            timeLabel.start()
            clicked = true
        }
        if firstButton == nil{
            firstButton = sender
            sender.open()
        }else if sender !== firstButton{
            sender.open()
            secondButton = sender
            if firstButton?.backgroundImage(for: UIControlState.selected) !== secondButton?.backgroundImage(for: UIControlState.selected){
                firstButton?.close()
                secondButton?.close()
            }else{
                matchedNumber += 1
                if matchedNumber == number * number / 2 {
                    if timeLabel.passed == false {
                        timeLabel.stop()
                    }
                }
            }
//            clearFirstAndSecondButton()
            Timer.scheduledTimer(timeInterval: MatchGameButton.timeInterval/2, target: self, selector: #selector(self.clearFirstAndSecondButton), userInfo: nil, repeats: false)
            
        }
    }
    
    func clearFirstAndSecondButton(){
        firstButton = nil
        secondButton = nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
