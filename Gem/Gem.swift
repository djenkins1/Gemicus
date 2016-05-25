//
//  Gem.swift
//  Gem
//
//  Created by Dilan Jenkins on 5/23/16.
//  Copyright © 2016 Dilan Jenkins. All rights reserved.
//
import UIKit
import Foundation

class Gem
{
    weak var gemButton: UIButton!
    var currentSprite: Int!
    let maxSprites = 5
    
    init( gemButton: UIButton, currentSprite: Int)
    {
        self.gemButton = gemButton
        self.currentSprite = currentSprite
        self.setImage()
    }
	
	//set the current sprite to a random one and change the background accordingly
    func randomImage() -> Gem
    {
        let diceRoll = Int( floor( drand48() * Double( self.maxSprites ) ) )
        self.currentSprite = diceRoll
        self.setImage()
        return self
    }
	
	//change the background image of the button to the current sprite
    func setImage() -> Gem
    {
        let newImage = UIImage( named: "jewel\(self.currentSprite)" ) as UIImage?
        self.gemButton.setBackgroundImage( newImage, forState: .Normal )
        return self
    }
	
	//change the sprite to the value provided
	func updateSprite( value : Int ) -> Gem
	{
		self.currentSprite = value
		self.setImage()
		return self
	}
	
    //Reset the current image to the first jewel sprite
    func resetImage() -> Gem
    {
        self.currentSprite = 0
        let image = UIImage(named: "jewel0") as UIImage?
        self.gemButton.setBackgroundImage( image, forState: .Normal)
        return self
    }
    
    //increment the current image to the next jewel sprite
    func changeImage() -> Gem
    {
        self.currentSprite = self.currentSprite + 1
        if ( self.currentSprite > self.maxSprites )
        {
            self.currentSprite = 0
        }
        
        let newImage = UIImage( named: "jewel\(self.currentSprite)" ) as UIImage?
        self.gemButton.setBackgroundImage( newImage, forState: .Normal )
        return self
    }
}