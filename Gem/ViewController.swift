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
//(SCRAP)rewrite code to allow for non-square boards
//(DONE)maybe have gems centered in view
//(DONE)levels should be centered as well in the all levels view
//(DONE)maybe have back buttons with actual back sign in levels/credits view
//(DONE)change link for myself in credits file, github site
//(DONE)try to make the font size for the credits bigger
//(DONE)animations for gems being pressed
//(DONE)different app icon then default
//(SCRAP)random gems embedded into square tiles on menu
//(DONE)figure out way to play ogg files or convert them
//(DONE)hide the tutorial if going past the first level
//(DONE)should advance the tutorial past 0 when the timer button first pressed
//(DONE)better playing of sound effects, use an array of audioplayers so that they can play at same time
//(DONE)bug with first gem being the final one for the level
//(DONE)delay score added to title by 1sec,maybe have winning sound played along with score being shown
//(DONE)bug with going to another view when winning animation going
//(DONE)change credits so that two buttons per row instead of one
//(DONE)add music/sound effect credits to credits file
//(DONE)views
//      (DONE)menu
//      (DONE)all levels view
//      (DONE)credits view, with artists who created artwork
//		(DONE)help/info view. Maybe have a tutorial?
//(DONE)some kind of indicator to the player that they have won the level
//		(DONE)sound effect for winning level when last gem is done
//		(DONE)show score and end time on a scroll after last animation
//		(DONE)problem with last gem, need to hide after animation done
//		(DONE)+1 sound effect
//		(DONE)solitaire, make all the gems shrink to nothing one at a time
//		(DONE)convert the gems into coins when they have scaled to 0
//
//++++++++++++++++++++
//BEFORE RELEASE
//++++++++++++++++++++
//maybe update the app icon so that it has a different color background then black
//only change the background on the buttons to enabled when the winning animation is over
//	possible: get rid of showingWin and just disable all the buttons until after animation is over
//mute button for muting the music
//	just pause/play the queueplayer when pressed
//should wrap around to first song in playlist when done
//	see bookmarks, have stack overflow answer
//randomize the song listings
//add animations for other buttons, i.e menuButtons...
//add a few more levels
//save progress of levels beaten/times/number of moves/number of color changes
//	also save mute/unmute status
//	see bookmarks, have tutorial from site(NOT StackOverflow)
//++++++++++++++++++++++++++++++++++++
//
//==================
//future ideas
//==================
//(*)level editor, can save levels to own device or share with others via Gem Server
//(*)level editor view, would need to get size of board from user somehow(maybe allow dynamic resizing?)
//(*)rating system for each created/default level, posts to Gem Server. Allow rating on score screen
//(*)search created levels by author,title...
//change arrows on prev/next buttons to actual images?
//	also maybe have enabled arrow images for when the buttons are actually clickable
//hint animations for gems that are not winning color
//if level button size gets below certain amount put multiple pages on all levels view
//longer swipes should do multiple swaps of gems if possible
//	see bookmarks, have stack overflow answer that could work here
//add level data to game board, i.e level title(DONE), creator name, your best score...
//	maybe just for player created levels
//	maybe show up on win screen for the level?
//add level info preview at bottom of level view
//powerup system
//	examples: change all gems to certain color
//put levels into level packs, i.e folders with names
//	have level pack named ipad that has larger boards
//(?)random glint animations for gems
//====================================================


import UIKit
import AVFoundation

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
	
	//a button that shows the tutorial text
	var tutorView: UIButton!
	
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
	
	//if currently showing the tutorial then this is true
	var showingTutorial = false
	
	//holds the audio player for the music
	var musicPlayer: AVQueuePlayer!
	
	//holds the audio player for the sound effects
	var effectPlayers = [AVPlayer]()
	
	//timer that delays for the winningAnimation so that no bugs with overlapping animations
	var delayWinTimer : NSTimer!
	
	//timer that delays for the score to be shown until after the last coin sound
	var delayScoreTimer : NSTimer!
	
	//true if the win animation is being shown or false otherwise
	var showingWin = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
		readLevels()
		playMusic()
		createMenuView()
    }
	
	//adds a sound effect to the queue, creating player if it does not exist
	func playSound( soundName: String, fileType: String)
	{
		let urlPath = NSBundle.mainBundle().pathForResource( soundName, ofType: fileType )
		let fileURL = NSURL(fileURLWithPath:urlPath!)
		let player = AVPlayer( playerItem: AVPlayerItem(URL:fileURL) )
		player.play()
		effectPlayers.append( player )
	}
	
	//plays the background music in a loop
	func playMusic()
	{
		musicPlayer = AVQueuePlayer( items: Sounds.getMusic() )
		musicPlayer.play()
	}
	
	//shows the score dialog when called
	func showWinScore()
	{
		hideTutorial()
		let button = createDialog()
		button.userInteractionEnabled = false
		let time = String(timeCount)//convertTimerTime( timeCount )
		//let score = String( getScore() )
		button.setTitle( "Time:\t\(time)" , forState: .Normal )
		NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.addScoreToWinDialog), userInfo: button, repeats: false)
	}
	
	//function called after delay to add score to win dialog
	func addScoreToWinDialog( timerObj : NSTimer )
	{
		let button = timerObj.userInfo as! UIButton
		let score = String( getScore() )
		button.setTitle( button.currentTitle! + "\nScore:\t\(score)", forState: .Normal )
		playGemSound( true )
		showingWin = false
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
		
		playButton.addTarget( self, action: #selector( self.gotoNextLevel) , forControlEvents: .TouchUpInside)
		levelButton.addTarget( self, action: #selector( self.gotoLevelsView) , forControlEvents: .TouchUpInside)
		credButton.addTarget( self, action: #selector( self.gotoCreditsView) , forControlEvents: .TouchUpInside)
		infoButton.addTarget( self, action: #selector( self.gotoHelpView) , forControlEvents: .TouchUpInside)
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkstone")!)
	}
	
	//for starting animation loop on gems
	func winningAnimation()
	{
		shrinkGem( 0 )
	}
	
	//function that adds animation to each gem making it shrink and then display as coin
	func shrinkGem( index: Int )
	{
		if ( index >= allGems.count )
		{
			return
		}
		
		//self.allGems[ index ].gemButton.transform = CGAffineTransformIdentity
		let titleImage = UIImage( named: "coin" ) as UIImage?
		
		UIView.animateWithDuration(1.0 ,
		                           animations:
			{
				self.allGems[ index ].gemButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
			},
		                           completion:
			{
				finish in
				UIView.animateWithDuration(1.0)
				{
					self.allGems[ index ].gemButton.setBackgroundImage( titleImage, forState: .Normal )
					self.shrinkGem( index + 1 )
					self.animateGemEnd( index )
				}

			}
		)
	}
	
	//shows the score dialog if the index provided refers to last gem
	func showScoreIfLast( index: Int )
	{
		if ( index == allGems.count - 1 )
		{
			showWinScore()
		}
	}
	
	//plays the coin sound effect if not the last gem, or the win sound effect if is
	func playGemSound( isLast : Bool )
	{
		if ( isLast )
		{
			self.playSound( Sounds.winSound().name, fileType: Sounds.winSound().type )
		}
		else
		{
			self.playSound( Sounds.coinSound().name, fileType: Sounds.coinSound().type )
		}
	}
	
	//function to be called when the gem is done shrinking
	func animateGemEnd( index : Int )
	{
		UIView.animateWithDuration(1.0 ,
		                           animations:
			{
				self.allGems[ index ].gemButton.transform = CGAffineTransformIdentity
			},
		                           completion:
			{
				finish in
				UIView.animateWithDuration(1.0)
				{
					self.playGemSound( false )
					self.allGems[ index ].gemButton.hidden = true
					self.showScoreIfLast( index )
				}
				
			}
		)
	}
	
	//returns the score for the current level
	func getScore() -> Int
	{
		let level = Level.defaultLevels( levelHandler)[ currentLevel ]
		return level.totalCols * level.totalRows
	}
	
	//creates the view for the credits
	func createCreditsView()
	{
		let screenWidth = UIScreen.mainScreen().bounds.width
		let titleWidth = Int( ceil(screenWidth * 0.5) )
		let padding = Int( ceil( UIScreen.mainScreen().bounds.height * 0.04 ) )
		let widthPadding = Int( ceil( UIScreen.mainScreen().bounds.width * 0.04 ) )
		let centerX = screenWidth / 2
		let startY = Int( ceil( UIScreen.mainScreen().bounds.width * 0.33 ) )
		let defaultWidth = 128
		let defaultHeight = 32
		let roomTitle = UIButton(type: UIButtonType.Custom) as UIButton
		let titleImage = UIImage( named: "title" ) as UIImage?
		let backButton = UIButton(type: UIButtonType.Custom) as UIButton
		roomTitle.setBackgroundImage( titleImage, forState: .Normal )
		roomTitle.setTitle( "Credits" , forState: .Normal )
		roomTitle.setTitleColor( UIColor.blackColor(), forState: .Normal)
		roomTitle.frame = CGRectMake( CGFloat( centerX - CGFloat( titleWidth / 2 ) ), CGFloat( startY ), CGFloat( titleWidth ), CGFloat(defaultHeight ))
		roomTitle.addTarget( self, action: #selector( self.backToMenu ) , forControlEvents: .TouchUpInside)
		
		let buttonImage = UIImage( named: "button" ) as UIImage?
		backButton.setBackgroundImage( buttonImage, forState: .Normal )
		backButton.setTitle( "<-" , forState: .Normal )
		backButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		let backWidthCenter = ( defaultHeight / 2 )
		backButton.frame = CGRectMake( CGFloat( centerX - CGFloat( titleWidth / 2 ) - CGFloat( padding + backWidthCenter ) ), CGFloat( startY ), CGFloat( defaultHeight ), CGFloat(defaultHeight ))
		backButton.addTarget( self, action: #selector( self.backToMenu ) , forControlEvents: .TouchUpInside)
		self.view.addSubview(backButton)
		self.view.addSubview(roomTitle)

		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkstone")!)
		
		let allCredits = readCredits()
		var index = 0
		for creditObj in allCredits
		{
			index = index + 1
			let indexByZero = index - 1
			let button = UIButton(type: UIButtonType.Custom) as UIButton
			
			let myHeight = CGFloat( startY + ( ( ( index + 1 ) / 2 ) * ( padding  + defaultHeight ) ) )
			if indexByZero % 2 == 0
			{
				//start of a new row
				button.frame = CGRectMake( CGFloat( centerX - CGFloat( defaultWidth + widthPadding ) ), CGFloat( myHeight ), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
			}
			else
			{
				button.frame = CGRectMake( CGFloat( centerX + CGFloat(widthPadding) ), CGFloat(myHeight), CGFloat( defaultWidth ), CGFloat(defaultHeight ))
			}
			
			let author = creditObj[ "author"]!
			let title = creditObj[ "title"]!
			button.setTitle( "\(title) - \(author)" , forState: .Normal )
			button.setTitleColor( UIColor.blackColor(), forState: .Normal)
			button.setBackgroundImage( titleImage, forState: .Normal )
			button.titleLabel!.font = button.titleLabel!.font.fontWithSize( 10 )
			button.tag = index - 1
			button.addTarget( self, action: #selector( self.clickCreditsTag(_:)) , forControlEvents: .TouchUpInside)
			self.view.addSubview(button)
		}
	}
	
	//creates a dialog box, used for tutorial text display
	func createDialog() -> UIButton
	{
		let buttonImage = UIImage( named: "title" ) as UIImage?
		let toReturn = UIButton(type: UIButtonType.Custom) as UIButton
		let screenWidth = UIScreen.mainScreen().bounds.width
		let screenHeight = UIScreen.mainScreen().bounds.height
		toReturn.setBackgroundImage( buttonImage, forState: .Normal )
		toReturn.tag = 0
		toReturn.titleLabel?.numberOfLines = 0
		toReturn.contentEdgeInsets = UIEdgeInsetsMake(12,12,12,12)
		toReturn.setTitleColor( .blackColor(), forState: .Normal)
		let myHeight = screenHeight * 0.12
		toReturn.frame = CGRectMake( 0, CGFloat( screenHeight * 0.85 ), CGFloat( screenWidth ), CGFloat( myHeight ))
		self.view.addSubview( toReturn )
		return toReturn
	}
	
	//creates the dialog box at the bottom of the screen for the tutorial text
	func createTutorialView()
	{
		tutorView = createDialog()
		tutorView.tag = -1
		tutorView.addTarget( self, action: #selector( self.clickTutorialDialog(_:)) , forControlEvents: .TouchUpInside)
		clickTutorialDialog( tutorView )
	}
	
	func clickTutorialDialog( sender: AnyObject )
	{
		if ( tutorView == nil )
		{
				return
		}
		
		//advance the tag along and change the text to the new tag
		tutorView.tag += 1
		let newText = getTutorialText( tutorView.tag )
		if newText == ""
		{
			showingTutorial = false
			//delete the tutorial view
			hideTutorial()
		}
		else
		{
			tutorView.setTitle( newText, forState: .Normal )
		}
	}
	
	func hideTutorial()
	{
		if ( tutorView == nil )
		{
			return
		}
		tutorView.setTitle( "", forState: .Normal )
		tutorView.userInteractionEnabled = false
		tutorView.hidden = true
	}
	
	//returns the help text associated with the index given
	func getTutorialText( index: Int ) -> String
	{
		var myTutorials = [String]()
		myTutorials.append( "Try to get the gems to match the pattern given. Tap the timer to start. (Continue)" )
		myTutorials.append( "Swipe the gems in the direction you want to swap them. Tap them to change their color. (Continue)" )
		myTutorials.append( "If you need to look at the pattern again, then tap the timer. (Done)" )
		if index < 0 || index >= myTutorials.count
		{
			return ""
		}
		return myTutorials[ index ]
	}

	//handler to goto the levels view
	func gotoLevelsView()
	{
		if ( showingWin )
		{
			return
		}
		currentLevel = 0
		resetMyView()
		createLevelsView()
	}
	
	//handler to goto the credits view
	func gotoCreditsView()
	{
		currentLevel = 0
		resetMyView()
		createCreditsView()
	}
	
	//creates the game view
	func createGameView()
	{
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "stone")!)
		let level = Level.defaultLevels( levelHandler)[ currentLevel ]
		createGUI()
		createGems( level.totalRows * level.totalRows )
		addGemPressEvents()
		showGemOverlay()
		timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
		if ( showingTutorial )
		{
				createTutorialView()
		}
	}
	
	//creates the levels view
	func createLevelsView()
	{
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkstone")!)
		var index = -1
		let totalLevels = Level.defaultLevels(levelHandler).count
		let perRow = ceil( sqrt( Double(totalLevels) ) )
		let screenSize: CGRect = UIScreen.mainScreen().bounds
		let screenWidth = screenSize.width * 0.8
		let screenHeight = screenSize.height * 0.8
		let startY = floor( Double( screenSize.height * 0.2 ))
		let totalSize = floor( screenWidth + screenHeight )
		let squareSize = Int(totalSize) / Int( ( perRow ) * 4 )
		let backImage = UIImage( named: "button" ) as UIImage?
		let titleImage = UIImage( named: "title" ) as UIImage?
		let defaultHeight = 32
		let paddingHeight = screenHeight * 0.02
		
		let centerX = UIScreen.mainScreen().bounds.width / 2
		let titleWidth = 128
		let buttonImage = UIImage( named: "button" ) as UIImage?
		let backButton = UIButton(type: UIButtonType.Custom) as UIButton
		backButton.setBackgroundImage( buttonImage, forState: .Normal )
		backButton.setTitle( "<-" , forState: .Normal )
		backButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
		let backWidthCenter = ( defaultHeight / 2 )
		let padding = Int( ceil( UIScreen.mainScreen().bounds.height * 0.04 ) )
		backButton.frame = CGRectMake( CGFloat( centerX - CGFloat( titleWidth / 2 ) - CGFloat( padding + backWidthCenter ) ), CGFloat( startY - 48 ), CGFloat( defaultHeight ), CGFloat(defaultHeight ))
		backButton.addTarget( self, action: #selector( self.backToMenu ) , forControlEvents: .TouchUpInside)
		self.view.addSubview(backButton)
		
		let roomTitle = UIButton(type: UIButtonType.Custom) as UIButton
		roomTitle.frame = CGRectMake( CGFloat( (screenSize.width / 2) - CGFloat( titleWidth / 2 ) ), CGFloat( startY -  48 ), CGFloat( titleWidth ), CGFloat(defaultHeight ))
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
			//let x = Double( ( CGFloat(column)  * (CGFloat( squareSize ) + paddingWidth ) )  ) + startX
			let x = centerBoxPosition(Int(perRow), index: column, boxWidth: squareSize )
			let y = Double( ( CGFloat(row)  * (CGFloat( squareSize ) + paddingHeight ) )  ) + startY
			levelButton.frame = CGRectMake( CGFloat( x ), CGFloat( y ), CGFloat( squareSize ), CGFloat(squareSize))
			levelButton.setTitleColor( UIColor.blackColor(), forState: .Normal)
			levelButton.setTitle( "\(index + 1)" , forState: .Normal )
			levelButton.setBackgroundImage( backImage, forState: .Normal )
			self.view.addSubview( levelButton )
			levelButton.addTarget( self, action: #selector( self.clickLevelButton(_:)) , forControlEvents: .TouchUpInside)
		}
	}
	
	//when a credits button is clicked on in credits view, show the web page link associated with that button
	func clickCreditsTag( sender: AnyObject )
	{
		let allCredits = readCredits()
		if let myTag = sender.tag
		{
			let url = allCredits[ myTag ][ "link"]!
			UIApplication.sharedApplication().openURL(NSURL(string: url)!)
		}
	}
	
	//when a level button is clicked on in the levels view, goto that specific level
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
		levelTitle.addTarget( self, action: #selector( self.gotoLevelsView) , forControlEvents: .TouchUpInside)
		levelTitle.setTitleColor( UIColor.blackColor(), forState: .Normal)
		self.view.addSubview( levelTitle )
	}
	
	//go back to the menu
	func backToMenu()
	{
		if ( showingWin )
		{
			return
		}
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
			if ( showingTutorial && tutorView != nil && tutorView.tag == 0 )
			{
					clickTutorialDialog( tutorView )
			}
		}
		else
		{
			showGemOverlay()
		}
	}
	
	//reset everything that is associated with the current game board
	func clearBoardData()
	{
		allGems.removeAll()
		timeCount = 0
		gemDict.removeAll()
		effectPlayers.removeAll()
	}
	
	//sets the view up for the next level
	func gotoNextLevel()
	{
		if ( showingWin )
		{
			return
		}
		resetMyView()
		clearBoardData()
		currentLevel = currentLevel + 1
		//don't show the tutorial after the first level
		if ( currentLevel > 0 )
		{
				showingTutorial = false
		}
		
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
	
	func gotoHelpView()
	{
		if ( showingWin )
		{
			return
		}
		showingTutorial = true
		currentLevel = -1
		gotoNextLevel()
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
        //let startX = floor( Double( screenSize.width * 0.15 ) )
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
            //let x = Double( ( column  * gemSize )  ) + startX
			let x = centerBoxPosition( Int(gemsPerRow), index: column, boxWidth: gemSize )
            let y = Double( ( row * gemSize )  ) + startY
            button.frame = CGRectMake( CGFloat( x ), CGFloat( y ), CGFloat( gemSize ), CGFloat(gemSize))
            self.view.addSubview(button)
			gemDict[ button ] = index
            allGems.append( Gem( gemButton: button, currentSprite: 0).randomImage() )
        }
    }
	
	//returns the position of the box so that it is centered in the view based on its position in the row
	func centerBoxPosition( boxesPerRow: Int, index: Int, boxWidth: Int ) -> Int
	{
		let screenSize: CGRect = UIScreen.mainScreen().bounds
		let screenWidth = Int( floor( screenSize.width * 0.5 ) )
		var toReturn = 0
		let invert = ( boxesPerRow - 1 ) - index
		let dist = invert - ( boxesPerRow / 2 )
		let totalOffset = dist * boxWidth
		if ( boxesPerRow % 2 == 0 )
		{
			toReturn = screenWidth - totalOffset - boxWidth
		}
		else
		{
			toReturn = screenWidth - totalOffset - (boxWidth / 2)
		}
		
		return toReturn
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
		
		UIView.animateWithDuration(0.3 ,
			animations:
			{
				self.allGems[ firstIndex ].gemButton.transform = CGAffineTransformMakeScale(0.9, 0.9)
				self.allGems[ secondIndex].gemButton.transform = CGAffineTransformMakeScale(0.9, 0.9)
			},
			completion:
			{
				finish in
				UIView.animateWithDuration(0.3)
				{
					self.allGems[ firstIndex ].gemButton.transform = CGAffineTransformIdentity
					self.allGems[secondIndex].gemButton.transform = CGAffineTransformIdentity
				}
			}
		)
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
		
		UIView.animateWithDuration(0.25, animations:{
			(sender as! UIButton).transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
			}
			
			,completion:
			{
				finish in
				UIView.animateWithDuration(0.0)
				{
					if finish
					{
						(sender as! UIButton).transform = CGAffineTransformIdentity
					}
				}
			}
		)
		
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
		showingWin = true
		showingOverlay = true
		showGemOverlay()
		self.view.backgroundColor = UIColor(patternImage: UIImage(named: "winstone")!)
		let newImage = UIImage( named: "button" ) as UIImage?
		nextButton.setBackgroundImage( newImage, forState: .Normal )
		nextButton.userInteractionEnabled = true
		playSound( Sounds.winSoundBegin().name, fileType: Sounds.winSoundBegin().type )
		delayWinTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(self.winningAnimation), userInfo: nil, repeats: false)
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
	
	//reads the credits data from the credits file and returns a dictionary of it
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

