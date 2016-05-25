//
//  ViewController.swift
//  Gem
//
//  Created by Dilan Jenkins on 5/23/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

//TODO
//============
//views
//      menu
//      all levels
//      move game board into own view
//      level editor view?
//      credits view, with artists who created artwork
//          problem: Need to find artists from laptop, not in archived files
//
//(DONE)add functioning timer to game board
//(DONE)should resize gems based on size of board/screen
//(DONE)need better title for game:       Gemicus
//(DONE)maybe a bit more randomness to gem colors on start
//(DONE)change startX and startY to be based off screen size for gem positioning
//(DONE)somehow change app title to Gemicus
//(DONE)need to compare board to winning board after each button press
//(DONE)create board from actual level data
//(DONE)need an overlay shown that shows the winning board
//(DONE)better handling of gem presses, should not search through every one
//
//different app icon then default
//add level data to game board, i.e level title, creator name, your best score...
//read in default levels from another file so that they are not in the code
//add in GUI buttons programatically(i.e timer/overlay)
//      should be resized similarly to gems based on total screen size
//			timer on top(DONE), back to menu button before timer, overlay button
//				popup/enable a next level button when level is won
//				(DONE)maybe have press on timer be the overlay button
//			underneath timer have level name centered
//		maybe keep level name on same line as buttons if screen is big enough
//
//future ideas
//      (*)level editor, can save levels to own device or share with others via Gem Server
//		(*)rating system for each created/default level, posts to Gem Server. Allow rating on score screen
//      search created levels by author,title...
//      animations for gems being pressed
//      random glint animations for gems
//      hint animations for gems that are not winning color
//      be able to swap gems that are neighbors with long gesture
//		animation for winning the level, and maybe a score screen

import UIKit

class ViewController: UIViewController
{
	//keeps track of all the gems on the board
    var allGems = [Gem]()
	
	//a timer object that allows the timer's clock to be updated very second
    var timer = NSTimer()
	
	//keeps track of total time spent on the board, not including paused time
    var timeCount = 0
	
	//a timer button that shows the total time
	var timerView: UIButton!
	
	//a dictionary for showing which button corresponds to which index in allGems
	var gemDict = [UIButton : Int]()
	
	//the current level based on the index in the Level.defaultLevels array
	var currentLevel = 0
	
	//true if currently showing level overlay or false otherwise
	var showingOverlay = false
	
	//keeps a copy of the colors of each gem for when the overlay is being shown
	var gemCopy = [Int]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "stone")!)
		let level = Level.defaultLevels()[ currentLevel ]
		createGUI()
		createGems( level.totalRows * level.totalRows )
        addGemPressEvents()
		showGemOverlay()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
	
	//setups the different GUI elements around the game board
	func createGUI()
	{
		timerView = UIButton(type: UIButtonType.Custom) as UIButton
		timerView.addTarget( self, action: #selector( self.toggleOverlay) , forControlEvents: .TouchUpInside)
		let x = 0
		let y = 20
		let width = 128
		let height = 40
		timerView.frame = CGRectMake( CGFloat( x ), CGFloat( y ), CGFloat( width ), CGFloat(height))
		self.view.addSubview(timerView)
		let newImage = UIImage( named: "timer" ) as UIImage?
		timerView.setBackgroundImage( newImage, forState: .Normal )
		changeTimerClock()
	}
	
	//called when the overlay button is pressed
	//shows the overlay if not being shown,hides if is being shown
	func toggleOverlay( sender: AnyObject)
	{
		if ( showingOverlay )
		{
			hideGemOverlay()
		}
		else
		{
			showGemOverlay()
		}
	}
	
	//returns true if the current game board is the winning board or false otherwise
	//returns false if currently showing the level overlay
	func checkWin() -> Bool
	{
		if ( showingOverlay )
		{
				return false
		}
		
		let level = Level.defaultLevels()[ currentLevel ]
		var index = -1
		for gem in allGems
		{
			index = index + 1
			if gem.currentSprite != level.levelData[ index ]
			{
				return false
			}
		}
		
		return true
	}
	
	//creates the gem buttons and adds them to allGems
	//maxGems is the total gem buttons to be created
	func createGems( maxGems : Int)
    {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width * 0.8
        let screenHeight = screenSize.height * 0.8
		//let the padding to the left of the gem board be based on the width of the screen
        let startX = floor( Double( screenSize.width * 0.15 ) )
		//let the top left corner of the game board be based on the height of the screen
        let startY = floor( Double( screenSize.height * 0.2 ))
		
        let gemsPerRow = floor( sqrt( Double( maxGems ) ) )
        let totalSize = floor( screenWidth + screenHeight )
		//fancy math to make the width and height of each gem be resized based on total number of gems on the level
        let gemSize = Int(totalSize) / Int( ( gemsPerRow ) * 3 )
		
        print( "Gem size: \(gemSize)")
        for index in 0..<maxGems
        {
            let button   = UIButton(type: UIButtonType.Custom) as UIButton
            let column = ( index % Int( gemsPerRow ) )
            let row = ( index / Int(gemsPerRow) )
            let x = Double( ( column  * gemSize )  ) + startX
            let y = Double( ( row * gemSize )  ) + startY
            button.frame = CGRectMake( CGFloat( x ), CGFloat( y ), CGFloat( gemSize ), CGFloat(gemSize))
            self.view.addSubview(button)
			gemDict[ button ] = index
            allGems.append( Gem( gemButton: button, currentSprite: 0).randomImage() )
        }
    }
	
	//shows the level overlay and changes every gem to its winning color
	func showGemOverlay()
	{
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkstone")!)
		gemCopy.removeAll()
		showingOverlay = true
		let level = Level.defaultLevels()[ currentLevel ]
		var index = -1
		for gem in allGems
		{
			index = index + 1
			gemCopy.append( gem.currentSprite )
			gem.updateSprite( level.levelData[ index ] )
		}
	}
	
	//hides the level overlay and changes every gem back to its old color
	func hideGemOverlay()
	{
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "stone")!)
		var index = -1
		for gem in allGems
		{
			index = index + 1
			gem.updateSprite( gemCopy[ index ] )
		}
		showingOverlay = false
		gemCopy.removeAll()
	}

	//changes the text within the timer to the correct time
	func changeTimerClock()
	{
		timerView.setTitle( convertTimerTime( timeCount ), forState: .Normal )
	}
	
	//called every second, increments time and updates the timer clock
    func updateTime()
    {
		if ( !showingOverlay )
		{
			timeCount = timeCount + 1
			changeTimerClock()
		}
		
    }

	//converts the integer value provided to a clock value of format mm:ss
    func convertTimerTime( time : Int ) -> String
    {
        let minutes = time / 60
        let seconds = time % 60
        var toReturn = ""
        if ( minutes < 10 )
        {
            toReturn.append( "0" as Character )
        }
        toReturn = toReturn + String(minutes) + ":"

        if ( seconds < 10 )
        {
            toReturn.append( "0" as Character )
        }
        toReturn = toReturn + String( seconds )

        return toReturn
    }
	
	//adds press events to every gem button that was added to allGems
    func addGemPressEvents()
    {
        for gem in self.allGems
        {
            gem.gemButton.addTarget( self, action: #selector( self.clickGem) , forControlEvents: .TouchUpInside)
        }
    }

    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

	//fires when a gem is clicked
    func clickGem( sender: AnyObject)
    {
		//old code, inefficently checked every gem button for the one clicked
		/*
        for gem in self.allGems
        {
            if ( gem.gemButton == sender as! NSObject )
            {
                gem.changeImage()
                break
            }
        }	
		*/
		
		//if the level overlay is being shown then do not handle a click
		if ( showingOverlay )
		{
				return
		}
		
		//get the gem object pertaining to the button that was clicked and increment its sprite to next color
		let index = gemDict[ sender as! UIButton ]
		allGems[ index! ].changeImage()
		
		//if the board matches the winning board then the level is complete
		if checkWin()
		{
			endLevelWon()
		}
    }
	
	//handles the level being won, shows an overlay
	func endLevelWon()
	{
		print( "Level won!")
		timerView.userInteractionEnabled = false
		showingOverlay = true
		showGemOverlay()
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "winstone")!)
	}
}

