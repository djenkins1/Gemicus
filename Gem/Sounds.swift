

import Foundation
import AVFoundation

class Sounds
{	
	var name: String
	var type: String
	
	init( name: String, type: String )
	{
		self.name = name
		self.type = type
	}
	
	static func getMusic( isRandom : Bool ) -> Array<AVPlayerItem>
	{
		return isRandom ? getMusicFromList( randomMusicList() ) : getMusicFromList( musicList() )
	}
	
	static func getMusicFromList( musicList : [Sounds] ) -> Array<AVPlayerItem>
	{
		var toReturn = [AVPlayerItem]()
		//need to figure out how to play ogg files
		for sound in musicList
		{
			print( "Sound: \(sound.name) = \(sound.type)" )
			let urlPath = NSBundle.mainBundle().pathForResource( sound.name , ofType: sound.type )
			let fileURL = NSURL(fileURLWithPath:urlPath!)
			toReturn.append( AVPlayerItem(URL:fileURL) )
		}
		
		return toReturn
	}
	
	static func musicList() -> Array<Sounds>
	{
		var toReturn = [Sounds]()
		toReturn.append( Sounds( name: "DesertOfDreams" , type: "mp3" ) )
		toReturn.append( Sounds( name: "caravan" , type: "mp3" ) )
		toReturn.append( Sounds( name: "Egypt" , type: "mp3" ) )
		toReturn.append( Sounds( name: "Temple" , type: "mp3" ) )
		return toReturn
	}
	
	static func coinSound() -> Sounds
	{
		return Sounds( name: "PDgemWin" , type: "aif" )
	}
	
	static func winSound() -> Sounds
	{
			return Sounds( name: "PDanimateDone" , type: "aif" )
	}
	
	static func winSoundBegin() -> Sounds
	{
		return Sounds( name: "PDwinBegin" , type: "aif" )
	}
	
	static func randomMusicList() -> [Sounds]
	{
		var first = musicList()
		var toReturn = [Sounds]()
		while first.count > 0
		{
			let indexToTake = Int(arc4random_uniform( UInt32(first.count) ))
			toReturn.append( first.removeAtIndex( indexToTake ) )
		}
		
		return toReturn
	}
	
	func getItem() -> AVPlayerItem
	{
		let urlPath = NSBundle.mainBundle().pathForResource( self.name , ofType: self.type )
		let fileURL = NSURL(fileURLWithPath:urlPath!)
		return AVPlayerItem(URL:fileURL)
	}
}