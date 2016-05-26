//
//  Process.swift
//  Gemicus
//
//  Created by Dilan Jenkins on 5/25/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation

class Process
{
	var input : String
	
	init( input: String )
	{
		self.input = input
	}
	
	func getLevels() -> Array<Level>
	{
		let objects = breakObjects( input )
		/*
		for str in objects
		{
		print( "<Before>")
		print( str )
		print( "</Before>" )
		}
		*/
		return populateLevels( objects )
	}
	
	func breakObjects( myInput : String ) -> Array<String>
	{
		var toReturn = [String]()
		var currentString = ""
		for i in myInput.characters
		{
			if ( i == "#" )
			{
				toReturn.append( currentString )
				currentString = ""
			}
			else
			{
				currentString.append( i )
			}
		}
		return toReturn
	}
	
	func trimString( toTrim : String ) -> String
	{
		return toTrim.stringByTrimmingCharactersInSet( NSCharacterSet.whitespaceAndNewlineCharacterSet() )
	}
	
	func populateLevels( objects : Array<String> ) -> Array<Level>
	{
		var toReturn = [Level]()
		for objStr in objects
		{
			var newString = objStr.stringByReplacingOccurrencesOfString("\n", withString: " ")
			newString = newString.stringByReplacingOccurrencesOfString("\t", withString: " ")
			let tokens = newString.componentsSeparatedByString(" ")
			var seperator = ""
			var currentAttr = ""
			var currentValue = ""
			var objDict = [ String : String ]()
			var index = -1
			for token in tokens
			{
				index = index + 1
				if token == ""
				{
					if ( index != tokens.count - 1 )
					{
						continue
					}
					else
					{
						objDict[ currentAttr ] = currentValue
						break
					}
				}
				
				if token[ token.startIndex ] == Character( "@" )
				{
					if ( currentAttr != "" )
					{
						objDict[ currentAttr ] = currentValue
						currentValue = ""
						seperator = ""
						currentAttr = token.substringFromIndex( token.startIndex.successor() )
					}
					else
					{
						currentAttr = token.substringFromIndex( token.startIndex.successor() )
					}
				}
				else
				{
					currentValue = currentValue + seperator + token
					seperator = " "
				}
			}
			
			var dataValues = [Int]()
			let splitData = objDict[ "data"]!.componentsSeparatedByString(" ")
			for value in splitData
			{
				let gemColor = GemColor()
				dataValues.append( gemColor.getColorFromString( value ) )
			}
			
			
			let level = Level( rows: Int( objDict["rows"]!)!, cols: Int( objDict[ "cols" ]! )!, author: objDict[ "author"]!, name: objDict[ "name" ]!, data: dataValues )
			toReturn.append( level )

			/*
			print( "<object>")
			for ( key, value) in objDict
			{
				print( "\(key)='\(value)'")
			}
			print( "</object>")
			*/
		}
		return toReturn
	}
	
	//@text marks a field, all text after that line until another @field or until # is part of that fields value
	//# marks end of object
	//remove tabs/spaces/empty lines
	
	//break the string up into each object's string based on end tags
	//for each object, break up the string into its field strings based on @text
	
	/*
	func processOn( delimiter : Character, readUntilFound : Bool ) -> Array<String>
	{
		var toReturn = [String]()
		var current = ""
		for i in input.characters
		{
			if i == delimiter
			{
				//if readUntilFound then every delimiter found creates a new string
			}
			else
			{
				if ( readUntilFound)
				{
						
				}
				else
				{
					
				}
			}
		}
		
		return toReturn
	}
	*/
}
