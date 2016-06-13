//
//  TimePack.swift
//  Gemicus
//
//  Created by Dilan Jenkins on 6/12/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//

import Foundation

class TimePack
{
	let pack2x2 = "2x2"
	let pack3x3 = "3x3"
	let pack4x4 = "4x4"
	let packAll = "All"
	
	func listPacks() -> Array<String>
	{
		return [ pack2x2, pack3x3, pack4x4, packAll ]
	}
	
	//changes the levels in the levelHandler based on the pack chosen
	//returns true if the levels were changed in the levelHandler or false otherwise
	func processLevelHandler( handler : LevelHandler, packCode : String ) -> Bool
	{
		switch( packCode )
		{
		case pack2x2:
			handler.withPackName( packCode ).stripLevelsNotOfSize( 2, cols: 2 ).shuffleLevels().trimLevelsTo()
			return true
		case pack3x3:
			handler.withPackName( packCode ).stripLevelsNotOfSize( 3, cols: 3 ).shuffleLevels().trimLevelsTo()
			return true
		case pack4x4:
			handler.withPackName( packCode ).stripLevelsNotOfSize( 4, cols: 4 ).shuffleLevels().trimLevelsTo()
			return true
		case packAll:
			handler.withPackName( packCode ).shuffleLevels().trimLevelsTo()
			return true
		default:
			print( "Hit default on time pack with key \(packCode)" )
		}
		
		return false
	}
}