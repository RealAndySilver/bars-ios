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
    
    func setupUI() {
        barsSlider.value = Float(UserData.sharedInstance().getNumberOfBars())
        barsLabel.text = "Number of bars: \(Int(barsSlider.value))"
        
        //backButton.layer.borderWidth = 1.0
        //backButton.layer.borderColor = AppColors.sharedInstance().getObjBarColors().first?.CGColor
        
        arcadeScoreLabel.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        arcadeScoreLabel.layer.borderWidth = 1.0
        arcadeScoreLabel.text = "Arcade High Score: \(UserData.sharedInstance().getScore())"
        
        expertScoreLabel.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        expertScoreLabel.layer.borderWidth = 1.0
        expertScoreLabel.text = "Expert High Score: \(UserData.sharedInstance().getExpertScore())"
        
        totalTouchesLabel.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        totalTouchesLabel.layer.borderWidth = 1.0
        totalTouchesLabel.text = "Total Touches: \(UserData.sharedInstance().getTotalTouches())"
        
        barsCompletedLabel.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        barsCompletedLabel.layer.borderWidth = 1.0
        barsCompletedLabel.text = "Bars Completed: \(UserData.sharedInstance().getBarsCompleted())"
        
        gamesLostLabel.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        gamesLostLabel.layer.borderWidth = 1.0
        gamesLostLabel.text = "Games Lost: \(UserData.sharedInstance().getGamesLost())"
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
