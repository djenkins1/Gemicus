//
//  Level.swift
//  Gem
//
//  Created by Dilan Jenkins on 5/24/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//
import UIKit
import Foundation

class Level
{
    var totalRows = 0
    var levelAuthor = ""
    var levelName = ""
    var levelData = [Int]()
	var totalCols = 0

	static func defaultLevels( handler : LevelHandler ) -> Array<Level>
    {
		return handler.levels
    }

	init( rows: Int, cols: Int, author: String, name: String, data: Array<Int> )
    {
        self.totalRows = rows
		self.totalCols = cols
        self.levelAuthor = author
        self.levelName = name
        self.levelData = data
	}
}
