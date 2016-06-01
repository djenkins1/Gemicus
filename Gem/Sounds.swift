

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
	
	static func getMusic() -> Array<AVPlayerItem>
	{
		var toReturn = [AVPlayerItem]()
		//need to figure out how to play ogg files
		for sound in musicList()
		{
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
}