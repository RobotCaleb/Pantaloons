/**
 * JW Player dock component
 */
(function(jwplayer) {
	jwplayer.html5.dock = function(api, config) {
		function _defaults() {
			return {
				align: jwplayer.html5.view.positions.RIGHT
			};
		};
		
		var _config = jwplayer.utils.extend({}, _defaults(), config);
		
		if (_config.align == "FALSE") {
			return;
		}
		var _buttons = {};
		var _buttonArray = [];
		var _width;
		var _height;
		
		var _dock = document.createElement("div");
		_dock.id = api.id + "_jwplayer_dock";
		
		this.getDisplayElement = function() {
			return _dock;
		};
		
		this.setButton = function(id, handler, outGraphic, overGraphic) {
			if (!handler && _buttons[id]) {
				jwplayer.utils.arrays.remove(_buttonArray, id);
				_dock.removeChild(_buttons[id].div);
				delete _buttons[id];
			} else if (handler) {
				if (!_buttons[id]) {
					_buttons[id] = {
					}
				}
				_buttons[id].handler = handler;
				_buttons[id].outGraphic = outGraphic;
				_buttons[id].overGraphic = overGraphic;
				if (!_buttons[id].div) {
					_buttonArray.push(id);
					_buttons[id].div = document.createElement("div");
					_buttons[id].div.style.position = "relative";
					_dock.appendChild(_buttons[id].div);
					
					_buttons[id].div.appendChild(document.createElement("img"));
					_buttons[id].div.childNodes[0].style.position = "absolute";
					_buttons[id].div.childNodes[0].style.left = 0;
					_buttons[id].div.childNodes[0].style.top = 0;
					_buttons[id].div.childNodes[0].style.zIndex = 10;
					_buttons[id].div.childNodes[0].style.cursor = "pointer";
					
					_buttons[id].div.appendChild(document.createElement("img"));
					_buttons[id].div.childNodes[1].style.position = "absolute";
					_buttons[id].div.childNodes[1].style.left = 0;
					_buttons[id].div.childNodes[1].style.top = 0;
					if (api.skin.getSkinElement("dock", "button")) {
						_buttons[id].div.childNodes[1].src = api.skin.getSkinElement("dock", "button").src;
					}
					_buttons[id].div.childNodes[1].style.zIndex = 9;
					_buttons[id].div.childNodes[1].style.cursor = "pointer";
					
					_buttons[id].div.onmouseover = function() {
						if (_buttons[id].overGraphic) {
							_buttons[id].div.childNodes[0].src = _buttons[id].overGraphic;
						}
						if (api.skin.getSkinElement("dock", "buttonOver")) {
							_buttons[id].div.childNodes[1].src = api.skin.getSkinElement("dock", "buttonOver").src;
						}
					}
					
					_buttons[id].div.onmouseout = function() {
						if (_buttons[id].outGraphic) {
							_buttons[id].div.childNodes[0].src = _buttons[id].outGraphic;
						}
						if (api.skin.getSkinElement("dock", "button")) {
							_buttons[id].div.childNodes[1].src = api.skin.getSkinElement("dock", "button").src;
						}
					}
					// Make sure that this gets loaded and is cached so that rollovers are smooth
					if (_buttons[id].overGraphic) {
						_buttons[id].div.childNodes[0].src = _buttons[id].overGraphic;
					}
					if (_buttons[id].outGraphic) {
						_buttons[id].div.childNodes[0].src = _buttons[id].outGraphic;
					}
					if (api.skin.getSkinElement("dock", "button")) {
						_buttons[id].div.childNodes[1].src = api.skin.getSkinElement("dock", "button").src;
					}
				}
				
				if (handler) {
					_buttons[id].div.onclick = function(evt) {
						evt.preventDefault();
						jwplayer(api.id).callback(id);
						if (_buttons[id].overGraphic) {
							_buttons[id].div.childNodes[0].src = _buttons[id].overGraphic;
						}
						if (api.skin.getSkinElement("dock", "button")) {
							_buttons[id].div.childNodes[1].src = api.skin.getSkinElement("dock", "button").src;
						}
					}
				}
			}
			
			_resize(_width, _height);
		}
		
		function _resize(width, height) {
			_width = width;
			_height = height;
			
			if (_buttonArray.length > 0) {
				var margin = 10;
				var xStart = width - api.skin.getSkinElement("dock", "button").width - margin;
				var usedHeight = margin;
				var direction = -1;
				if (_config.align == jwplayer.html5.view.positions.LEFT) {
					direction = 1;
					xStart = margin;
				}
				for (var i = 0; i < _buttonArray.length; i++) {
					var row = Math.floor(usedHeight / height);
					if ((usedHeight + api.skin.getSkinElement("dock", "button").height + margin) > ((row + 1) * height)) {
						usedHeight = ((row + 1) * height) + margin;
						row = Math.floor(usedHeight / height);
					}
					_buttons[_buttonArray[i]].div.style.top = (usedHeight % height) + "px";
					_buttons[_buttonArray[i]].div.style.left = (xStart + (api.skin.getSkinElement("dock", "button").width + margin) * row * direction) + "px";
					usedHeight += api.skin.getSkinElement("dock", "button").height + margin;
				}
			}
		}
		
		this.resize = _resize;
		
		return this;
	}
})(jwplayer);
