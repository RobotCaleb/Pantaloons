package com.longtailvideo.jwplayer.input
{
	import com.longtailvideo.jwplayer.geometry.Projector;
	import com.longtailvideo.jwplayer.view.interfaces.IDisplayComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	public class KeyboardVelocityController
	{
		private var _projector:Projector;
		public var panSpeed:Number;
		public var tiltSpeed:Number;
		public var zoomSpeed:Number;
		private var _stage:Stage;

		public function KeyboardVelocityController(projector:Projector)
		{
			/* since the velocity is in milliseconds we divide */
			_projector = projector;
			panSpeed = 80/1000;
			tiltSpeed = 40/1000;
			zoomSpeed = 20/1000;
		}

		
		public function resize():void
		{
			_projector.zoomVelocity = 0;
			_projector.panVelocity = 0;
			_projector.tiltVelocity = 0;
			
		}
		
		public function addHandlers(stage:Stage):void
		{
			_stage = stage;
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			var dpan:Number = 0;
			var dtilt:Number = 0;
			var dzoom:Number = 0;
			
			switch (e.keyCode) {
				case 37: // Left
					dpan = panSpeed;
					break;
				case 38: // Up
					dtilt = tiltSpeed;
					break;
				case 39: // Right
					dpan = -panSpeed;
					break;
				case 40: // Down
					dtilt = -tiltSpeed;
					break;
				case 189: // number -
				case 109: // keypad -
				case 68:
					dzoom = zoomSpeed;
					break;
				case 187: //number +
				case 107: //keypad +
				case 65:
					dzoom = -zoomSpeed;
					break;
			}
			
			if (dpan) {
				_projector.panVelocity = dpan;
			}
			if (dtilt) {
				_projector.tiltVelocity = dtilt;
			}
			if (dzoom) {
				_projector.zoomVelocity = dzoom;
			}
		}
		
		private function keyUp(e:KeyboardEvent):void
		{
			switch (e.keyCode) {
				case 39: // Right	
				case 37: // Left
					_projector.panVelocity = 0;
					break;
				case 38: // Up
				case 40: // Down
					_projector.tiltVelocity = 0;
					break;
				case 189: // number -
				case 109: // keypad -
				case 68:
				case 187: //number +
				case 107: //keypad +
				case 65:
					_projector.zoomVelocity = 0;
			}
		}
		
		public function terminate():void
		{
			_projector.zoomVelocity = 0;
			_projector.panVelocity = 0;
			_projector.tiltVelocity = 0;
			
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		public function resume():void
		{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		
	}
}