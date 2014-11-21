//
//  BarsViewController.swift
//  BarProto2
//
//  Created by Developer on 19/11/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

import UIKit

class BarsViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var containerUI: UIView!
    var barsContainer1: UIView!
    var barsContainer2: UIView!
    var perfectLabel: UILabel!
    var perfectLabel2: UILabel!
    var container1IsLeft = true
    var activeBarIndex: Int = 0;
    var barsTimer: NSTimer!
    var barSpeed: CGFloat = 4.0
    var increaseSpeedFactor: CGFloat = 0.0
    var activeBar: UIView!
    var activeObjectiveRect: UIView!
    var correctBars = 0
    var speedsArray: Array<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var blueColorsArray: Array<UIColor> = [UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0),
                                        UIColor(red: 0.8, green: 0.9, blue: 0.9, alpha: 1.0),
                                        UIColor(red: 0.7, green: 0.9, blue: 0.9, alpha: 1.0),
                                        UIColor(red: 0.6, green: 0.9, blue: 0.9, alpha: 1.0),
                                        UIColor(red: 0.5, green: 0.9, blue: 0.9, alpha: 1.0),
                                        UIColor(red: 0.4, green: 0.9, blue: 0.9, alpha: 1.0),
                                        UIColor(red: 0.3, green: 0.9, blue: 0.9, alpha: 1.0),
                                        UIColor(red: 0.2, green: 0.9, blue: 0.9, alpha: 1.0),
                                        UIColor(red: 0.1, green: 0.9, blue: 0.9, alpha: 1.0),
                                        UIColor(red: 0.0, green: 0.9, blue: 0.9, alpha: 1.0)]
    
    var colorsArray2: Array<UIColor> = [UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.8, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.7, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.6, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.5, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.4, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.3, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.2, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.1, blue: 0.9, alpha: 1.0)]
    
    var colorsArray3: Array<UIColor> = [UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.7, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.6, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.5, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.4, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.3, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.2, alpha: 1.0),
        UIColor(red: 0.9, green: 0.9, blue: 0.1, alpha: 1.0)]
    
    var colorPalettesArray = []
    var viewIsZoomed = false
    var pixelLabel: UILabel!
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        colorPalettesArray = [blueColorsArray, colorsArray2, colorsArray3]
        setupSpeeds()
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activeBarIndex++;
        startTimer()
    }
    
    //MARK: Custom Initialization Stuff
    
    func setupSpeeds() {
        //Randomize all the speeds
        for index in 0...9 {
            var randomSpeed = Int(arc4random()%10 + 1)
            speedsArray[index] = randomSpeed
        }
    }
    
    func setupUI() {
        barsContainer1 = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height))
        barsContainer2 = UIView(frame: CGRect(x: view.bounds.size.width, y: 0.0, width: view.bounds.size.width, height: view.bounds.size.height))
        setupContainer(barsContainer1, asInitialContainer: true)
        setupContainer(barsContainer2, asInitialContainer: false)
        
        perfectLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width/5.0, height: 20.0))
        perfectLabel.textColor = blueColorsArray[9]
        perfectLabel.font = UIFont.boldSystemFontOfSize(12.0)
        perfectLabel.text = ""
        perfectLabel.textAlignment = NSTextAlignment.Center
        barsContainer1.addSubview(perfectLabel)
        
        perfectLabel2 = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width/5.0, height: 20.0))
        perfectLabel2.textColor = blueColorsArray[9]
        perfectLabel2.font = UIFont.boldSystemFontOfSize(12.0)
        perfectLabel2.text = ""
        perfectLabel2.textAlignment = NSTextAlignment.Center
        barsContainer2.addSubview(perfectLabel2)
    }
    
    func setupContainer(barContainer: UIView, asInitialContainer: Bool) {
        barContainer.backgroundColor = UIColor.clearColor()
        view.addSubview(barContainer)
        
        var initialIndex: Int
        if asInitialContainer {
            initialIndex = 0
        } else {
            initialIndex = 5
        }
        
        let barWidth: CGFloat = (view.bounds.size.width - 12.0)/5.0
        let randomPalette = Int(arc4random()%3)
        
        for index in 0...4 {
            var randomHeight = arc4random()%UInt32(view.bounds.size.height - 367.0)
            randomHeight += 67
            
            let barView = UIView(frame: CGRect(x:2*CGFloat(index + 1) + CGFloat(index) * barWidth, y: view.bounds.size.height - 180.0, width: barWidth, height: view.bounds.size.height + 10.0))
            barView.backgroundColor = colorPalettesArray[randomPalette][speedsArray[index + initialIndex] - 1] as UIColor
            barView.tag = index + initialIndex + 1
            barContainer.addSubview(barView)
            
            let objectiveRect = UIView(frame: CGRect(x: barView.frame.origin.x, y: CGFloat(randomHeight), width: barWidth, height: 30.0))
            objectiveRect.backgroundColor = UIColor(red: 0.902, green: 0.640, blue: 1.000, alpha: 0.7)
            objectiveRect.tag = 1001 + index + initialIndex
            barContainer.addSubview(objectiveRect)
        }
    }
    
    //MARK: Game Start & Stop
    
    func stopTimer() {
        barsTimer.invalidate()
    }
    
    func startTimer() {
        barSpeed = CGFloat(speedsArray[activeBarIndex - 1])
        if barSpeed > 7 {
            barSpeed = 7
        } else if barSpeed < 3 {
            barSpeed = 3
        }
       
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
    
    func animateContainerHorizontally() {
        setPerfectLabelText("")
        
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
                    
                    self.activeBarIndex = 6
                    
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
    
    //MARK: Touches Handling
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if touches.count == 1 {
            if viewIsZoomed {
                //Zooom out
                var barsContainer: UIView!
                if container1IsLeft {
                    barsContainer = barsContainer1
                } else {
                    barsContainer = barsContainer2
                }
                
                UIView.animateWithDuration(2.0,
                    delay: 0.0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: { () -> Void in
                        barsContainer.transform = CGAffineTransformIdentity
                        self.pixelLabel.alpha = 0.0
                        
                    }) { (succes) -> Void in
                        self.pixelLabel.removeFromSuperview()
                        self.viewIsZoomed = false
                        self.showLostAlert()
                }

                
            } else {
                checkIfUserWon()
            }
        }
    }

    //MARK: Winning & Lossing
    
    func checkIfUserWon() {
        setupPerfectLabelPosition()
        
        if activeObjectiveRect.frame.contains(activeBar.frame.origin) || activeObjectiveRect.frame.origin.y == activeBar.frame.origin.y || (activeObjectiveRect.frame.origin.y + activeObjectiveRect.frame.size.height == activeBar.frame.origin.y){
            //User Won
            
            //Check if user put the bar on the bottom edge of the objective rect
            if activeBar.frame.origin.y == activeObjectiveRect.frame.origin.y + activeObjectiveRect.frame.size.height {
                //"Good"
                setPerfectLabelText("GOOD!")
                
            } else if activeBar.frame.origin.y == activeObjectiveRect.frame.origin.y + activeObjectiveRect.frame.size.height/2.0 {
                //The user put the bar on the middle of the objective rect 
                setPerfectLabelText("GREAT!")
            
            } else if activeBar.frame.origin.y == activeObjectiveRect.frame.origin.y {
                //The user put the bar on the top of the objective rect 
                setPerfectLabelText("PERFECT!")
                
            } else {
                let num = arc4random()%2
                if (num == 0) {
                    setPerfectLabelText("OK")
                } else {
                    setPerfectLabelText("NOT BAD")
                }
            }
            //hiddePerfectLabelAfterDelay()
            
            prepareNextBar()
            correctBars++
            updateLabel()
        } else {
            userLost()
        }
    }
    
    func userLost() {
        //User Lost
        perfectLabel.text = ""
        perfectLabel2.text = ""
        
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
        
        if pixelDifference > 2 {
            //Dont zoom because the difference was high
            //Show alert
            showLostAlert()
            return;
        }
        
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
        
        UIView.animateWithDuration(2.0,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                barsContainer.transform =
                    CGAffineTransformConcat(CGAffineTransformMakeTranslation(deltaVector.x, deltaVector.y),
                                            CGAffineTransformMakeScale(4.0, 4.0))
        }) { (success) -> Void in
            self.viewIsZoomed = true
            self.createPixelDiferenceLabel(Int(pixelDifference))
        }
    }
    
    //MARK: UI Stuff
    
    func createPixelDiferenceLabel(pixelDifference: Int) {
        pixelLabel = UILabel(frame: CGRect(x: 50.0, y: 100.0, width: view.bounds.size.width - 100.0, height: 60.0))
        pixelLabel.text = "You lost by \(pixelDifference) pixels!"
        pixelLabel.textColor = UIColor.lightGrayColor()
        pixelLabel.textAlignment = NSTextAlignment.Center
        pixelLabel.font = UIFont.systemFontOfSize(25.0)
        pixelLabel.numberOfLines = 0
        pixelLabel.alpha = 0.0
        view.addSubview(pixelLabel)
        
        UIView.animateWithDuration(1.0,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.pixelLabel.alpha = 1.0
        }) { (success) -> Void in
            
        }
    }
    
    func updateLabel() {
        timeLabel.text = "\(correctBars)"
    }
    
    //MARK: Resetting bar positions
    
    func setContainer1BarsToOrigin() {
        randomizeSpeedsBetweenLowIndex(0, maxIndex: 4)
        let randomPalette = Int(arc4random()%3)
        for index in 1...5 {
            if let barView = barsContainer1.viewWithTag(index) {
                barView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
                barView.backgroundColor = colorPalettesArray[randomPalette][speedsArray[index - 1] - 1] as UIColor
            }
            
            if let objectiveBar = barsContainer1.viewWithTag(index + 1000) {
                var newFrame = objectiveBar.frame
                
                var randomHeight = arc4random()%UInt32(view.bounds.size.height - 367.0)
                randomHeight += 67
                newFrame.origin.y = CGFloat(randomHeight)
                objectiveBar.frame = newFrame
            }
        }
    }
    
    func setContainer2BarsToOrigin() {
        randomizeSpeedsBetweenLowIndex(5, maxIndex: 9)
        let randomPalette = Int(arc4random()%3)
        for index in 6...10 {
            if let barView = barsContainer2.viewWithTag(index) {
                barView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
                barView.backgroundColor = colorPalettesArray[randomPalette][speedsArray[index - 1] - 1] as UIColor
            }
            
            if let objectiveBar = barsContainer2.viewWithTag(index + 1000) {
                var newFrame = objectiveBar.frame
                
                var randomHeight = arc4random()%UInt32(view.bounds.size.height - 367.0)
                randomHeight += 67
                newFrame.origin.y = CGFloat(randomHeight)
                objectiveBar.frame = newFrame
            }
        }
    }
    
    //MARK: Custom Methods
    
    func hiddePerfectLabelAfterDelay() {
        /*let delay = 1.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.perfectLabel.text = ""
        }*/
    }
    
    func setPerfectLabelText(text: String) {
        if container1IsLeft {
            perfectLabel.text = text
        } else {
            perfectLabel2.text = text
        }
    }
    
    func setupPerfectLabelPosition() {
        var newFrame = activeObjectiveRect.frame
        newFrame.origin.y = newFrame.origin.y - 22.0
        
        if container1IsLeft {
            perfectLabel.frame = newFrame
        } else {
            perfectLabel2.frame = newFrame
        }
    }
    
    func randomizeSpeedsBetweenLowIndex(lowIndex: Int, maxIndex: Int) {
        for index in lowIndex...maxIndex {
            var randomSpeed = Int(arc4random()%10 + 1)
            speedsArray[index] = randomSpeed
        }
    }
    
    func prepareNextBar() {
        activeBarIndex++;
        
        //If the user ended moving a set of 5 bars, animate and show the new bars
        if (activeBarIndex == 6 || activeBarIndex == 11) {
            stopTimer()
            animateContainerHorizontally()
            
        } else {
            stopTimer()
            startTimer()
        }
    }
    
    //MARK: Game Resetting 
    
    func resetGame() {
        correctBars = 0
        updateLabel()
        
        if self.container1IsLeft {
            //Perdiste estando en el container 1
            activeBarIndex = 1
            //randomizeContainer1Speeds()
            randomizeSpeedsBetweenLowIndex(0, maxIndex: 4)
            let randomPalette = Int(arc4random()%3)
            for index in 1...5 {
                if let barView = barsContainer1.viewWithTag(index) {
                    barView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
                    barView.backgroundColor = colorPalettesArray[randomPalette][speedsArray[index - 1] - 1] as UIColor
                }
                
                if let objectiveBar = barsContainer1.viewWithTag(index + 1000) {
                    var newFrame = objectiveBar.frame
                    
                    var randomHeight = arc4random()%UInt32(view.bounds.size.height - 367.0)
                    randomHeight += 67
                    newFrame.origin.y = CGFloat(randomHeight)
                    objectiveBar.frame = newFrame
                }
            }
            startTimer()
            
        } else {
            //Perdiste estando en el container 2
            activeBarIndex = 6
            //randomizeContainer2Speeds()
            randomizeSpeedsBetweenLowIndex(5, maxIndex: 9)
            let randomPalette = Int(arc4random()%3)
            for index in 6...10 {
                if let barView = barsContainer2.viewWithTag(index) {
                    barView.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
                    barView.backgroundColor = colorPalettesArray[randomPalette][speedsArray[index - 1] - 1] as UIColor
                }
                
                if let objectiveBar = barsContainer2.viewWithTag(index + 1000) {
                    var newFrame = objectiveBar.frame
                    
                    var randomHeight = arc4random()%UInt32(view.bounds.size.height - 367.0)
                    randomHeight += 67
                    newFrame.origin.y = CGFloat(randomHeight)
                    objectiveBar.frame = newFrame
                }
            }
            startTimer()
        }
    }
    
    //MARK: Alerts
    
    func showLostAlert() {
        UIAlertView(title: "Juego Terminado", message: "Has completado \(correctBars) barras!", delegate: self, cancelButtonTitle: "Reintentar").show()
    }
    
    //MARK: UIAlertViewDelegate
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        resetGame()
    }
}
