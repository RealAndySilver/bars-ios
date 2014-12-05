//
//  BarsViewController.swift
//  BarProto2
//
//  Created by Developer on 19/11/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

class BarsViewController: UIViewController, GameOverAlertDelegate, TwoButtonsAlertDelegate, VungleSDKDelegate, OneButtonAlertDelegate, UIAlertViewDelegate, ThreeButtonsAlertDelegate, BuyCoinsViewDelegate, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var littleScoreLabel: UILabel!
    @IBOutlet weak var littleMaxScoreLabel: UILabel!
    @IBOutlet weak var littleBarsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var containerUI: UIView!
    @IBOutlet weak var highScoreLabel: UILabel!
    var tapLabel: UILabel!
    
    let kNumberOfBarsInScreen = UserData.sharedInstance().getNumberOfBars()
    let kScoreIncreaseFactor = 1000;
    var countingLabel: UICountingLabel!
    var score: Int = 0
    var barsContainer1: UIView!
    var barsContainer2: UIView!
    var pixelLabel: UILabel!
    var activeBarIndex: Int = 0;
    var barsTimer: NSTimer?
    var barSpeed: CGFloat = 4.0
    var increaseSpeedFactor: CGFloat = 0.0
    var activeBar: UIView!
    var activeObjectiveRect: UIView!
    var correctBars = 0
    var speedsArray: Array<Int> = []
    var viewIsZoomed = false
    var gameActivated = false
    var gameWillBegin = false
    var newHighScore = false
    var gamePaused = false
    var firstTimeViewAppears = true
    var userViewedVideoOrUsedCoin = false
    var readyToBeginGame = false
    var container1IsLeft = true
    var userDidResetGame = false
    var totalTouches = UserData.sharedInstance().getTotalTouches()
    var barsCompleted = UserData.sharedInstance().getBarsCompleted()
    var gamesLost = UserData.sharedInstance().getGamesLost()
    var expertModeActivated: Bool!
    var trainingModeActivated: Bool!
    var gamesLostInCurrentGame = 0
    var kCoinsNeededMultiplier = 2
    var coinsNeededToContinue = 2
   
    var videoAlert: ThreeButtonsAlert!
    
    //Training mode UI
    var slider: UISlider!
    var playButton: UIButton!
    
    //Get a random color for the objective bar
    let palettesArray = AppColors.sharedInstance().getPatternColors()
    let objBarColors = AppColors.sharedInstance().getObjBarColors()
    var selectedPalette: Int!
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VungleSDK.sharedSDK().delegate = self
        view.backgroundColor = UIColor.whiteColor()
        
        //Choose a random color pallete for the initial bars
        selectedPalette = Int(arc4random()%UInt32(palettesArray.count))
        
        //Setup the initial speeds of the bars
        setupSpeeds()
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        highScoreLabel.text = "\(UserData.sharedInstance().getCoins())"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if firstTimeViewAppears {
            //This is the first time the view appears, so display the initial alert
            activeBarIndex++;
            showInitialAlert()
            firstTimeViewAppears = false
            
            //Set FlurryAds
            FlurryAds.setAdDelegate(self)
        }
    }
    
    //MARK: Custom Initialization Stuff
    
    func setupSpeeds() {
        //Go through all the speeds in our array (There are 10 speed values because there are 10 bars)
        for index in 0...(kNumberOfBarsInScreen * 2 - 1) {
            speedsArray.append(0)
            if expertModeActivated == true {
                //If we are in expert mode, all the speed are going to have the max value
                speedsArray[index] = 7
                
            } else if trainingModeActivated == true {
                //If we are in training mode, initially all the bars will have the min value
                speedsArray[index] = 3
            
            } else {
                //If we are in arcade mode, randomize the speeds
                var randomSpeed = Int(arc4random()%5 + 3)
                speedsArray[index] = randomSpeed
            }
        }
    }
    
    func setupUI() {
        timeLabel.text = "0"
        
        //Setup the two containers of our bars. Each container will have 5 bars inside
        barsContainer1 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height))
        barsContainer2 = UIView(frame: CGRect(x: view.bounds.size.width, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height))
        setupContainer(barsContainer1, asInitialContainer: true)
        setupContainer(barsContainer2, asInitialContainer: false)
        
        //Setup the counting label
        countingLabel = UICountingLabel(frame: CGRect(x: view.bounds.size.width/2.0 - 120.0, y: 0.0, width: 240.0, height: 67.0))
        countingLabel.font = UIFont.boldSystemFontOfSize(40.0)
        countingLabel.textColor = UIColor.whiteColor()
        countingLabel.textAlignment = .Center
        countingLabel.format = "%d"
        countingLabel.text = "0"
        countingLabel.method = UILabelCountingMethodLinear
        containerUI.addSubview(countingLabel)
        
        //Setup the "Tap to begin" label
        tapLabel = UILabel(frame: CGRect(x: view.frame.size.width/2.0 - 100.0, y: view.frame.size.height/2.0 - 70.0, width: 200.0, height: 200.0))
        tapLabel.text = "Get Ready!\nTap to begin!"
        tapLabel.numberOfLines = 0
        tapLabel.textColor = AppColors.sharedInstance().getPatternColors().first?.last
        tapLabel.font = UIFont.boldSystemFontOfSize(25.0)
        tapLabel.textAlignment = .Center
        tapLabel.alpha = 0.0
        tapLabel.shadowColor = UIColor.whiteColor()
        tapLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.addSubview(tapLabel)
        
        //If we are in the training mode, hidde all the unnecessary UI
        if trainingModeActivated == true {
            countingLabel.hidden = true
            highScoreLabel.hidden = true
            timeLabel.hidden = true
            littleBarsLabel.hidden = true
            littleScoreLabel.text = "Speed"
            littleMaxScoreLabel.hidden = true
            
            //Create a Slider to control the speed 
            slider = UISlider(frame: CGRect(x: 20.0, y: 20.0, width: view.bounds.size.width - 90.0, height: 25.0))
            slider.continuous = false;
            slider.minimumValue = 3.0
            slider.maximumValue = 7.0
            slider.addTarget(self, action: "sliderTouched", forControlEvents: UIControlEvents.TouchDown)
            slider.minimumTrackTintColor = AppColors.sharedInstance().getPatternColors().first?.last
            slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
            containerUI.addSubview(slider)
            
            //Create a button to pause and start the bars movement
            playButton = UIButton(frame: CGRect(x: view.bounds.size.width - 65.0, y: 0.0, width: 60.0, height: containerUI.frame.size.height))
            playButton.setTitle("Pause", forState: .Normal)
            playButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            playButton.titleLabel?.font = UIFont.boldSystemFontOfSize(13.0)
            playButton.addTarget(self, action: "playPauseButtonPressed", forControlEvents: .TouchUpInside)
            containerUI.addSubview(playButton)
        }
        view.bringSubviewToFront(containerUI)
    }
    
    func setupContainer(barContainer: UIView, asInitialContainer: Bool) {
        barContainer.backgroundColor = UIColor.clearColor()
        view.addSubview(barContainer)
        
        var initialIndex: Int
        if asInitialContainer {
            //We are configuring the initial container (the container that is displayed when the view appears)
            //The index of the bars will go from 0 to 4
            initialIndex = 0
        } else {
            //We are configuring the second container (The container that is displayed when we complete the first
            //five bars. The index of the bars in this container will go from 5 to 9)
            initialIndex = kNumberOfBarsInScreen
        }
        
        //The bars width will be the screen width divided by five
        let barWidth: CGFloat = (view.bounds.size.width - (2 * CGFloat(kNumberOfBarsInScreen) + 1))/CGFloat(kNumberOfBarsInScreen)
        
        //Iterate to create the five bars and the five small rects in the container
        for index in 0...(kNumberOfBarsInScreen - 1) {
            //Create the bar
            let barView = UIView(frame: CGRect(x:2*CGFloat(index + 1) + CGFloat(index) * barWidth, y: view.bounds.size.height - 180.0, width: barWidth, height: view.bounds.size.height + 10.0))
            barView.backgroundColor = palettesArray[selectedPalette][speedsArray[index + initialIndex] - 3]
            barView.tag = index + initialIndex + 1
            barContainer.addSubview(barView)
            
            //Randomize the Y Position of the small rects and add 67 pixels to avoid the rects to be hidden 
            //when a notification gets displayed on the device
            var randomHeight = arc4random()%UInt32(view.bounds.size.height - 383.0)
            randomHeight += 85
            
            //Create the small rect
            let objectiveRect = UIView(frame: CGRect(x: barView.frame.origin.x, y: CGFloat(randomHeight), width: barWidth, height: 30.0))
            objectiveRect.backgroundColor = objBarColors[selectedPalette].colorWithAlphaComponent(0.7)
            objectiveRect.tag = 1001 + index + initialIndex
            barContainer.addSubview(objectiveRect)
        }
    }
    
    //MARK: Actions
    
    /////////////////////////////////////////////////////////////////////////////////
    //Actions just for the training mode
    
    func sliderTouched() {
        //Pause the training mode when the user touches the slider
        gamePaused = true
        playButton.setTitle("Play", forState: .Normal)
        stopTimer()
    }
    
    func sliderValueChanged(theSlider: UISlider) {
        //Get a rounded speed value from the slider value
        let roundedValue = roundf(theSlider.value)
        theSlider.value = roundedValue
        println("Valor redondeado: \(roundedValue)")
        
        //Setup everything based on our new speed value
        setupNewSpeedsValue(Int(roundedValue))
        setupNewBarsColors()
    }
    
    func playPauseButtonPressed() {
        gamePaused = !gamePaused
        if gamePaused {
            //Pause the game
            playButton.setTitle("Play", forState: .Normal)
            stopTimer()
        } else {
            //Activate the game
            playButton.setTitle("Pause", forState: .Normal)
            startTimer()
        }
    }
    
    func setupNewSpeedsValue(value: Int) {
        //Go through our speed array and set all the speeds to the new value 
        //assign on the slider
        for index in 0...speedsArray.count - 1 {
            speedsArray[index] = value
        }
    }
    
    func setupNewBarsColors() {
        //Setup colors of the bars inside the first container
        for index in 1...kNumberOfBarsInScreen {
            if let barView = barsContainer1.viewWithTag(index) {
                barView.backgroundColor = palettesArray[selectedPalette][speedsArray[index - 1] - 3]
            }
        }
        
        //Setup the colors of the bars inside the second container
        for index in kNumberOfBarsInScreen+1...kNumberOfBarsInScreen*2 {
            if let barView = barsContainer2.viewWithTag(index) {
                barView.backgroundColor = palettesArray[selectedPalette][speedsArray[index - 1] - 3]
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////
    
    //MARK: Navigation
    
    func dismissVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Game Start & Stop
    
    func stopTimer() {
        barsTimer?.invalidate()
    }
    
    func startTimer() {
        barSpeed = CGFloat(speedsArray[activeBarIndex - 1])
        increaseSpeedFactor = barSpeed

        if (container1IsLeft) {
            activeBar = barsContainer1.viewWithTag(activeBarIndex)
            activeObjectiveRect = barsContainer1.viewWithTag(1000 + activeBarIndex)
        } else {
            activeBar = barsContainer2.viewWithTag(activeBarIndex)
            activeObjectiveRect = barsContainer2.viewWithTag(1000 + activeBarIndex)
        }
        
        barsTimer = NSTimer.scheduledTimerWithTimeInterval(1.0/60.0, target: self, selector: "moveBar", userInfo: nil, repeats: true)
    }
    
    //MARK: Animation Stuff
    
    func zoomInBars() {
        //Obtenemos el centro del ObjectiveRect en el cual el usuario perdió
        let rectCenter = activeObjectiveRect.center;
        let viewCenter = view.center
        let deltaVector = CGPoint(x: viewCenter.x - rectCenter.x, y: viewCenter.y - rectCenter.y)
        var barsContainer: UIView!
        
        if container1IsLeft {
            barsContainer = barsContainer1
        } else {
            barsContainer = barsContainer2
        }
        
        UIView.animateWithDuration(1.0,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                barsContainer.transform =
                    CGAffineTransformConcat(CGAffineTransformMakeTranslation(deltaVector.x, deltaVector.y),
                        CGAffineTransformMakeScale(4.0, 4.0))
            }) { (success) -> Void in
                self.viewIsZoomed = true
                self.showViewVideoAlert()
        }
    }
    
    func zoomOutBars() {
        var barsContainer: UIView!
        if container1IsLeft {
            barsContainer = barsContainer1
        } else {
            barsContainer = barsContainer2
        }
        
        UIView.animateWithDuration(1.0,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                barsContainer.transform = CGAffineTransformIdentity
                //self.pixelLabel.alpha = 0.0
                
            }) { (succes) -> Void in
                //self.pixelLabel.removeFromSuperview()
                self.viewIsZoomed = false
                if !self.userViewedVideoOrUsedCoin {
                    //self.showLostAlert()
                    self.showTapLabel()
                    self.saveUserScore()
                    self.checkAchievements()
                } else {
                    //User viewed video, turn the property no false 
                    //self.userViewedVideo = false
                    self.showContinueGameAlert()
                }
        }
    }
    
    func animateContainerHorizontally() {
        
        var container1Frame = self.barsContainer1.frame;
        container1Frame.origin.x = container1Frame.origin.x - view.bounds.size.width
        
        var container2Frame = self.barsContainer2.frame;
        container2Frame.origin.x = container2Frame.origin.x - view.bounds.size.width
        
        UIView.animateWithDuration(0.2,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                self.barsContainer1.frame = container1Frame
                self.barsContainer2.frame = container2Frame
                
            }, completion: { (success) -> Void in
                if self.container1IsLeft {
                    var newContainer1Frame = self.barsContainer1.frame
                    newContainer1Frame.origin.x = self.barsContainer2.frame.origin.x + self.barsContainer2.frame.size.width
                    self.barsContainer1.frame = newContainer1Frame
                    self.container1IsLeft = false
                    
                    //Set the bars of the container 1 to the origin position
                    self.setContainer1BarsToOrigin()
                    
                    self.activeBarIndex = self.kNumberOfBarsInScreen + 1
                    
                } else {
                    var newContainer2Frame = self.barsContainer2.frame
                    newContainer2Frame.origin.x = self.barsContainer1.frame.origin.x + self.barsContainer1.frame.size.width
                    self.barsContainer2.frame = newContainer2Frame
                    self.container1IsLeft = true
                    
                    self.setContainer2BarsToOrigin()
                    
                    self.activeBarIndex = 1
                }
                
                //Start bars movement
                self.startTimer()
        })
    }
    
    func moveBar() {
        activeBar.transform = CGAffineTransformMakeTranslation(0.0, -barSpeed)
        if activeBar.frame.origin.y < 0 {
            userLost()
        }
        barSpeed += increaseSpeedFactor
    }
    
    func createWinLabelWithText(text: String, inBarsContainer: UIView) {
        //Create a label above the objective rect
        let winLabel = UILabel(frame: CGRect(x: 0.0, y: activeObjectiveRect.frame.origin.y - 22.0, width: 80.0, height: 20.0))
        winLabel.center = CGPointMake(activeObjectiveRect.center.x, winLabel.center.y)
        winLabel.text = text
        winLabel.textColor = palettesArray.first?.last
        winLabel.font = UIFont.boldSystemFontOfSize(13.0)
        winLabel.textAlignment = .Center
        winLabel.alpha = 0.0
        inBarsContainer.addSubview(winLabel)
        UIView.animateWithDuration(0.2,
            delay: 0.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { () -> Void in
                winLabel.alpha = 1.0
            }) { (success) -> Void in
                
                //Second animation 
                UIView.animateWithDuration(0.5,
                    delay: 0.0,
                    options: UIViewAnimationOptions.AllowUserInteraction,
                    animations: { () -> Void in
                        winLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0.0, -20.0), CGAffineTransformMakeScale(1.5, 1.5))
                        winLabel.alpha = 0.0
                }, completion: { (success) -> Void in
                    winLabel.removeFromSuperview()
                })
        }
    }
    
    //MARK: Touches Handling
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        
        //println("ACTIVE BAR INDEX: \(activeBarIndex)")
        
        if touches.count == 1 && readyToBeginGame && touch.locationInView(view).y > 68.0 {
            readyToBeginGame = false
            hiddeTapLabel()
            gameActivated = true
            
            if (activeBarIndex == kNumberOfBarsInScreen + 1 || activeBarIndex == kNumberOfBarsInScreen * 2 + 1) && !userDidResetGame {
                println("ENTRE ACAAAAAAA A ANIMAR")
                animateContainerHorizontally()
                //userDidResetGame = true
                
            } else {
                println("NO ANIMARE SINO QUE EMPEZARE EL TIMER")
                startTimer()
            }
        }
        
        else if touches.count == 1 && gameActivated && touch.locationInView(view).y > 68.0 && !gamePaused {
            checkIfUserWon()
        }
    }

    //MARK: Winning & Lossing
    
    func checkIfUserWon() {
        //Update total touches 
        totalTouches++
        
        if activeObjectiveRect.frame.contains(activeBar.frame.origin) || activeObjectiveRect.frame.origin.y == activeBar.frame.origin.y || (activeObjectiveRect.frame.origin.y + activeObjectiveRect.frame.size.height == activeBar.frame.origin.y){
            //User Won
            barsCompleted++
            
            //Get the current active bars container
            var barsContainer: UIView!
            
            if container1IsLeft {
                barsContainer = barsContainer1
            } else {
                barsContainer = barsContainer2
            }
            
            //Check if user put the bar on the bottom edge of the objective rect
            if activeBar.frame.origin.y == activeObjectiveRect.frame.origin.y + activeObjectiveRect.frame.size.height {
                //"Good"
                createWinLabelWithText("GOOD", inBarsContainer: barsContainer)
                setScoreWithBonus(kScoreIncreaseFactor)
                
                //Create the particles because the user did a perfect bar score
                createParticlesAtPosition(activeObjectiveRect.center, inBarsContainer: barsContainer)
                
            } else if activeBar.frame.origin.y == activeObjectiveRect.frame.origin.y + activeObjectiveRect.frame.size.height/2.0 {
                //The user put the bar on the middle of the objective rect 
                createWinLabelWithText("GREAT!", inBarsContainer: barsContainer)
                setScoreWithBonus(kScoreIncreaseFactor * 2)
                
                //Create the particles because the user did a perfect bar score
                createParticlesAtPosition(activeObjectiveRect.center, inBarsContainer: barsContainer)
            
            } else if activeBar.frame.origin.y == activeObjectiveRect.frame.origin.y {
                //The user put the bar on the top of the objective rect 
                createWinLabelWithText("PERFECT", inBarsContainer: barsContainer)
                setScoreWithBonus(kScoreIncreaseFactor * 3)
                
                //Create the particles because the user did a perfect bar score
                createParticlesAtPosition(activeObjectiveRect.center, inBarsContainer: barsContainer)
                
            } else {
                let num = arc4random()%2
                if (num == 0) {
                    createWinLabelWithText("OK!", inBarsContainer: barsContainer)
                } else {
                    createWinLabelWithText("NOT BAD", inBarsContainer: barsContainer)
                }
                setScoreWithBonus(0)
            }
            
            prepareNextBar()
        } else {
            userLost()
        }
    }
    
    func setScoreWithBonus(bonus: Int) {
        correctBars++
        score += kScoreIncreaseFactor;
        score += bonus
        updateLabel()
    }
    
    func userLost() {
        gamesLostInCurrentGame++
        saveTotalTouches()
        saveBarsCompleted()
        gamesLost++
        saveGamesLost()
        
        stopTimer()
        var pixelDifference: CGFloat
        
        //Calculamos la diferencia en pixeles entre el limite del objectiveRect y la barra 
        //Detectamos si el usuario perdió porque se pasó o porque oprimió antes de llegar
        if activeBar.frame.origin.y < activeObjectiveRect.frame.origin.y {
            //El usuario se pasó
            pixelDifference = activeObjectiveRect.frame.origin.y - activeBar.frame.origin.y
            println("**** \(activeObjectiveRect.frame.origin.y) - \(activeBar.frame.origin.y)")
            println("Me pasé por \(pixelDifference) pixeles")
            
        } else {
            pixelDifference = activeBar.frame.origin.y - (activeObjectiveRect.frame.origin.y + activeObjectiveRect.frame.size.height)
            println("*** \(activeBar.frame.origin.y - (activeObjectiveRect.frame.origin.y + activeObjectiveRect.frame.size.height))")
            println("No alcanzé por \(pixelDifference) pixeles")
        }
        
        if pixelDifference > 6 || trainingModeActivated == true {
            //Dont zoom because the difference was too high or we are in training mode or we already watched a video
            showLostAlert()
            saveUserScore()
            checkAchievements()
            return;
        }
        
        //Calculate the required coins to continue the current game 
        coinsNeededToContinue = Int(pow(Double(kCoinsNeededMultiplier), Double(gamesLostInCurrentGame - 1)))
        
        //If the user lost by few pixels, zoom in the bars and show the options
        zoomInBars()
    }
    
    //MARK: UI Stuff
    
    func createParticlesAtPosition(position: CGPoint, inBarsContainer: UIView) {
        var particlesView = DWFParticleView(frame: CGRect(x: position.x, y: position.y, width: 40.0, height: 40.0))
        particlesView.center = position
        particlesView.backgroundColor = UIColor.clearColor()
        inBarsContainer.addSubview(particlesView)
        
        let emittingDelay = 0.3 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(emittingDelay))
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            particlesView.setIsEmitting(false)
        })
        
        let removeDelay = 3.0 * Double(NSEC_PER_SEC)
        let removeTime = dispatch_time(DISPATCH_TIME_NOW, Int64(removeDelay))
        dispatch_after(removeTime, dispatch_get_main_queue()) { () -> Void in
            particlesView.removeFromSuperview()
            println("Removiendooooooooo")
        }
    }
    
    func updateLabel() {
        countingLabel.countFromCurrentValueTo(Float(score), withDuration: 0.4)
        timeLabel.text = "\(correctBars)"
    }
    
    func updateCoins(coins: Int) {
        highScoreLabel.text = "\(coins)"
    }
    
    //MARK: Resetting bar positions
    
    func setBarsToOriginInContainer(barsContainer: UIView, initialIndex: Int, finalIndex: Int) {
        let randomPalette = Int(arc4random()%UInt32(palettesArray.count))
        selectedPalette = randomPalette
        for index in initialIndex...finalIndex {
            if let barView = barsContainer.viewWithTag(index) {
                barView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
                barView.backgroundColor = palettesArray[randomPalette][speedsArray[index - 1] - 3] as UIColor
            }
            
            if let objectiveBar = barsContainer.viewWithTag(index + 1000) {
                var newFrame = objectiveBar.frame
                
                var randomHeight = arc4random()%UInt32(view.bounds.size.height - 383.0)
                randomHeight += 85
                newFrame.origin.y = CGFloat(randomHeight)
                objectiveBar.frame = newFrame
                objectiveBar.backgroundColor = objBarColors[randomPalette].colorWithAlphaComponent(0.7)
            }
        }
    }
    
    func setContainer1BarsToOrigin() {
        if expertModeActivated == false && trainingModeActivated == false {
            randomizeSpeedsBetweenLowIndex(0, maxIndex: kNumberOfBarsInScreen - 1)
        }
        setBarsToOriginInContainer(barsContainer1, initialIndex: 1, finalIndex: kNumberOfBarsInScreen)
    }
    
    func setContainer2BarsToOrigin() {
        if expertModeActivated == false && trainingModeActivated == false {
            randomizeSpeedsBetweenLowIndex(kNumberOfBarsInScreen, maxIndex: kNumberOfBarsInScreen*2 - 1)
        }
        setBarsToOriginInContainer(barsContainer2, initialIndex: kNumberOfBarsInScreen + 1, finalIndex: kNumberOfBarsInScreen * 2)
    }
    
    //MARK: Custom Methods
    
    func randomizeSpeedsBetweenLowIndex(lowIndex: Int, maxIndex: Int) {
        for index in lowIndex...maxIndex {
            var randomSpeed = Int(arc4random()%5 + 3)
            speedsArray[index] = randomSpeed
        }
    }
    
    func prepareNextBar() {
        activeBarIndex++;
        
        //If the user ended moving a set of 5 bars, animate and show the new bars
        if (activeBarIndex == kNumberOfBarsInScreen + 1 || activeBarIndex == kNumberOfBarsInScreen * 2 + 1) {
            stopTimer()
            animateContainerHorizontally()
            
        } else {
            stopTimer()
            startTimer()
        }
    }
    
    //MARK: Game Resetting 
    
    func resetBarsContainer(barsContainer: UIView, initIndex: Int, finalIndex: Int) {
        selectedPalette = Int(arc4random()%UInt32(palettesArray.count))
        for index in initIndex...finalIndex {
            if let barView = barsContainer.viewWithTag(index) {
                barView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
                barView.backgroundColor = palettesArray[selectedPalette][speedsArray[index - 1] - 3] as UIColor
            }
            
            if let objectiveBar = barsContainer.viewWithTag(index + 1000) {
                var newFrame = objectiveBar.frame
                
                var randomHeight = arc4random()%UInt32(view.bounds.size.height - 383.0)
                randomHeight += 85
                newFrame.origin.y = CGFloat(randomHeight)
                objectiveBar.frame = newFrame
                objectiveBar.backgroundColor = objBarColors[selectedPalette].colorWithAlphaComponent(0.7)
            }
        }
        //startTimer()
    }
    
    func resetGame() {
        gamesLostInCurrentGame = 0
        userDidResetGame = true
        gameActivated = true
        userViewedVideoOrUsedCoin = false
        correctBars = 0
        score = 0
        updateLabel()
        
        if self.container1IsLeft {
            //Perdiste estando en el container 1
            activeBarIndex = 1
            if expertModeActivated == false  && trainingModeActivated == false {
                randomizeSpeedsBetweenLowIndex(0, maxIndex: kNumberOfBarsInScreen - 1)
            }
            resetBarsContainer(barsContainer1, initIndex: 1, finalIndex: kNumberOfBarsInScreen)
            
        } else {
            //Perdiste estando en el container 2
            activeBarIndex = kNumberOfBarsInScreen + 1
            if expertModeActivated == false && trainingModeActivated == false {
                randomizeSpeedsBetweenLowIndex(kNumberOfBarsInScreen, maxIndex: kNumberOfBarsInScreen * 2 - 1)
            }
            resetBarsContainer(barsContainer2, initIndex: kNumberOfBarsInScreen + 1, finalIndex: kNumberOfBarsInScreen * 2)
        }
    }
    
    //MARK: Saving Data
    
    func giveCoinsToUser() {
        var currentCoins = UserData.sharedInstance().getCoins()
        currentCoins += 5
        UserData.sharedInstance().setCoins(currentCoins)
        
        updateCoins(currentCoins)
    }
    
    func checkAchievements() {
        if trainingModeActivated == false {
            if expertModeActivated == false {
                //Check the Arcade Achievements
                if score >= 10000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Arcade10000")
                }
                
                if score >= 50000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Arcade50000")
                }
                
                if score >= 100000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Arcade100000")
                }
                
                if score >= 250000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Arcade250000")
                }
                
                if score >= 500000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Arcade500000")
                }
                
                if score >= 1000000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Arcade1000000")
                }
            
            } else {
                //Check the Expert achievements
                if score >= 10000 {
                    println("***** DEBERIA DARLE EL ACHIEVEMENT DE 10000 EN ARCADE")
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Expert10000")
                }
                
                if score >= 50000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Expert50000")
                }
                
                if score >= 100000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Expert100000")
                }
                
                if score >= 250000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Expert250000")
                }
                
                if score >= 500000 {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Expert500000")
                }
                
                if (score >= 1000000) {
                    GameKitHelper.sharedGameKitHelper().reportAchievementWithID("Expert1000000")
                }
            }
        }
    }
    
    func saveGamesLost() {
        if trainingModeActivated == false {
            UserData.sharedInstance().setGamesLost(gamesLost)
        }
    }
    
    func saveBarsCompleted() {
        if trainingModeActivated == false {
            UserData.sharedInstance().setBarsCompleted(barsCompleted)
            GameKitHelper.sharedGameKitHelper().submitScore(Int64(barsCompleted), category: "Bars_Completed_Leaderboard")
        }
    }
    
    func saveTotalTouches() {
        if trainingModeActivated == false {
            UserData.sharedInstance().setTotalTouches(totalTouches)
        }
    }
    
    func userBeatHighScore() -> Bool {
        var savedHighScore: Int;
        if expertModeActivated == true {
            //Get the current expert high score
            savedHighScore = UserData.sharedInstance().getExpertScore()
        } else {
            //Get the current arcade high score
            savedHighScore = UserData.sharedInstance().getScore()
        }
        if score > savedHighScore {
            println("Hice hihg scoreeeeeeee")
            return true
        } else {
            println("No hice high scoreeeeeee")
            return false
        }
    }
    
    func saveUserScore() {
        if userBeatHighScore() && trainingModeActivated == false {
            if expertModeActivated == true {
                //We are playing the expert mode, so save the score to the expert field
                UserData.sharedInstance().setExpertScore(score)
                GameKitHelper.sharedGameKitHelper().submitScore(Int64(score), category: "Expert_Leaderboard")
            } else {
                //We are playing the arcade mode, so save the score to the arcade field
                UserData.sharedInstance().setScore(score)
                GameKitHelper.sharedGameKitHelper().submitScore(Int64(score), category: "Arcade_Leaderboard")
            }
            
            //Update max score label
            //highScoreLabel.text = "\(score)"
        }
    }
    
    //MARK: Ads Stuff
    
    func setupVideoAd() {
        //let error = NSErrorPointer()
        println("Info del debugging: \(VungleSDK.sharedSDK().debugInfo())")
        if VungleSDK.sharedSDK().isCachedAdAvailable() {
            VungleSDK.sharedSDK().playAd(self, error: nil)
        } else {
            println("No hay publicidad para mostrar")
            UIAlertView(title: "Oops!", message: "There's no video available right now. Please try again in a moment.", delegate: self, cancelButtonTitle: "Ok").show()
        }
    }
    
    func showTapLabel() {
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: .CurveLinear,
            animations: { () -> Void in
                self.tapLabel.alpha = 1.0
        }) { (success) -> Void in
            self.readyToBeginGame = true
        }
    }
    
    func hiddeTapLabel() {
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: .CurveLinear | .AllowUserInteraction,
            animations: { () -> Void in
                self.tapLabel.alpha = 0.0
        }) { (success) -> Void in
            
        }
    }
    
    //MARK: Alerts
    
    func showBuyAlertWithProducts(products: Array<IAPProduct>) {
        let buyView = BuyCoinsView(frame: CGRect(x: view.bounds.size.width/2.0 - 125.0, y: view.bounds.size.height/2.0 - 210.0, width: 250.0, height: 420.0))
        buyView.delegate = self
        buyView.productsArray = products
        buyView.showInView(view)
    }
    
    func showContinueGameAlert() {
        let continueAlert = OneButtonAlert(frame: CGRect(x: view.bounds.size.width/2.0 - 100.0, y: view.bounds.size.height/2.0 - 75.0, width: 200.0, height: 150.0))
        continueAlert.acceptButtonTitle = "Continue!"
        continueAlert.message = "Now you can continue playing the current game! Be ready!"
        continueAlert.delegate = self
        continueAlert.showInView(view)
    }
    
    func showViewVideoAlert() {
        gameActivated = false
        
        videoAlert = ThreeButtonsAlert(frame: CGRect(x: view.bounds.size.width/2.0 - 125.0, y: view.bounds.size.height/2.0 - 210.0, width: 250.0, height: 420.0))
        videoAlert.firstButtonTitle = "Watch Video (Gift: 5 Coins)"
        videoAlert.secondButtonTitle = "Use Coins (\(coinsNeededToContinue) Required)"
        videoAlert.thirdButtonTitle = "Restart Game"
        videoAlert.message = "You missed by just a few pixels! you can watch a video or use a coin to continue the current game!"
        videoAlert.delegate = self
        videoAlert.currentScoreLabel.text = "\(score)"
        
        if gamesLostInCurrentGame >= 2 {
            videoAlert.firstButton.hidden = true
        }
        
        videoAlert.showInView(view)
    }
    
    func showInitialAlert() {
        let twoButtonsAlert = TwoButtonsAlert(frame: CGRect(x: view.bounds.size.width/2.0 - 125.0, y: view.bounds.size.height/2.0 - 105.0, width: 250.0, height: 210.0))
        twoButtonsAlert.tag = 1
        twoButtonsAlert.leftButtonTitle = "Start!"
        twoButtonsAlert.rightButtonTitle = "Exit"
        if trainingModeActivated == true {
            twoButtonsAlert.message = "Modo Entrenamiento! Usa el Slider superior para controlar la velocidad de las barras. Toca en la pantalla para parar la barra dentro del pequeño recuadro."
        } else {
            twoButtonsAlert.message = "Bienvenido a Bars! Tendrás que parar cada barra dentro de los pequeños rectángulos. Toca en la pantalla para parar la barra. Entre mas color tenga una barra, mas rápido irá"
        }

        twoButtonsAlert.delegate = self
        twoButtonsAlert.showInView(view)
    }
    
    func showAd() {
        /*if FlurryAds.adReadyForSpace("TopBanner") {
            FlurryAds.displayAdForSpace("TopBanner", onView: view, viewControllerForPresentation: self)
        }*/
        FlurryAds.fetchAndDisplayAdForSpace("TopBanner", view: view, viewController: self, size: BANNER_TOP)
    }
    
    func hiddeAd() {
        FlurryAds.removeAdFromSpace("TopBanner")
    }
    
    func showLostAlert() {
        showAd()
        gameActivated = false
        
        let gameOverAlert = GameOverAlert(frame: CGRect(x: view.bounds.size.width/2.0 - 125.0, y: view.bounds.size.height/2.0 - 110.0, width: 250.0, height: 220.0))
        gameOverAlert.score = score
        gameOverAlert.titleText = "Score"
        gameOverAlert.delegate = self
        
        if expertModeActivated == true {
            gameOverAlert.bestScore = "\(UserData.sharedInstance().getExpertScore())"
        } else if trainingModeActivated == true {
            gameOverAlert.bestScore = "---"
        } else {
            gameOverAlert.bestScore = "\(UserData.sharedInstance().getScore())"
        }
        
        if userBeatHighScore() && trainingModeActivated == false {
            gameOverAlert.userDidHighScore = true
            gameOverAlert.titleText = "High Score!"
        }
        
        gameOverAlert.showInView(view)
    }
    
    //MARK: GameOVerAlertDelegate
    
    func rankingsButtonPressedInAlert() {
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.viewState = GKGameCenterViewControllerState.Leaderboards
        gameCenterVC.gameCenterDelegate = self
        presentViewController(gameCenterVC, animated: true, completion: nil)
    }
    
    func restartButtonPressedInGameOverAlert() {
        hiddeAd()
        resetGame()
        showTapLabel()
    }
    
    func gameOverAlertDidDisappearFromResetting() {
        //startTimer()
    }
        
    func exitButtonPressedInAlert() {
        hiddeAd()
        dismissVC()
    }
    
    //MARK: ThreeButtonsAlertDelegate
    
    func firstButtonPressedInAlert(alert: ThreeButtonsAlert) {
        //Watch video
        setupVideoAd()
    }
    
    func secondButtonPressedInAlert(alert: ThreeButtonsAlert) {
        //Use Coins
        let coins = UserData.sharedInstance().getCoins()
        if coins >= coinsNeededToContinue {
            userViewedVideoOrUsedCoin = true
            alert.closeAlert()
            zoomOutBars()
            UserData.sharedInstance().setCoins(coins - coinsNeededToContinue)
            updateCoins(coins - coinsNeededToContinue)
            
        } else {
            if let shopVC = storyboard?.instantiateViewControllerWithIdentifier("Shop") as? ShopViewController {
                shopVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                presentViewController(shopVC, animated: true, completion: nil)
            }

            //UIAlertView(title: "Oops!", message: "You don't have coins available.", delegate: self, cancelButtonTitle: "OK").show()
            //The user doesn't have coins available. Get the In-App Purchases and show the buy alert 
            /*MBProgressHUD.showHUDAddedTo(view, animated: true)
            CPIAPHelper.sharedInstance().requestProductsWithCompletionHandler({ (success, products) -> Void in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if success {
                    let productsArray = products as Array<IAPProduct>
                    self.showBuyAlertWithProducts(productsArray)
                }
            })*/
        }
    }
    
    func thirdButtonPressedInAlert(alert: ThreeButtonsAlert) {
        //Restart game
        saveUserScore()
        resetGame()
        zoomOutBars()
        alert.closeAlert()
    }
    
    func fourthButtonPressedInAlert(alert: ThreeButtonsAlert) {
        //Exit game
        saveUserScore()
        dismissVC()
    }
    
    func threeButtonsAlertDidDissapear() {
        
    }
    
    //MARK: TwoButtonsAlertDelegate
    //Initial welcome alert
    func leftButtonPressedInAlert(alert: TwoButtonsAlert) {
        if alert.tag == 1 {
            gameWillBegin = true
            showTapLabel()
            alert.closeAlert()
        } 
    }
    
    func rightButtonPressedInAlert(alert: TwoButtonsAlert) {
        if alert.tag == 1 {
            //Start game alert - exit button
            dismissVC()
            alert.closeAlert()
        }
    }
    
    func twoButtonsAlertDidDissapear(alert: TwoButtonsAlert) {
        if alert.tag == 1 {
            if gameWillBegin {
                //gameActivated = true
                //startTimer()
            }
        }
    }
    
    //MARK: OneButtonAlertDelegate
    
    func acceptButtonPressedInAlert(alert: OneButtonAlert) {
        userDidResetGame = false
        activeBarIndex++
        readyToBeginGame = true
        showTapLabel()
        gameActivated = true
    }
    
    func oneButtonAlertDidDissapear(alert: OneButtonAlert) {
        
    }
    
    //MARK: BuyCoinsViewDelegate
    
    func UserBoughtCoinsSuccessfully(totalCoins: Int) {
        //Update the coins label in the game view 
        updateCoins(totalCoins)
        
        //Update the use coins button in the alert
        videoAlert.secondButtonTitle = "Use Coin (\(totalCoins) left)"
    }
    
    //MARK: VungleSDKDelegate
    
    func vungleSDKhasCachedAdAvailable() {
        println("La ad esta en cacheeeee")
    }
    
    func vungleSDKwillShowAd() {
        println("Mostraremos la adddddd")
    }
    
    func vungleSDKwillCloseAdWithViewInfo(viewInfo: [NSObject : AnyObject]!, willPresentProductSheet: Bool) {
        if !willPresentProductSheet {
            println("Time to restart the state of the app")
            userViewedVideoOrUsedCoin = true
            videoAlert.closeAlert()
            zoomOutBars()
            giveCoinsToUser()
        }
    }
    
    func vungleSDKwillCloseProductSheet(productSheet: AnyObject!) {
        println("Produc sheet closed, time to restart the state of the app")
        userViewedVideoOrUsedCoin = true
        videoAlert.closeAlert()
        zoomOutBars()
        giveCoinsToUser()
    }
    
    //MARK: GameCenterDelegate
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
