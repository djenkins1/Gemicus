//
//  LevelSave.swift
//  Gemicus
//
//  Created by Dilan Jenkins on 6/5/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation

class LevelSave
{
	private var levelID : Int = -1
	
	private var bestTime : Int = -1
	
	private var bestScore : Int = -1
	
	init( id : Int )
	{
			self.levelID = id
	}
	
	//overwrites the current time with the time provided and returns self
	func setBestTime( time : Int ) -> LevelSave
	{
		self.bestTime = time
		return self
	}
	
	//overwrites the current score with the score provided and returns self
	func setBestScore( score : Int ) -> LevelSave
	{
		self.bestScore = score
		return self
	}
	
	//sets the score to the score provided if it is better then the current bestScore, returns self
	func setScoreIfBetter( score : Int ) -> LevelSave
	{
		if ( isScoreBetter( score )  )
		{
			setBestScore( score )
		}
		return self
	}
	
	//sets the time to the time provided if it is less than the current bestTime, returns self
	func setTimeIfBetter( time : Int ) -> LevelSave
	{
		if ( isTimeBetter( time ) )
		{
				setBestTime( time )
		}
		return self
	}
	
	//returns true if the score provided is better then the current best score or false otherwise
	func isScoreBetter( score: Int ) -> Bool
	{
		return ( bestScore == -1 || score > bestScore )
	}
	
	//returns true if the time provided is better then the current best time or false otherwise
	func isTimeBetter( time : Int ) -> Bool
	{
		return ( bestTime == -1 || time < bestTime )
	}
	
	func getBestScore() -> Int
	{
		return bestScore
	}
	
	func getBestTime() -> Int
	{
		return bestTime
	}

	//converts this instance to a dictionary with key value pairs corresponding to instance variables
	func convertToObject() -> Dictionary<String,String>
	{
		var toReturn = [String : String ]()
		toReturn[ "key" ] = String(levelID)
		toReturn[ "time" ] = String( bestTime )
		toReturn[ "score" ] = String( bestScore )
		return toReturn
	}
	
	//converts a dictionary of key value pairs into a LevelSave object if possible and returns it
	//returns nil if it cannot convert said dictionary
	static func convertFromObject( obj : Dictionary<String,String> ) -> LevelSave?
	{
		if let key = obj[ "key" ]
		{
			if let time = obj[ "time" ]
			{
				if let score = obj[ "score" ]
				{
					return LevelSave( id: Int(key)! ).setBestTime( Int(time)! ).setBestScore( Int(score)! )
				}
			}
		}
		
		return nil
	}
	
	//given an array of key value pairs, returns a dictionary of LevelSaves created from converting said pairs and extracting the keys
	static func convertObjects( objDicts : Array<Dictionary<String,String>> ) -> Dictionary<Int,LevelSave>
	{
		var toReturn = [ Int : LevelSave]()
		for dict in objDicts
		{
			let save = convertFromObject( dict )!
			toReturn[ save.levelID ] = save
		}
		return toReturn
	}
}
