//
//  ScoreObject.swift
//  Gemicus
//
//  Created by Dilan Jenkins on 6/3/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation

class ScoreObject
{
	private var moveSwaps = 0
	
	private var colorSwaps = 0
	
	func totalScore() -> Int
	{
		return moveSwaps + colorSwaps
	}
	
	func incrementColorSwap()
	{
		colorSwaps += 1
	}
	
	func incrementMoveSwap()
	{
		moveSwaps += 1
	}
}