//
//  NewMainMenuViewController.swift
//  BarProto2
//
//  Created by Developer on 5/12/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

enum TappedView: Int {
    case TrainingView = 1
    case ArcadeView = 2
    case ExpertView = 3
    case StatisticsView = 5
    case RankingsView = 6
    case ShopView = 4
}

class NewMainMenuViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var trainingView: UIView!
    @IBOutlet weak var arcadeView: UIView!
    @IBOutlet weak var expertView: UIView!
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var rankingsView: UIView!
    var tappedView: TappedView!
    var viewAppearedFromDismissal = false
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if viewAppearedFromDismissal {
            showHiddenView()
            viewAppearedFromDismissal = false
        }
    }
   
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        println("Toque la vista con tag \(sender.view?.tag)")
        if let touchedView = sender.view {
            switch touchedView.tag {
            case 1:
                tappedView = TappedView.TrainingView
                hiddeView(touchedView, isOnTop: true)

            case 2:
                tappedView = TappedView.ArcadeView
                hiddeView(touchedView, isOnTop: true)
                
            case 3:
                tappedView = TappedView.ExpertView
                hiddeView(touchedView, isOnTop: true)
          
            case 4:
                tappedView = TappedView.ShopView
                hiddeView(touchedView, isOnTop: false)
                
            case 5:
                println("toque la cincoooooo")
                tappedView = TappedView.StatisticsView
                hiddeView(touchedView, isOnTop: false)
                
            case 6:
                tappedView = TappedView.RankingsView
                showRankings()
                
            default:
                println("No paso nada")
            }
        }
    }
    
    //MARK: Animations 
    
    func showHiddenView() {
        println("ENTRE AL HIDDE  VIEWWWWWWW")
        if let hiddenView = view.viewWithTag(tappedView.rawValue) {
            println("La vista existe y tiene un tag de \(hiddenView.tag)")
            UIView.animateWithDuration(0.5,
                delay: 0.0,
                options: .CurveEaseOut,
                animations: { () -> Void in
                    hiddenView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
            }, completion: { (success) -> Void in
            
            })
        } else {
            println("La vista no existe")
        }
    }
    
    func hiddeView(theView: UIView, isOnTop: Bool) {
        var yDistance: CGFloat
        if isOnTop {
            yDistance = -view.frame.size.height
        } else {
            yDistance = view.frame.size.height
        }
        
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: .CurveEaseIn,
            animations: { () -> Void in
                theView.transform = CGAffineTransformMakeTranslation(0.0, yDistance)
        }) { (succedd) -> Void in
            if self.tappedView == TappedView.TrainingView {
                self.goToBarsVCInTrainingMode(true, expertMode: false)
            } else if self.tappedView == TappedView.ArcadeView {
                self.goToBarsVCInTrainingMode(false, expertMode: false)
            } else if self.tappedView == TappedView.ExpertView {
                self.goToBarsVCInTrainingMode(false, expertMode: true)
            } else if self.tappedView == TappedView.RankingsView {
                self.showRankings()
            } else if self.tappedView == TappedView.StatisticsView {
                self.goToStatisticsVC()
            } else if self.tappedView == TappedView.ShopView {
                self.goToShopVC()
            }
        }
    }
    
    //MARK: Navigation 
    
    func goToShopVC() {
        viewAppearedFromDismissal = true
        if let shopVC = storyboard?.instantiateViewControllerWithIdentifier("NewShop") as? NewShopViewController {
            shopVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            presentViewController(shopVC, animated: true, completion: nil)
        }
    }
    
    func goToStatisticsVC() {
        viewAppearedFromDismissal = true
        
        if let statisticsVC = storyboard?.instantiateViewControllerWithIdentifier("Statistics") as? StatisticsViewController {
            statisticsVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            presentViewController(statisticsVC, animated: true, completion: nil)
        }
    }
    
    func showRankings() {
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gameCenterVC.gameCenterDelegate = self
        presentViewController(gameCenterVC, animated: true, completion: nil)
    }
    
    func goToBarsVCInTrainingMode(trainingMode: Bool, expertMode: Bool) {
        viewAppearedFromDismissal = true
        
        if let barsVC = storyboard?.instantiateViewControllerWithIdentifier("ArcadeGame") as? BarsViewController {
            barsVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            barsVC.expertModeActivated = expertMode
            barsVC.trainingModeActivated = trainingMode
            presentViewController(barsVC, animated: true, completion: nil)
        }
    }
    
    //MARK: GKGameCenterControllerDelegate
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
