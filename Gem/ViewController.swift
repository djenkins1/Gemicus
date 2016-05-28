//
//  ViewController.swift
//  Gem
//
//  Created by Dilan Jenkins on 5/23/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

//TODO
//============
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
//(DONE)be able to swap gems that are neighbors with long gesture
//(DONE)has multiple timer objects updating clock, need to stop the timer object when view is destroyed
//(DONE)read in default levels from another file so that they are not in the code
//(DONE)should check to see if won after swapping gems as well
//(SCRAP)change background of timer to hover background when level won
//(DONE)handle winning last level more gracefully
//(DONE)somehow change the next level button so that it is different when you can go to next level
//(DONE)have different backgrounds then current for menu buttons
//		(DONE)find better gem sprites that match background more?
//		(DONE)better background image for level title other then the timer background
//(DONE)add in GUI buttons programatically(i.e timer/overlay)
//		(DONE)timer on top
//		(DONE)popup/enable a next level button when level is won
//		(DONE)maybe have press on timer be the overlay button
//		(DONE)level name centered, above buttons
//		(DONE)back to menu button before timer
//		(DONE)center the timer in the view and position prev/next buttons on either side
//(DONE)make the text color for title backgrounds be non-white, i.e darker
//(DONE)only enable to back button/all levels button when the overlay is being shown
//(DONE)clicking on level title should bring you too all levels view
//(DONE)add title for levels view like in game board
//
//views
//      (DONE)menu
//      (DONE)all levels view
//      (DONE)credits view, with artists who created artwork
//      level editor view, would need to get size of board from user somehow(maybe allow dynamic resizing?)
//		help/info view. Maybe have a tutorial?
//
//rewrite code to allow for non-square boards
//maybe have gems centered in view
//		if gems get centered, levels should as well in all levels view
//different app icon then default
//change link for myself in credits file
//
//future ideas
//      (*)level editor, can save levels to own device or share with others via Gem Server
//		(*)rating system for each created/default level, posts to Gem Server. Allow rating on score screen
//		change arrows on prev/next buttons to actual images?
//			also maybe have enabled arrow images for when the buttons are actually clickable
//      search created levels by author,title...
//      animations for gems being pressed
//      random glint animations for gems
//      hint animations for gems that are not winning color
//		animation for winning the level, and maybe a score screen
//		if level button size gets below certain amount put multiple pages on all levels view
//		longer swipes should do multiple swaps of gems if possible
//			see bookmarks, have stack overflow answer that could work here
//		add level data to game board, i.e level title(DONE), creator name, your best score...
//			maybe just for player created levels
//			maybe show up on win screen for the level?
//		add level info preview at bottom of level view
//		powerup system
//			examples: change all gems to certain color
//		save progress of levels beaten/times/number of moves/number of color changes
//		put levels into level packs, i.e folders with names
//			have level pack named ipad that has larger boards

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
	
	//a button that when pushed goes to next level
	var nextButton: UIButton!
	
	//a button that when pushed goes back to menu
	var prevButton: UIButton!
	
	//a dictionary for showing which button corresponds to which index in allGems
	var gemDict = [UIButton : Int]()
	
	//the current level based on the index in the Level.defaultLevels array
	//start it off at -1 so that gotoNextLevel function works on game start
	var currentLevel = -1
	
	//true if currently showing level overlay or false otherwise
	var showingOverlay = false
	
	//keeps a copy of the colors of each gem for when the overlay is being shown
	var gemCopy = [Int]()
	
	//stores the data for the default levels
	var levelHandler: LevelHandler!

    override func viewDidLoad()
    {
        super.viewDidLoad()
		readLevels()
		createMenuView()
    }
	
	//deletes all current elements in the view and makes the menu GUI
	func createMenuView()
	{
		resetMyView()
		clearBoardData()
		let gameTitle = UIButton(type: UIButtonType.Custom) as UIButton
		let playButton = UIButton(type: UIButtonType.Custom) as UIButton
		let infoButton = UIButton(type: UIButtonType.Custom) as UIButton
		let credButton = UIButton(type: UIButtonType.Custom) as UIButton
		let levelButton = UIButton(type: UIButtonType.Custom) as UIButton
		
		let screenWidth = UIScreen.mainScreen().bounds.width
		let titleWidth = Int( ceil(screenWidth * 0.5) )
		let padding = Int( ceil( UIScreen.mainScreen().bounds.height * 0.04 ) )
		let centerX = screenWidth / 2
		let startY = Int( ceil( UIScreen.mainScreen().bounds.width * 0.33 ) )
		let defaultWidth = 128
		let defaultHeight = 32
		gameTitle.frame = CGRectMake( CGFloat( centerX - CGFloat( titleWidth / 2 ) ), CGFloat( startY ), CGFloat( titleWidth ), CGFloat(defaultHeight ))
		playButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + padding + defaultHeight ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
		levelButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + (2 * ( padding  + defaultHeight ) ) ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
		infoButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + (3 * ( padding  + defaultHeight ) ) ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
		credButton.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + (4 * (padding + defaultHeight ) ) ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
		
		let backImage = UIImage( named: "menuButton" ) as UIImage?
		let titleImage = UIImage( named: "title" ) as UIImage?
		gameTitle.setBackgroundImage( titleImage, forState: .Normal )
		playButton.setBackgroundImage( backImage, forState: .Normal )
		infoButton.setBackgroundImage( backImage, forState: .Normal )
		credButton.setBackgroundImage( backImage, forState: .Normal )
		levelButton.setBackgroundImage( backImage, forState: .Normal )
		
		//isbeauty.setTitleColor(UIColorFromRGB("F21B3F"), forState: .Normal)
		gameTitle.setTitleColor( UIColor.blackColor(), forState: .Normal)
		playButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		infoButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		credButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		levelButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		
		gameTitle.setTitle( "Gemicus", forState: .Normal )
		gameTitle.userInteractionEnabled = false
		playButton.setTitle( "Play", forState: .Normal )
		infoButton.setTitle( "Help", forState: .Normal )
		credButton.setTitle( "Credits", forState: .Normal )
		levelButton.setTitle( "Levels", forState: .Normal )
		
		self.view.addSubview(gameTitle)
		self.view.addSubview(playButton)
		self.view.addSubview(levelButton)
		self.view.addSubview(infoButton)
		self.view.addSubview(credButton)
		
		
		//playButton.addTarget( self, action: #selector( self.toggleOverlay) , forControlEvents: .TouchUpInside)
		playButton.addTarget( self, action: #selector( self.gotoNextLevel) , forControlEvents: .TouchUpInside)
		levelButton.addTarget( self, action: #selector( self.gotoLevelsView) , forControlEvents: .TouchUpInside)
		credButton.addTarget( self, action: #selector( self.gotoCreditsView) , forControlEvents: .TouchUpInside)
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkstone")!)
	}
	
	func createCreditsView()
	{
		let screenWidth = UIScreen.mainScreen().bounds.width
		let titleWidth = Int( ceil(screenWidth * 0.5) )
		let padding = Int( ceil( UIScreen.mainScreen().bounds.height * 0.04 ) )
		let centerX = screenWidth / 2
		let startY = Int( ceil( UIScreen.mainScreen().bounds.width * 0.33 ) )
		let defaultWidth = 128
		let defaultHeight = 32
		let roomTitle = UIButton(type: UIButtonType.Custom) as UIButton
		let titleImage = UIImage( named: "title" ) as UIImage?
		roomTitle.setBackgroundImage( titleImage, forState: .Normal )
		roomTitle.setTitle( "Credits" , forState: .Normal )
		roomTitle.setTitleColor( UIColor.blackColor(), forState: .Normal)
		roomTitle.frame = CGRectMake( CGFloat( centerX - CGFloat( titleWidth / 2 ) ), CGFloat( startY ), CGFloat( titleWidth ), CGFloat(defaultHeight ))
		roomTitle.addTarget( self, action: #selector( self.backToMenu ) , forControlEvents: .TouchUpInside)
		self.view.addSubview(roomTitle)
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkstone")!)
		
		let allCredits = readCredits()
		var index = 0
		for creditObj in allCredits
		{
			index = index + 1
			let button = UIButton(type: UIButtonType.Custom) as UIButton
			button.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth / 2 ) ), CGFloat( startY + ( index * ( padding  + defaultHeight ) ) ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
			let author = creditObj[ "author"]!
			let title = creditObj[ "title"]!
			button.setTitle( "\(title) - \(author)" , forState: .Normal )
			button.setTitleColor( UIColor.blackColor(), forState: .Normal)
			button.setBackgroundImage( titleImage, forState: .Normal )
			button.titleLabel!.font = button.titleLabel!.font.fontWithSize( 6 )
			button.tag = index - 1
			button.addTarget( self, action: #selector( self.clickCreditsTag(_:)) , forControlEvents: .TouchUpInside)
			//button.titleLabel!.adjustsFontSizeToFitWidth = true
			self.view.addSubview(button)
		}
	}
	
	func gotoLevelsView()
	{
		currentLevel = 0
		resetMyView()
		createLevelsView()
	}
	
	func gotoCreditsView()
	{
		currentLevel = 0
		resetMyView()
		createCreditsView()
	}
	
	func createGameView()
	{
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "stone")!)
		let level = Level.defaultLevels( levelHandler)[ currentLevel ]
		createGUI()
		createGems( level.totalRows * level.totalRows )
		addGemPressEvents()
		showGemOverlay()
		timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
	}
	
	func createLevelsView()
	{
		//NEED A WAY TO GET BACK TO MENU FROM HERE
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkstone")!)
		var index = -1
		let totalLevels = Level.defaultLevels(levelHandler).count
		let perRow = ceil( sqrt( Double(totalLevels) ) )
		let screenSize: CGRect = UIScreen.mainScreen().bounds
		let screenWidth = screenSize.width * 0.8
		let screenHeight = screenSize.height * 0.8
		//let the padding to the left of the gem board be based on the width of the screen
		let startX = floor( Double( screenSize.width * 0.15 ) )
		//let the top left corner of the game board be based on the height of the screen
		let startY = floor( Double( screenSize.height * 0.2 ))
		let totalSize = floor( screenWidth + screenHeight )
		let squareSize = Int(totalSize) / Int( ( perRow ) * 4 )
		let backImage = UIImage( named: "button" ) as UIImage?
		let titleImage = UIImage( named: "title" ) as UIImage?
		let paddingWidth = screenWidth * 0.02
		let paddingHeight = screenHeight * 0.02
		
		let roomTitle = UIButton(type: UIButtonType.Custom) as UIButton
		roomTitle.frame = CGRectMake( CGFloat( (screenSize.width / 2) - CGFloat( 128 / 2 ) ), CGFloat( startY -  48 ), CGFloat( 128 ), CGFloat(32))
		roomTitle.setBackgroundImage( titleImage, forState: .Normal )
		roomTitle.setTitle( "Levels" , forState: .Normal )
		roomTitle.setTitleColor( UIColor.blackColor(), forState: .Normal)
		roomTitle.addTarget( self, action: #selector( self.backToMenu ) , forControlEvents: .TouchUpInside)
		self.view.addSubview( roomTitle )
		
		for _ in Level.defaultLevels( levelHandler )
		{
			index = index + 1
			let levelButton = UIButton(type: UIButtonType.Custom) as UIButton
			let column = ( index % Int( perRow ) )
			let row = ( index / Int(perRow) )
			let x = Double( ( CGFloat(column)  * (CGFloat( squareSize ) + paddingWidth ) )  ) + startX
			let y = Double( ( CGFloat(row)  * (CGFloat( squareSize ) + paddingHeight ) )  ) + startY
			levelButton.frame = CGRectMake( CGFloat( x ), CGFloat( y ), CGFloat( squareSize ), CGFloat(squareSize))
			levelButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
			levelButton.setTitle( "\(index + 1)" , forState: .Normal )
			levelButton.setBackgroundImage( backImage, forState: .Normal )
			self.view.addSubview( levelButton )
			levelButton.addTarget( self, action: #selector( self.clickLevelButton(_:)) , forControlEvents: .TouchUpInside)
		}
	}
	
	func clickCreditsTag( sender: AnyObject )
	{
		let allCredits = readCredits()
		if let myTag = sender.tag
		{
			let url = allCredits[ myTag ][ "link"]!
			UIApplication.sharedApplication().openURL(NSURL(string: url)!)
		}
	}
	
	func clickLevelButton( sender: AnyObject )
	{
		let button = sender as! UIButton
		let myValue = Int( button.currentTitle! )! - 1
		if myValue < 0
		{
			print( "PROBLEM WITH Value \(myValue)")
			return
		}
		
		currentLevel = myValue - 1
		gotoNextLevel()
	}
	
	//removes all the elements currently in the view
	func resetMyView()
	{
		timer.invalidate()
		for view in self.view.subviews
		{
			view.removeFromSuperview()
		}
	}
	
	//setups the different GUI elements around the game board
	func createGUI()
	{
		let width = 128
		let height = 40
		let x = 0
		let y = 20 + height + 2
		let buttonWidth = 48
		let screenWidth = UIScreen.mainScreen().bounds.width
		let centerX = Int( ceil(screenWidth * 0.5))
		//let screenWidth = UIScreen.mainScreen().bounds.width * 0.5
		
		timerView = UIButton(type: UIButtonType.Custom) as UIButton
		timerView.addTarget( self, action: #selector( self.toggleOverlay) , forControlEvents: .TouchUpInside)
		timerView.frame = CGRectMake( CGFloat( centerX - ( width / 2 ) ), CGFloat( y ), CGFloat( width ), CGFloat(height))
		self.view.addSubview(timerView)
		let newImage = UIImage( named: "menuButton" ) as UIImage?
		let hiddenImage = UIImage( named: "hover" ) as UIImage?
		let titleImage = UIImage( named: "title" ) as UIImage?
		timerView.setBackgroundImage( newImage, forState: .Normal )
		timerView.setTitleColor( UIColor.blackColor(), forState: .Normal)
		changeTimerClock()
		
		nextButton = UIButton(type: UIButtonType.Custom) as UIButton
		nextButton.addTarget( self, action: #selector( self.gotoNextLevel) , forControlEvents: .TouchUpInside)
		nextButton.userInteractionEnabled = false
		nextButton.frame = CGRectMake( CGFloat( centerX + ( width / 2 ) + 8 ), CGFloat( y ), CGFloat( buttonWidth ), CGFloat(height))
		nextButton.setTitle( "->" , forState: .Normal )
		nextButton.setBackgroundImage( hiddenImage, forState: .Normal )
		nextButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		self.view.addSubview(nextButton)
		
		prevButton = UIButton(type: UIButtonType.Custom) as UIButton
		prevButton.frame = CGRectMake( CGFloat( centerX - ( width / 2 ) - buttonWidth - 8  ), CGFloat( y ), CGFloat( buttonWidth ), CGFloat(height))
		prevButton.setTitle( "<-" , forState: .Normal )
		prevButton.setBackgroundImage( hiddenImage, forState: .Normal )
		prevButton.addTarget( self, action: #selector( self.backToMenu) , forControlEvents: .TouchUpInside)
		prevButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		prevButton.userInteractionEnabled = false
		self.view.addSubview(prevButton)

		let level = Level.defaultLevels( levelHandler )[ currentLevel ]

		let levelTitle = UIButton(type: UIButtonType.Custom) as UIButton
		levelTitle.frame = CGRectMake( CGFloat( x ), CGFloat( y - height - 2), CGFloat( screenWidth ), CGFloat( height ))
		levelTitle.setTitle( level.levelName, forState: .Normal )
		levelTitle.setBackgroundImage( titleImage, forState: .Normal )
		//levelTitle.userInteractionEnabled = false
		levelTitle.addTarget( self, action: #selector( self.gotoLevelsView) , forControlEvents: .TouchUpInside)
		levelTitle.setTitleColor( UIColor.blackColor(), forState: .Normal)
		self.view.addSubview( levelTitle )
	}
	
	func backToMenu()
	{
		currentLevel = currentLevel - 1
		createMenuView()
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
	
	func clearBoardData()
	{
		allGems.removeAll()
		timeCount = 0
		gemDict.removeAll()
	}
	
	//sets the view up for the next level
	func gotoNextLevel()
	{
		resetMyView()
		clearBoardData()
		currentLevel = currentLevel + 1
		if ( currentLevel >= Level.defaultLevels( levelHandler ).count )
		{
			currentLevel = 0
			backToMenu()
			return
		}
		gemCopy.removeAll()
		showingOverlay = false
		createGameView()
	}
	
	//returns true if the current game board is the winning board or false otherwise
	//returns false if currently showing the level overlay
	func checkWin() -> Bool
	{
		if ( showingOverlay )
		{
				return false
		}
		
		let level = Level.defaultLevels( levelHandler )[ currentLevel ]
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
        //print( "Gem size: \(gemSize)")
		
        for index in 0..<maxGems
        {
            let button = UIButton(type: UIButtonType.Custom) as UIButton
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
		let buttonImage = UIImage( named: "button" ) as UIImage?
		prevButton.setBackgroundImage( buttonImage, forState: .Normal )
		prevButton.userInteractionEnabled = true
		gemCopy.removeAll()
		showingOverlay = true
		let level = Level.defaultLevels( levelHandler )[ currentLevel ]
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
		let buttonImage = UIImage( named: "hover" ) as UIImage?
		prevButton.setBackgroundImage( buttonImage, forState: .Normal )
		prevButton.userInteractionEnabled = false
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
			let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swapLeft(_:)))
			let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swapRight(_:)))
			let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swapUp(_:)))
			let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swapDown(_:)))
			swipeLeft.direction = .Left
			swipeRight.direction = .Right
			swipeUp.direction = .Up
			swipeDown.direction = .Down
            gem.gemButton.addTarget( self, action: #selector( self.clickGem) , forControlEvents: .TouchUpInside)
			gem.gemButton.addGestureRecognizer(swipeLeft)
			gem.gemButton.addGestureRecognizer(swipeRight)
			gem.gemButton.addGestureRecognizer(swipeUp)
			gem.gemButton.addGestureRecognizer(swipeDown)
        }
    }

    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//swaps the colors of the gems with the indexes provided
	func swapGems( firstIndex: Int, secondIndex: Int )
	{
		if showingOverlay
		{
				return
		}
		let saveSprite = allGems[ firstIndex ].currentSprite
		allGems[ firstIndex ].updateSprite( allGems[ secondIndex ].currentSprite )
		allGems[ secondIndex ].updateSprite( saveSprite )
		
		//if the board matches the winning board then the level is complete
		if checkWin()
		{
			endLevelWon()
		}
	}
	
	func swapLeft(gestureRecognizer: UISwipeGestureRecognizer)
	{
		let button = gestureRecognizer.view as! UIButton
		let index = gemDict[ button]
		let level = Level.defaultLevels( levelHandler )[ currentLevel ]
		let size = level.totalRows
		if index! % size == 0
		{
			print( "Could not swap edge")
			return
		}
		swapGems( index!, secondIndex: index! - 1 )
	}
	
	func swapRight(gestureRecognizer: UISwipeGestureRecognizer)
	{
		let button = gestureRecognizer.view as! UIButton
		let index = gemDict[ button]
		let level = Level.defaultLevels( levelHandler )[ currentLevel ]
		let size = level.totalRows
		let second = index! + 1
		if index! % size == size - 1
		{
			print( "Could not swap edge")
			return
		}
		swapGems( index!, secondIndex: second )
	}
	
	func swapUp(gestureRecognizer: UISwipeGestureRecognizer)
	{
		let button = gestureRecognizer.view as! UIButton
		let index = gemDict[ button]
		let level = Level.defaultLevels( levelHandler )[ currentLevel ]
		let size = level.totalRows
		let second = index! - size
		if second < 0
		{
			print( "Could not swap edge")
			return
		}
		swapGems( index!, secondIndex: second )
	}
	
	func swapDown(gestureRecognizer: UISwipeGestureRecognizer)
	{
		let button = gestureRecognizer.view as! UIButton
		let index = gemDict[ button]
		let level = Level.defaultLevels( levelHandler )[ currentLevel ]
		let size = level.totalRows
		let second = index! + size
		if  second >= size * size
		{
			print( "Could not swap edge")
			return
		}
		swapGems( index!, secondIndex: second)
	}
	

	//fires when a gem is clicked
    func clickGem( sender: AnyObject)
    {
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
		timerView.userInteractionEnabled = false
		showingOverlay = true
		showGemOverlay()
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "winstone")!)
		let newImage = UIImage( named: "button" ) as UIImage?
		nextButton.setBackgroundImage( newImage, forState: .Normal )
		nextButton.userInteractionEnabled = true
	}
	
	//reads the level data from the levels file and puts it into the level handler
	func readLevels()
	{
		if let filepath = NSBundle.mainBundle().pathForResource("Levels", ofType: "txt")
		{
			do
			{
				let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
				//print(contents)
				levelHandler = LevelHandler( levels: Process( input: contents ).getLevels() )
			}
			catch
			{
				// contents could not be loaded
				print( "Could not load contents")
			}
		}
		else
		{
			print( "File not found" )
		}
	}
	
	func readCredits() -> Array<Dictionary<String,String>>
	{
		var toReturn = [[String: String]]()
		if let filepath = NSBundle.mainBundle().pathForResource("Credits", ofType: "txt")
		{
			do
			{
				let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
				//print(contents)
				//levelHandler = LevelHandler( levels: Process( input: contents ).getLevels() )
				toReturn = Process( input: contents ).getObjects()
			}
			catch
			{
				// contents could not be loaded
				print( "Could not load contents")
			}
		}
		else
		{
			print( "File not found" )
		}
		return toReturn
	}
	
}

