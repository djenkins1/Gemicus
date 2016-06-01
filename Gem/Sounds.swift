

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
		let strDict = [ "DesertOfDreams" : "mp3" , "caravan" : "mp3", "Egypt" : "mp3" , "Temple" : "mp3" ]
		for (key,value) in strDict
		{
			let urlPath = NSBundle.mainBundle().pathForResource(key, ofType: value )
			let fileURL = NSURL(fileURLWithPath:urlPath!)
			toReturn.append( AVPlayerItem(URL:fileURL) )
		}
		
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
}