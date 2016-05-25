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

    static func defaultLevels() -> Array<Level>
    {
        let gem = GemColor()
        var toReturn = [Level]()
        toReturn.append( Level( rows: 3 , author: "DJ" , name: "Level 1", data: [ gem.RED , gem.RED, gem.RED , gem.RED, gem.WHITE , gem.RED, gem.RED, gem.RED, gem.RED ] ) )
        toReturn.append( Level( rows: 4 , author: "DJ" , name: "Level 2", data: [ gem.WHITE, gem.WHITE, gem.WHITE, gem.WHITE, gem.WHITE, gem.RED, gem.RED, gem.WHITE, gem.WHITE, gem.RED, gem.RED, gem.WHITE, gem.WHITE, gem.WHITE, gem.WHITE, gem.WHITE] ) )
        return toReturn
    }

    init( rows: Int, author: String, name: String, data: Array<Int> )
    {
        self.totalRows = rows
        self.levelAuthor = author
        self.levelName = name
        self.levelData = data
    }
}
