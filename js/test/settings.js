var settings = {
	/** The HTML element which will be embedded over * */
	"html" : {
		"default" : "<div id='preview'><p>Testing is simple: choose an example, change the flashvars and see if it works.</p></div>",
		"object" : "<embed id='preview' name='preview' src='../../player.swf' width='470' height='320' bgcolor='#000000' allowscriptaccess='always' allowfullscreen='true' flashvars='file=http://content.longtailvideo.com/videos/flvplayer.flv' />",
		"embed" : "<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' width='470' height='320' id='preview' name='preview'><param name='movie' value='../../player.swf'><param name='allowfullscreen' value='true'> <param name='allowscriptaccess' value='always'> <param name='wmode' value='transparent'>  <param name='flashvars' value='file=http://content.longtailvideo.com/videos/flvplayer.flv'>",
		"video" : "<video id='preview' height='270' poster='http://playertest.longtailvideo.com/bunny.jpg' width='480'><source src='http://playertest.longtailvideo.com/bunny.mp4'/></video>"
	},
	/** The embed script to use * */
	"script" : {
		"none" : "registerobjectembed",
		"swfobject" : "swfobjectembed",
		"jwembed" : "jwplayersetup"
	},
	/** Player versions to test. * */
	"players" : {
		"flash-html5-fallback" : [ {
			"type" : "flash",
			"src" : "../../player.swf"
		}, {
			"type" : "html5"
		} ],
		"html5-flash-fallback" : [ {
			"type" : "html5"
		}, {
			"type" : "flash",
			"src" : "../../player.swf"
		} ],
		"flash-only" : [ {
			"type" : "flash",
			"src" : "../../player.swf"
		} ],
		"html5-only" : [ {
			"type" : "html5"
		} ]
	},
	/** Available plugins to test. * */
	"plugins" : {},
	/** Avaliable skins to test. * */
	"skins" : {
		" " : " ",
		"beelden" : "../skins/beelden/beelden.xml",
		"bekle" : "../skins/bekle/bekle.xml",
		"bluemetal" : "../skins/bluemetal/bluemetal.xml",
		"classic" : "../skins/classic/classic.xml",
		"five" : "../skins/five/five.xml",
		"glow" : "../../../skins/glow/glow.xml",
		"lulu" : "../skins/lulu/lulu.xml",
		"modieus" : "../skins/modieus/modieus.xml",
		"playcasso" : "../skins/playcasso/playcasso.xml",
		"snel" : "../skins/snel/snel.xml",
		"stijl" : "../skins/stijl/stijl.xml",
		"stormtrooper" : "../skins/stormtrooper/stormtrooper.xml",
		"  " : " ",
		"bekle_swf" : "../skins/bekle/bekle.swf",
		"bluemetal_swf" : "../skins/bluemetal/bluemetal.swf",
		"classic_swf" : "../skins/classic/classic.swf",
		"five_swf" : "../skins/five/five.swf",
		"icecreamsneaka_swf" : "../skins/icecreamsneaka/icecreamsneaka.swf",
		"modieus_swf" : "../skins/modieus/modieus.swf",
		"playcasso_swf" : "../skins/playcasso/playcasso.swf",
		"snel_swf" : "../skins/snel/snel.swf",
		"stijl_swf" : "../skins/stijl/stijl.swf"
	},
	/** All the setup examples with their flashvars. * */
	"examples" : {
		" " : {},

		"MP4 video" : {
			"file" : "http://playertest.longtailvideo.com/bunny.mp4",
			"image" : "http://playertest.longtailvideo.com/bunny.jpg",
			"height" : 240,
			"width" : 400
		},

		"Single video with event listeners" : {
			"file" : "http://playertest.longtailvideo.com/bunny.mp4",
			"image" : "http://playertest.longtailvideo.com/bunny.jpg",
			"height" : 240,
			"width" : 400,
			"onBuffer" : "function() { alert('Buffering'); }",
			"onBufferFull" : "function() { alert('Buffer full'); }",
			"onError" : "function() { alert('Error'); }",
			"onMeta" : "function() { alert('Metadata received'); }",
			"onMute" : "function(evt) { alert('Player ' + (evt.mute ? 'muted' : 'unmuted')); }",
			"onPlaylist" : "function() { alert('Playlist loaded'); }",
			"onPlaylistItem" : "function() { alert('New playlist item'); }",
			"onReady" : "function() { alert('Player is ready'); }",
			"onResize" : "function() { alert('Player has been resized'); }",
			"onPlay" : "function() { alert('Playing'); }",
			"onPause" : "function() { alert('Paused'); }",
			"onIdle" : "function() { alert('Idle'); }",
			"onComplete" : "function() { alert('Complete'); }",
			"onTime" : "function(evt) { if (window.console && console.log) { console.log('Time: ' + evt.position); } }",
			"onVolume" : "function(evt) { alert('Volume changed to ' + evt.volume); }"
		},

		"Youtube video" : {
			"file" : "http://youtube.com/watch?v=IBTE-RoMsvw",
			"height" : 240,
			"width" : 400
		},

		"  " : {},
		"HTML5 Only" : {},
		"----" : {},

		"OGV video (FF / Chrome)" : {
			"file" : "http://playertest.longtailvideo.com/bunny.ogv",
			"image" : "http://playertest.longtailvideo.com/bunny.jpg",
			"height" : 240,
			"width" : 400
		},

		"    " : {},
		"Flash Only" : {},
		"---- " : {},

		"FLV video" : {
			"file" : "http://playertest.longtailvideo.com/bunny.flv",
			"image" : "http://playertest.longtailvideo.com/bunny.jpg",
			"height" : 240,
			"width" : 400,
			"onBuffer" : "function(){'hi how are %20?'}"
		},

		"MP3 audio" : {
			"file" : "http://playertest.longtailvideo.com/bunny.mp3",
			"height" : 24,
			"width" : 400
		},
		"AAC audio" : {
			"file" : "http://playertest.longtailvideo.com/bunny.m4a",
			"image" : "http://playertest.longtailvideo.com/bunny.jpg",
			"height" : 240,
			"width" : 400
		},
		"JPG image" : {
			"file" : "http://playertest.longtailvideo.com/bunny.jpg",
			"height" : 240,
			"width" : 400
		},

		"----  " : {},
		"HTTP streamed FLV" : {
			"file" : "http://content.bitsontherun.com/videos/Qvxp3Jnv-68183.flv",
			"provider" : "http",
			"height" : 240,
			"width" : 400,
			"http.startparam" : "apstart"
		},
		"HTTP streamed MP4" : {
			"file" : "http://content.bitsontherun.com/videos/Qvxp3Jnv-483.mp4",
			"provider" : "http",
			"height" : 240,
			"width" : 400,
			"http.startparam" : "starttime"
		},
		"HTTP bitrate switching" : {
			"file" : "http://playertest.longtailvideo.com/bitrates.xml",
			"height" : 240,
			"width" : 400,
			"plugins" : "qualitymonitor"
		},
		"RTMP streamed FLV" : {
			"file" : "videos/Qvxp3Jnv-68183.flv",
			"streamer" : "rtmp://fms.12E5.edgecastcdn.net/0012E5",
			"height" : 240,
			"width" : 400
		},
		"RTMP streamed MP4" : {
			"file" : "videos/Qvxp3Jnv-483.mp4",
			"streamer" : "rtmp://fms.12E5.edgecastcdn.net/0012E5",
			"height" : 240,
			"width" : 400
		},
		"RTMP dynamic stream" : {
			"file" : "http://playertest.longtailvideo.com/dynamic.xml",
			"height" : 240,
			"width" : 500,
			"plugins" : "qualitymonitor"
		},
		"RTMP live stream (not always on)" : {
			"file" : "isight",
			"streamer" : "rtmp://fml.dca.12E5.edgecastcdn.net/2012E5/",
			"height" : 240,
			"width" : 500,
			"plugins" : "qualitymonitor"
		},
		" " : {},
		"ASX playlist" : {
			"file" : "http://playertest.longtailvideo.com/asx.xml",
			"height" : 240,
			"width" : 800,
			"playlist" : "right",
			"playlistsize" : 400
		},
		"ATOM playlist" : {
			"file" : "http://playertest.longtailvideo.com/atom.xml",
			"height" : 240,
			"width" : 800,
			"playlist" : "right",
			"playlistsize" : 400
		},
		"iRSS playlist" : {
			"file" : "http://playertest.longtailvideo.com/irss.xml",
			"height" : 240,
			"width" : 800,
			"playlist" : "right",
			"playlistsize" : 400
		},
		"mRSS playlist" : {
			"file" : "http://playertest.longtailvideo.com/mrss.xml",
			"height" : 240,
			"width" : 800,
			"playlist" : "right",
			"playlistsize" : 400
		},
		"SMIL playlist" : {
			"file" : "http://playertest.longtailvideo.com/smil.xml",
			"height" : 240,
			"width" : 800,
			"playlist" : "right",
			"playlistsize" : 400
		},
		"XSPF playlist" : {
			"file" : "http://playertest.longtailvideo.com/xspf.xml",
			"height" : 240,
			"width" : 800,
			"playlist" : "right",
			"playlistsize" : 400
		},
		" " : {},
		"Highwinds dynamic stream" : {
			"file" : "http://playertest.longtailvideo.com/highwinds.xml",
			"height" : 240,
			"width" : 500,
			"plugins" : "qualitymonitor"
		},
		"CloudFront playlist" : {
			"file" : "http://playertest.longtailvideo.com/cloudfront.xml",
			"height" : 240,
			"width" : 800,
			"playlist" : "right",
			"playlistsize" : 400,
			"plugins" : "qualitymonitor"
		},
		" " : {},
		"Agegate plugin" : {
			"file" : "http://playertest.longtailvideo.com/corrie.flv",
			"height" : 240,
			"width" : 500,
			"plugins" : "agegate",
			"agegate.minage" : 18
		},
		"Audiodescription and captions plugins" : {
			"file" : "http://playertest.longtailvideo.com/corrie.flv",
			"height" : 240,
			"width" : 500,
			"plugins" : "audiodescription,captions",
			"audiodescription.file" : "http://playertest.longtailvideo.com/corrie.mp3",
			"captions.file" : "http://playertest.longtailvideo.com/corrie.xml"
		},
		"Audiodescription and captions plugins (2)" : {
			"file" : "http://playertest.longtailvideo.com/accessibility.xml",
			"height" : 325,
			"width" : 800,
			"playlist" : "right",
			"playlistsize" : 260,
			"volume" : 90,
			"dock" : false,
			"plugins" : "audiodescription,captions",
			"audiodescription.ducking" : 80,
			"audiodescription.debug" : true,
			"captions.back" : true,
			"captions.fontsize" : 18
		},
		"HD plugin" : {
			"file" : "http://playertest.longtailvideo.com/bunny.flv",
			"height" : 240,
			"width" : 500,
			"plugins" : "hd",
			"dock" : "true",
			"hd.file" : "http://playertest.longtailvideo.com/bunny.mp4"
		},
		"Searchbar plugin" : {
			"file" : "http://gdata.youtube.com/feeds/api/standardfeeds/recently_featured?v=2",
			"playlist" : "over",
			"height" : 260,
			"width" : 460,
			"plugins" : "searchbar",
			"searchbar.script" : "http://gdata.youtube.com/feeds/api/videos?vq=QUERY&format=5"
		},
		"Sharing plugin" : {
			"dock" : true,
			"file" : "http://playertest.longtailvideo.com/bunny.flv",
			"height" : 260,
			"width" : 460,
			"plugins" : "sharing",
			"sharing.code" : "%3Cembed%20src%3D%22http%3A%2F%2Fcontent.bitsontherun.com%2Fplayers%2FnPripu9l-1754.swf%22%20width%3D%22400%22%20height%3D%22250%22%20allowscriptaccess%3D%22always%22%20%2F%3E",
			"sharing.link" : "http://www.bigbuckbunny.org/"
		},
		" " : {},
		"Default skin with different colors" : {
			"file" : "http://playertest.longtailvideo.com/mrss.xml",
			"height" : 300,
			"width" : 500,
			"controlbar" : "over",
			"playlist" : "bottom",
			"playlistsize" : "50pct",
			"backcolor" : "333333",
			"frontcolor" : "CCCCCC",
			"lightcolor" : "77AA22",
			"screencolor" : "FFFFFF"
		},
		"Different skin with HD playlist" : {
			"file" : "http://playertest.longtailvideo.com/hd.xml",
			"height" : 240,
			"width" : 800,
			"controlbar" : "over",
			"playlist" : "right",
			"playlistsize" : 400,
			"skin" : "beelden",
			"plugins" : "hd"
		},
		"Stretched, stacked and muted" : {
			"file" : "http://playertest.longtailvideo.com/mrss.xml",
			"stretching" : "fill",
			"height" : 240,
			"width" : 600,
			"playlist" : "over",
			"controlbar" : "over",
			"mute" : "true",
			"playlistsize" : 400
		},
		"Loading from config xml" : {
			"config" : "http://playertest.longtailvideo.com/config.xml",
			"height" : 240,
			"width" : 500
		},
		"Start and duration flashvars" : {
			"file" : "http://playertest.longtailvideo.com/bunny.mp3",
			"height" : 24,
			"width" : 400,
			"start" : 5,
			"duration" : 15,
			"repeat" : "always",
			"autostart" : "true"
		}
	}
}
