/**
 * Embedder for the JW Player
 * @author Zach
 * @version 5.5
 */
(function(jwplayer) {
	jwplayer.embed = function(playerApi) {
		var _defaults = {
			width: 400,
			height: 300,
			components: {
				controlbar: {
					position: 'over'
				}
			}
		};
		var mediaConfig = jwplayer.utils.mediaparser.parseMedia(playerApi.container);
		var _config = new jwplayer.embed.config(jwplayer.utils.extend(_defaults, mediaConfig, playerApi.config), this);
		var _pluginloader = jwplayer.plugins.loadPlugins(playerApi.id, _config.plugins);
		
		function _setupEvents(api, events) {
			for (var evt in events) {
				if (typeof api[evt] == "function") {
					(api[evt]).call(api, events[evt]);
				}
			}
		}
		
		function _embedPlayer() {
			if (_pluginloader.getStatus() == jwplayer.utils.loaderstatus.COMPLETE) {
				for (var mode = 0; mode < _config.modes.length; mode++) {
					if (_config.modes[mode].type && jwplayer.embed[_config.modes[mode].type]) {
						var configClone = _config;
						if (_config.modes[mode].config) {
							configClone = jwplayer.utils.extend(jwplayer.utils.clone(_config), _config.modes[mode].config);
						}
						var embedder = new jwplayer.embed[_config.modes[mode].type](document.getElementById(playerApi.id), _config.modes[mode], configClone, _pluginloader, playerApi);
						if (embedder.supportsConfig()) {
							embedder.embed();
							
							_setupEvents(playerApi, _config.events);
							
							return playerApi;
						}
					}
				}
				jwplayer.utils.log("No suitable players found");
				new jwplayer.embed.logo(jwplayer.utils.extend({
					hide: true
				}, _config.components.logo), "none", playerApi.id);
			}
		};
		
		_pluginloader.addEventListener(jwplayer.events.COMPLETE, _embedPlayer);
		_pluginloader.addEventListener(jwplayer.events.ERROR, _embedPlayer);
		_pluginloader.load();
		
		return playerApi;
	};
	
	function noviceEmbed() {
		if (!document.body) {
			return setTimeout(noviceEmbed, 15);
		}
		var videoTags = jwplayer.utils.selectors.getElementsByTagAndClass('video', 'jwplayer');
		for (var i = 0; i < videoTags.length; i++) {
			var video = videoTags[i];
			jwplayer(video.id).setup({});
		}
	}
	
	noviceEmbed();
	
	
})(jwplayer);
