package com.longtailvideo.jwplayer.view {
	import com.longtailvideo.jwplayer.events.PlayerStateEvent;
	import com.longtailvideo.jwplayer.player.IPlayer;
	import com.longtailvideo.jwplayer.player.PlayerState;
	import com.longtailvideo.jwplayer.utils.Animations;
	import com.longtailvideo.jwplayer.utils.AssetLoader;
	import com.longtailvideo.jwplayer.utils.Logger;
	import com.longtailvideo.jwplayer.utils.RootReference;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	public class Logo extends MovieClip {
		/** Configuration defaults **/
		protected var defaults:Object = {
			prefix: "http://media.eyesee360.com", 
			file: "FlashPlayerLogo.png", 
			link: "http://www.gopano.com/", 
			margin: 8, 
			out: 0.5, 
			over: 1, 
			timeout: 5,
			hide: "true",
			position: "bottom-left"
		}
		/** Reference to the player **/
		protected var _player:IPlayer;
		/** Reference to the current fade timer **/
		protected var timeout:uint;
		/** Reference to the loader **/
		protected var loader:AssetLoader;
		/** Animations handler **/
		protected var animations:Animations;
		
		/** Dimensions **/
		protected var _width:Number;
		protected var _height:Number;
		
		/** Constructor **/
		public function Logo(player:IPlayer) {
			super();
			this.buttonMode = true;
			this.mouseChildren = false;
			animations = new Animations(this);
			_player = player;
			player.addEventListener(PlayerStateEvent.JWPLAYER_PLAYER_STATE, stateHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			addEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
			loadFile();
		}
		
		protected function loadFile():void {
			var versionRE:RegExp = /(\d+)\.(\d+)\./;
			var versionInfo:Array = versionRE.exec(_player.version);
			if (getConfigParam('file') && getConfigParam('prefix')) {
				defaults['file'] = getConfigParam('prefix') +"/"+ getConfigParam('file');
			}
			
	//	if (getConfigParam('file') && RootReference.root.loaderInfo.url.indexOf("http")==0) {
				loader = new AssetLoader();
				loader.addEventListener(Event.COMPLETE,loaderHandler);
				loader.addEventListener(ErrorEvent.ERROR, errorHandler);
				loader.load(getConfigParam('file'));	
		//}
		}
		
		/** Logo loaded - add to display **/
		protected function loaderHandler(evt:Event):void {
			if (getConfigParam('hide').toString() == "true") visible = false;
			addChild(loader.loadedObject);
			resize(_width, _height);
		}
		
		/** Logo failed to load - die **/
		protected function errorHandler(evt:ErrorEvent):void {
			Logger.log("Failed to load logo: " + evt.text);
		}
		
		
		/** Handles mouse clicks **/
		protected function clickHandler(evt:MouseEvent):void {
			_player.pause();
			if (getConfigParam('link')) {
				navigateToURL(new URLRequest(getConfigParam('link')));
			}
		}
		
		/** Handles mouse outs **/
		protected function outHandler(evt:MouseEvent):void {
			alpha = getConfigParam('out');
		}
		
		
		/** Handles mouse overs **/
		protected function overHandler(evt:MouseEvent):void {
			alpha = getConfigParam('over');
		}
		
		
		/** Handles state changes **/
		protected function stateHandler(evt:PlayerStateEvent):void {
			if (_player.state == PlayerState.BUFFERING) {
				clearTimeout(timeout);
				show();
			}
		}
		
		
		/** Fade in **/
		protected function show():void {
			visible = true;
			animations.fade(getConfigParam('out'), 0.1);
			timeout = setTimeout(hide, getConfigParam('timeout') * 1000);
			mouseEnabled = true;
		}
		
		
		/** Fade out **/
		protected function hide():void {
			if (getConfigParam('hide').toString() == "true") {
				mouseEnabled = false;
				animations.fade(0, 0.1);
			}
		}
		
		
		/** Resizes the logo **/
		public function resize(width:Number, height:Number):void {
			_width = width;
			_height = height;
			var image:Bitmap = loader ? (loader.loadedObject as Bitmap) : null;
			var margin:Number = getConfigParam('margin');
			var position:String = (getConfigParam('position') as String).toLowerCase(); 
			if (image) {
				if (position.indexOf('right') >= 0) {
					image.x = _width - image.width - margin;
				} else {
					image.x = margin;
				}
				
				if (position.indexOf('bottom') >= 0) {
					image.y = _height - image.height - margin;
				} else {
					image.y = margin;
				}
			}
		}
		
		
		/** Gets a configuration parameter **/
		protected function getConfigParam(param:String):* {
			return defaults[param];
		}
	}
}