/**
 * JW Player namespace definition
 * @version 5.4
 */
var jwplayer = function(container) {
	if (jwplayer.api){
		return jwplayer.api.selectPlayer(container);
	}
};

var $jw = jwplayer;

jwplayer.version = '5.5.1629';
jwplayer.vid = document.createElement("video");
jwplayer.audio = document.createElement("audio");
jwplayer.source = document.createElement("source");