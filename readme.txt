  _____                                  
   (, /   )                /)              
    _/__ / _  __  _/_ _   // ________   _  
    /     (_(_/ (_(__(_(_(/_(_)(_) / (_/_)_
 ) /                                       
(_/                                        



Thanks for downloading Pantaloons!

Pantaloons is a Panoramic Video Player written in Flash. It is based off of the popular JWPlayer, which can be found
here: http://www.longtailvideo.com/players/jw-flv-player/.

--- Features ---

Although we'd like to support all the features of JWPlayer, Pantaloons is a work in progress. Presently we support the 
following:

- playback of all normal movies supported by jwplayer (.mp4, etc)
- playback of panoramic videos (.vwm)

In the beta branch, we support: 
- RTMP on demand and RTMP live for non-panoramic videos
- playback on demand and RTMP live for panoramic videos

--- Building the Player ---

It's easiest to build the player with flashbuilder. If you don't have flashBuilder, you can try to build the player with Ant, and follow 
the details on the JWPlayer site: http://www.longtailvideo.com/support/open-video-ads/ova-for-jw-player-5/13164/how-to-build-the-release. However, 
you may need to modify the build script.

To build the player in Flash Builder:

1. Open Flash Builder
2. Select 'New Actionscript Project'
3. Under 'default location', select the Pantaloons folder
4. Click Next
5. Under Main Application File, select 'JWPanoPlayer.as'
6. Click 'Finish'
7. You can now use project normally.

--- Configuring the Player ---

Most of the configuration can be done by looking at JWPlayer guide: http://www.longtailvideo.com/support/jw-player-setup-wizard.
For panoramic videos with the .vwm extension, the player should be able to detect the correct projection automatically - however, you
will need to add a flashvar - provider: 'video' because .vwm is not a recognized video format. For .mp4 or livestream files, you will 
need to make an xml playlist and specify the projection in the xml.

For example:
  <rss version="2.0" xmlns:jwplayer="http://developer.longtailvideo.com/">
  <channel>
  <title>EyeSee360</title> 
  <item>
  <title>Live Stream</title> 
  <jwplayer:streamer>rtmp://127.0.0.1/live</jwplayer:streamer> 
  <jwplayer:provider>rtmp</jwplayer:provider> 
  <jwplayer:file>livestream</jwplayer:file> 
  <jwplayer:projection>cylindrical</jwplayer:projection> 
  <jwplayer:tiltMin>-30</jwplayer:tiltMin> 
  <jwplayer:tiltMax>30</jwplayer:tiltMax> 
  <jwplayer:panMin>-90</jwplayer:panMin> 
  <jwplayer:panMax>90</jwplayer:panMax> 
  </item>
  </channel>
  </rss>

The only required tag to force the player into panoramic mode is to specify the projection - the tag is jwplayer:projection. The options are equirectangular, cylindrical, and equiangular.

The next four arguments are optional. PanMin and PanMax specify the range of pan (side to side movement). Tiltmin and Tiltmax specify the range of top to bottom movement.

--- Contact ---

For issues, problems or feedback please use the github: https://github.com/sditmore/Pantaloons. Or contact me at sditmore@eyesee360.com.


--- Licensing ---

Pantaloons is free for non commerical use, licensed under the BY-NC-SA (http://creativecommons.org/licenses/by-nc-sa/3.0/). To license Pantaloons for commerical use, please email mjr@eyesee360.com.
