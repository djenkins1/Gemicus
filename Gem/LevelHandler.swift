//
//  LevelHandler.swift
//  Gemicus
//
//  Created by Dilan Jenkins on 5/26/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation

class LevelHandler
{
	var levels = [Level]()
	
	private(set) var packName = ""
	
	init( levels : Array<Level>, name : String = "" )
	{
		self.levels = levels
		self.packName = name
	}
	
	//for any level in the levels array, if said level does not have the rows and cols specified then it is dropped
	func stripLevelsNotOfSize( rows : Int, cols : Int )
	{
		var newLevels = [Level]()
		for level in levels
		{
			if level.totalCols == cols && level.totalRows == rows
			{
				newLevels.append( level )
			}
		}
		
		levels.removeAll()
		levels.appendContentsOf( newLevels )
		generateColors()
	}
	
	//for every level in levels array, put through generateLevel function
	func generateColors()
	{
		for level in levels
		{
			generateLevel( level )
		}
	}
	
	//for each color, picks another color to represent original and changes the color accordingly for gems of said color
	func generateLevel( level : Level )
	{
		//for each int representing a color, randomize that so that it is another/same color
		var oldColors = [Int]()
		let totalSize = GemColor().totalColors()
		for i in 0 ..< totalSize
		{
			oldColors.append( i )
		}
		
		var newColors = [Int]()
		for _ in 0 ..< totalSize
		{
			let index = Int( arc4random_uniform( UInt32( oldColors.count ) ) )
			newColors.append( oldColors.removeAtIndex( index ) )
		}
		
		for i in 0 ..< level.levelData.count
		{
			let oldValue = level.levelData[ i ]
			level.levelData[ i ] = newColors[ oldValue ]
		}
	}
}
