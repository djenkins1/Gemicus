//
//  GemColor.swift
//  Gem
//
//  Created by Dilan Jenkins on 5/24/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation
class GemColor
{
    let PURPLE = 0
    let GREEN = 1
    let RED = 2
    let BLUE = 3
    let YELLOW = 4
    let WHITE = 5
	let ORANGE = 6
	let BLACK = 7
	
	func getColorFromString( input : String ) -> Int
	{
		var colorMap = [ String : Int ]()
		let safeInput = input.lowercaseString
		colorMap[ "purple" ] = PURPLE
		colorMap[ "red" ] = RED
		colorMap[ "green"] = GREEN
		colorMap[ "blue"] = BLUE
		colorMap[ "white"] = WHITE
		colorMap[ "yellow"] = YELLOW
		colorMap[ "orange"] = ORANGE
		colorMap[ "black"] = BLACK
		if let toReturn = colorMap[ safeInput ]
		{
			return toReturn
		}
		return -1
	}
	
	func totalColors() -> Int
	{
		return BLACK + 1
	}
}
