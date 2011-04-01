package com.longtailvideo.jwplayer.input
{
	import com.longtailvideo.jwplayer.events.ProjectionEvent;
	import com.longtailvideo.jwplayer.geometry.Projector;
	import com.longtailvideo.jwplayer.input.KeyboardVelocityController;
	import com.longtailvideo.jwplayer.input.MouseVelocityController;
	import com.longtailvideo.jwplayer.view.interfaces.IDisplayComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;

	public class UnwarpInput
	{
	
		private var _keyboardController:KeyboardVelocityController;
		private var _mouseController:MouseVelocityController;
		private var _projector:Projector
		
		public function UnwarpInput(projector:Projector)
		{
		
			_keyboardController = new KeyboardVelocityController(projector);
			_mouseController = new MouseVelocityController(projector);
			_projector = projector;
			projector.addEventListener(ProjectionEvent.SOURCE_PROJECTION_SWITCH, projectionSwitch);
			
		}

		
		public function addHandlers(display:IDisplayComponent, stage:Stage):void
		{
			_mouseController.addHandlers(display);
			_keyboardController.addHandlers(stage);
		}
		
		
		protected function projectionSwitch():void
		{

		}
	
		public function resize():void
		{
			_keyboardController.resize();
			_mouseController.resize();
			
		}
		
		public function terminate():void
		{
			_mouseController.terminate();
			_keyboardController.terminate();
		}
		
		public function resume():void
		{
			_mouseController.resume();
			_keyboardController.resize();
		}
	
	}
}