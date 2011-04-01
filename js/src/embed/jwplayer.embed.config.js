/**
 * Configuration for the JW Player Embedder
 * @author Zach
 * @version 5.5
 */
(function(jwplayer) {
	function _playerDefaults() {
		return [{
			type: "flash",
			src: "/jwplayer/player.swf"
		}, {
			type: 'html5'
		}, {
			type: 'download'
		}];
	}
	
	function _isPosition(string) {
		var lower = string.toLowerCase();
		var positions = ["left", "right", "top", "bottom"];
		
		for (var position = 0; position < positions.length; position++) {
			if (lower == positions[position]) {
				return true;
			}
		}
		
		return false;
	}
	
	function _isPlaylist(property) {
		var result = false;
		 // XML Playlists
		result = (typeof property == "string" && !_isPosition(property)) ||
		// JSON Playlist
		(property instanceof Array) ||
		// Single playlist item as an Object
		(typeof property == "object" && !property.position && !property.size);
		return result;
	}
	
	jwplayer.embed.config = function(config, embedder) {
		var parsedConfig = jwplayer.utils.extend({}, config);
		
		for (var option in parsedConfig) {
			if (option.indexOf(".") > -1) {
				var path = option.split(".");
				var tempConfig = parsedConfig;
				for (var edge = 0; edge < path.length; edge++) {
					if (edge == path.length - 1) {
						if (jwplayer.utils.typeOf(tempConfig) == "object") {
							tempConfig[path[edge]] = parsedConfig[option];
							delete parsedConfig[option];
						}
					} else {
						if (tempConfig[path[edge]] === undefined) {
							tempConfig[path[edge]] = {};
						}
						tempConfig = tempConfig[path[edge]];
					}
				}
			}
		}
		
		if (typeof parsedConfig.plugins == "string") {
			var pluginArray = parsedConfig.plugins.split(",");
			for (var plugin = 0; plugin < pluginArray.length; plugin++) {
				var pluginName = jwplayer.utils.getPluginName(pluginArray[plugin]);
				if (typeof parsedConfig[pluginName] == "object") {
					if (typeof parsedConfig.plugins != "object") {
						parsedConfig.plugins = {};
					}
					parsedConfig.plugins[pluginArray[plugin]] = parsedConfig[pluginName];
					delete parsedConfig[pluginName];
				}
			}
		}
		
		var components = ["playlist", "dock", "controlbar"];
		
		//TODO : Make this handle playlistsize? / controlbar.size?
		
		for (var component = 0; component < components.length; component++) {
			if (typeof parsedConfig[components[component]] == "string") {
				if (!parsedConfig.components[components[component]]) {
					parsedConfig.components[components[component]] = {};
				}
				parsedConfig.components[components[component]].position = parsedConfig[components[component]];
				delete parsedConfig[components[component]];
			} else if (parsedConfig[components[component]]) {
				parsedConfig.components[components[component]] = parsedConfig[components[component]];
				delete parsedConfig[components[component]];
			}
		}
		
		// Special handler for the display icons setting
		if (typeof parsedConfig.icons != "undefined"){
			if (!parsedConfig.components.display) {
					parsedConfig.components.display = {};
				}
			parsedConfig.components.display.icons = parsedConfig.icons;
			delete parsedConfig.icons;
		}
		
		if (parsedConfig.players) {
			parsedConfig.modes = parsedConfig.players;
			delete parsedConfig.players;
		}
		
		var _modes;
		if (parsedConfig.flashplayer && !parsedConfig.modes) {
			_modes = _playerDefaults();
			_modes[0].src = parsedConfig.flashplayer;
			delete parsedConfig.flashplayer;
		} else if (parsedConfig.modes) {
			if (typeof parsedConfig.modes == "string") {
				_modes = _playerDefaults();
				_modes[0].src = parsedConfig.modes;
			} else if (parsedConfig.modes instanceof Array) {
				_modes = parsedConfig.modes;
			} else if (typeof parsedConfig.modes == "object" && parsedConfig.modes.type) {
				_modes = [parsedConfig.modes];
			}
			delete parsedConfig.modes;
		} else {
			_modes = _playerDefaults();
		}
		parsedConfig.modes = _modes;
		
		return parsedConfig;
	};
	
})(jwplayer);
