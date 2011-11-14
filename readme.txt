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
5. Under Main Application File, select 'JWPlayer.as'
6. Click 'Finish'
7. You can now use project normally.

--- Tutorial ---

==== Installation ====

To use the pantaloons player, you will need the following things:

- A panoramic video
- A webserver you can host files on
- A copy of the pantaloons player. You can download the pantaloons player package at https://github.com/EyeSee360/Pantaloons/downloads

When you've downloaded the player, unzip the contents. Inside you should see the following files: 
 
- history/ : A folder containing some javascript
- skin/ : A folder containing the settings for the appearance of the player
- KickstarterUpdate1.vwm : A sample panoramic movie to test with
- JWPlayer.swf : The pantaloons flash player
- swfobject.js: The javascript files used to embed the player in an html page
- JWPlayer.html: A sample html file

You will need to move the history/ folder, the skin/ folder, the JWPlayer.swf file, and the swfobject.js file to the directory on your webserver where the html page you want to embed the file into is located. You will also need to copy your panoramic movie file to that directory as well.

==== Configuration ====

----- HTML -----

Next, you will need to make some modifications to the html page you will be displaying the player on. Open the file with your editor of choice.

In the head section of the html page (marked with the <head> </head> tags), you will need to insert the following code:

    <link rel="stylesheet" type="text/css" href="history/history.css" />
    <script type="text/javascript" src="history/history.js"></script>
    <!-- END Browser History required section -->  
	    
    <script type="text/javascript" src="swfobject.js"></script>
    <script type="text/javascript">
        <!-- For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. --> 
        var swfVersionStr = "10.0.0";
        <!-- To use express install, set to playerProductInstall.swf, otherwise the empty string. -->
        var xiSwfUrlStr = "playerProductInstall.swf";
        var flashvars = {file: 'FILENAME.VWM', type: 'video' , skin: 'skin/pantaloons.xml', repeat: 'always' };
        var params = {};
        params.quality = "high";
        params.bgcolor = "#ffffff";
        params.allowscriptaccess = "sameDomain";
        params.allowfullscreen = "true";
        var attributes = {};
        attributes.id = "JWPlayer";
        attributes.name = "JWPlayer";
        attributes.align = "middle";
        swfobject.embedSWF(
            "JWPlayer.swf", "flashContent", 
            "WIDTH", "HEIGHT", 
            swfVersionStr, xiSwfUrlStr, 
            flashvars, params, attributes);
		<!-- JavaScript enabled so display the flashContent div in case it is not replaced with a swf object. -->
		swfobject.createCSS("#flashContent", "display:block;text-align:left;");
    </script>
</head>
 
The height and width of the player are set where HEIGHT and WIDTH are labeled. They can be specified as a percent, ie 100%, or a pixel size (like 240).

You should replace FILENAME.VWM with the name of your video.

For panoramic videos with the .vwm extension, the player should be able to detect the correct projection automatically - however, you
will need to add a flashvar - provider: 'video' because .vwm is not a recognized video format If your video is not a .vwm extension, you have some extra work to do. You will need to tell the player about the projection of your video. See the 'Projection Flash Vars' for details.

Next, you will need to insert this code in the <body></body> tags where you want the html to appear.

 	<div class="player" id="flashContent">
	       	<p>
	        	To view this page ensure that Adobe Flash Player version 
				10.0.0 or greater is installed. 
			</p>
			<script type="text/javascript"> 
				var pageHost = ((document.location.protocol == "https:") ? "https://" :	"http://"); 
				document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
								+ pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" ); 
			</script> 
       </div>

The swfobject javascript will replace this div with the flash player at runtime, after checking to make sure the browser has flashplayer installed. Otherwise, it will prompt the user to download flash.

----- Projection Flash Vars ------

The following parameters can be used to set projection. They should be added to the flashvars in the code you inserted in the <head> tags of your html. Example:

 var flashvars = {file: 'FILENAME.VWM', type: 'video' , skin: 'skin/pantaloons.xml', repeat: 'always', projectiontype:'equirectangular', panmin: '0', panmax: '180' };

General:

- "projectiontype" (mandatory if not a .vwm file): A value which describes the projection of an image. A projection specifies how pixels in the image will map to a pan-tilt coordinate system. Projections have a type, which specifies the conversion formulas used, and may have parameters which control this conversion. There are several commonly used projection types; Pantaloons currently supports cylindrical and equirectangular.

- "roi" (optional): Specifies a rectangular Region of Interest (ROI) in the image over which the presentation is defined. For instance, if you have an equirectangular image shown in a "letterbox" format with black bars top and bottom, you can specify the rectangle of the actual image area. The projection will apply to only that cropped region of the image.
The roi is formatted as a rectangle, so examples of it would like this:
	roi="0 0 1280 720"	 specifies a rectangle starting at the top left origin and extending 1280 pixels horizontally by 720 vertically.
	roi="25% 0% 50% 100%"	 specifies a rectangle starting 25% from the left and spanning half the width and the full height of the image.


Tilt:

- "tiltmin" (optional) : Specifies the minimum tilt angle of the image, or the tilt angle corresponding to the bottom of the image. If specified, either tiltrange or tiltmax must also be provided to define the full range of tilt for the image.

- "tiltmax" (optional) : Optional. Specifies the maximum tilt angle of the image, or the tilt angle corresponding to the top of the image. If specified, either tiltrange or tiltmin must also be provided to define the full range of tilt for the image.

- "tiltrange" (optional): Specifies the range of the image in the tilt (vertical, or pitch) direction. Requires 0 < tiltrange <= 180, possibly less depending on the projection type. If not specified a value will be interpreted based on the projection type. If specified without any other tilt* parameters, the tilt range is interpreted to be symmetric about the horizon of the image. For example, tiltrange="90" implies tilt boundaries at -45° and +45°

Pan:

- "panmin" : Specifies the minimum pan angle of the image. If specified, either panrage or panmax must also be provided to define the full range of the pan for the image. 

- "panmax" : Specifies the maximum pan angle of the image. If specified, either panrange or panmin must also be provided to define the full range of the pan for the image.

- "panrange" (optional): Specifies the range of the image in the pan (horizontal, or yaw) direction. By default this is 360°, but for partial panoramas a smaller value may be used.

===== Additional Configuration ======

Most additional configuration can be done by looking at JWPlayer guide: http://www.longtailvideo.com/support/jw-player-setup-wizard.

--- Contact ---

For issues, problems or feedback please use the github: https://github.com/EyeSee360/Pantaloons. Or contact sditmore@eyesee360.com.


--- Licensing ---

Pantaloons is free for non commerical use, licensed under the BY-NC-SA (http://creativecommons.org/licenses/by-nc-sa/3.0/). To license Pantaloons for commerical use, please email mjr@eyesee360.com.
