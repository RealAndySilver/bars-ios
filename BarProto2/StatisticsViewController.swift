//
//  StatisticsViewController.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 11/25/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var barsLabel: UILabel!
    @IBOutlet weak var barsSlider: UISlider!
    @IBOutlet weak var arcadeScoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var expertScoreLabel: UILabel!
    @IBOutlet weak var totalTouchesLabel: UILabel!
    @IBOutlet weak var barsCompletedLabel: UILabel!
    @IBOutlet weak var gamesLostLabel: UILabel!
    @IBOutlet weak var rankingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UserData.sharedInstance().setNumberOfBars(Int(barsSlider.value))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: .CurveEaseOut,
            animations: { () -> Void in
                self.arcadeScoreLabel.transform = CGAffineTransformIdentity
                self.expertScoreLabel.transform = CGAffineTransformIdentity
                self.totalTouchesLabel.transform = CGAffineTransformIdentity
                self.barsCompletedLabel.transform = CGAffineTransformIdentity
                self.gamesLostLabel.transform = CGAffineTransformIdentity
        }) { (success) -> Void in
            
        }
    }
    
    func setupUI() {
        barsSlider.value = Float(UserData.sharedInstance().getNumberOfBars())
        barsLabel.text = "Number of bars: \(Int(barsSlider.value))"
        //barsSlider.hidden = true
        //barsLabel.hidden = true
   
        arcadeScoreLabel.text = "Arcade High Score: \(UserData.sharedInstance().getScore())"
        expertScoreLabel.text = "Expert High Score: \(UserData.sharedInstance().getExpertScore())"
        totalTouchesLabel.text = "Total Touches: \(UserData.sharedInstance().getTotalTouches())"
        barsCompletedLabel.text = "Bars Completed: \(UserData.sharedInstance().getBarsCompleted())"
        gamesLostLabel.text = "Games Lost: \(UserData.sharedInstance().getGamesLost())"
        
        //Set the initial position of the bars
        arcadeScoreLabel.transform = CGAffineTransformMakeTranslation(-arcadeScoreLabel.frame.size.width, 0.0)
        expertScoreLabel.transform = CGAffineTransformMakeTranslation(-expertScoreLabel.frame.size.width, 0.0)
        totalTouchesLabel.transform = CGAffineTransformMakeTranslation(-totalTouchesLabel.frame.size.width, 0.0)
        barsCompletedLabel.transform = CGAffineTransformMakeTranslation(-barsCompletedLabel.frame.size.width, 0.0)
        gamesLostLabel.transform = CGAffineTransformMakeTranslation(-gamesLostLabel.frame.size.width, 0.0)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func rankingsButtonPressed(sender: AnyObject) {
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gameCenterVC.gameCenterDelegate = self
        presentViewController(gameCenterVC, animated: true, completion: nil)
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        let roundedValue = Int(round(sender.value))
        barsLabel.text = "Number of bars: \(roundedValue)"
        sender.value = Float(roundedValue)
    }
    
    //MARK: GameCenterDelegate
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
