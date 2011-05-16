/**
 * Plugin package definition
 * @author zach
 * @version 5.5
 */
(function(jwplayer) {
	var _plugins = {};		
	var _pluginLoaders = {};
	
	jwplayer.plugins = function() {
	}
	
	jwplayer.plugins.loadPlugins = function(id, config) {
		if (!_pluginLoaders[id]){
			_pluginLoaders[id] = new jwplayer.plugins.pluginloader(new jwplayer.plugins.model(_plugins), config);
		}
		return _pluginLoaders[id];
	}
	
	jwplayer.plugins.registerPlugin = function(id, arg1, arg2) {
		if (_plugins[id]) {
			_plugins[id].registerPlugin(id, arg1, arg2);
		} else {
			jwplayer.utils.log("A plugin ("+id+") was registered with the player that was not loaded. Please check your configuration.");
			for (var pluginloader in _pluginLoaders){
				_pluginLoaders[pluginloader].pluginFailed();
			}
		}
	}
})(jwplayer);
