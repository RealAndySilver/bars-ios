//
//  MainMenuViewController.swift
//  BarProto2
//
//  Created by Diego Fernando Vidal Illera on 11/25/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var rankingsButton: UIButton!
    @IBOutlet weak var barsTitleLabel: UILabel!
    @IBOutlet weak var trainingButton: UIButton!
    @IBOutlet weak var arcadeButton: UIButton!
    @IBOutlet weak var expertButton: UIButton!
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var leftBarView: UIView!
    @IBOutlet weak var centerBarView: UIView!
    @IBOutlet weak var rightBarView: UIView!
    var viewAppearFromDismiss = false
    var goToArcadeGames = false
    var goToStatistics = false
    var goToExpertGames = false
    var goToTrainingGames = false
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if viewAppearFromDismiss {
            showBarsAnimated()
            viewAppearFromDismiss = false
        }
    }
    
    //MARK: Custom Initialization Stuff
    
    func setupUI() {
        barsTitleLabel.layer.borderWidth = 1.0
        barsTitleLabel.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        
        trainingButton.layer.borderWidth = 1.0
        trainingButton.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        
        arcadeButton.layer.borderWidth = 1.0
        arcadeButton.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        
        expertButton.layer.borderWidth = 1.0
        expertButton.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        
        statisticsButton.layer.borderWidth = 1.0
        statisticsButton.layer.borderColor = AppColors.sharedInstance().getPatternColors().first?.last?.CGColor
        
        rankingsButton.layer.borderWidth = 1.0
        rankingsButton.layer.borderColor = AppColors.sharedInstance().getObjBarColors().first?.CGColor
        
        shopButton.layer.borderWidth = 1.0
        shopButton.layer.borderColor = AppColors.sharedInstance().getObjBarColors().first?.CGColor
    }
    
    //MARK: Actions 
    
    @IBAction func rankingsButtonPressed(sender: AnyObject) {
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gameCenterVC.gameCenterDelegate = self
        presentViewController(gameCenterVC, animated: true, completion: nil)
    }
    
    @IBAction func trainingButtonPressed(sender: AnyObject) {
        goToArcadeGames = false
        goToStatistics = false
        goToTrainingGames = true
        goToExpertGames = false
        hiddeBarsAnimated()
    }
    
    @IBAction func expertButtonPressed(sender: AnyObject) {
        goToArcadeGames = false
        goToStatistics = false
        goToTrainingGames = false
        goToExpertGames = true
        hiddeBarsAnimated()
    }
    
    @IBAction func arcadeButtonPressed(sender: AnyObject) {
        goToArcadeGames = true
        goToStatistics = false
        goToExpertGames = false
        goToTrainingGames = false
        hiddeBarsAnimated()
    }
    
    @IBAction func statisticsButtonPressed(sender: AnyObject) {
        goToArcadeGames = false
        goToStatistics = true
        goToExpertGames = false
        goToTrainingGames = false
        hiddeBarsAnimated()
    }
    
    func goToTrainingVC() {
        if let arcadeGameVC = storyboard?.instantiateViewControllerWithIdentifier("ArcadeGame") as? BarsViewController {
            arcadeGameVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            arcadeGameVC.trainingModeActivated = true
            arcadeGameVC.expertModeActivated = false
            presentViewController(arcadeGameVC, animated: true, completion: nil)
        }
    }
    
    func goToArcadeGame() {
        if let arcadeGameVC = storyboard?.instantiateViewControllerWithIdentifier("ArcadeGame") as? BarsViewController {
            arcadeGameVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            arcadeGameVC.expertModeActivated = false
            arcadeGameVC.trainingModeActivated = false
            presentViewController(arcadeGameVC, animated: true, completion: nil)
        }
    }
    
    func goToExpertMode() {
        if let arcadeGameVC = storyboard?.instantiateViewControllerWithIdentifier("ArcadeGame") as? BarsViewController {
            arcadeGameVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            arcadeGameVC.expertModeActivated = true
            arcadeGameVC.trainingModeActivated = false
            presentViewController(arcadeGameVC, animated: true, completion: nil)
        }
    }
    
    func goToStatisticsVC() {
        if let statisticsVC = storyboard?.instantiateViewControllerWithIdentifier("Statistics") as? StatisticsViewController {
            statisticsVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            presentViewController(statisticsVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Animation 
    
    func hiddeBarsAnimated() {
        UIView.animateWithDuration(0.8,
            delay: 0.0,
            options: .CurveEaseIn,
            animations: { () -> Void in
                self.leftBarView.transform = CGAffineTransformMakeTranslation(0.0, self.leftBarView.frame.size.height + 30.0)
                self.centerBarView.transform = CGAffineTransformMakeTranslation(0.0, self.centerBarView.frame.size.height)
                self.rightBarView.transform = CGAffineTransformMakeTranslation(0.0, self.centerBarView.frame.size.height + 80.0)
        }) { (success) -> Void in
            self.viewAppearFromDismiss = true
            if self.goToArcadeGames {
                self.goToArcadeGame()
            } else if self.goToStatistics {
                self.goToStatisticsVC()
            } else if self.goToExpertGames {
                self.goToExpertMode()
            } else if self.goToTrainingGames {
                self.goToTrainingVC()
            }
        }
    }
    
    func showBarsAnimated() {
        UIView.animateWithDuration(0.8,
            delay: 0.0,
            options: .CurveEaseOut | UIViewAnimationOptions.AllowUserInteraction,
            animations: { () -> Void in
                self.leftBarView.transform = CGAffineTransformIdentity
                self.centerBarView.transform = CGAffineTransformIdentity
                self.rightBarView.transform = CGAffineTransformIdentity
        }) { (sucess) -> Void in
            
        }
    }
    
    //MARK: GameCenterDelegate
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
