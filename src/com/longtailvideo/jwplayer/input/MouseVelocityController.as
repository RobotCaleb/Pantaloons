package com.longtailvideo.jwplayer.input
{
	
	import com.longtailvideo.jwplayer.events.ProjectionEvent;
	import com.longtailvideo.jwplayer.geometry.Projector;
	import com.longtailvideo.jwplayer.view.interfaces.IDisplayComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	import flash.utils.getTimer;
	
	import flashx.textLayout.events.DamageEvent;
	
	public class MouseVelocityController
	{
		
		//	Custom cursor
		[Embed (source="cursor_closedhand.png" )]
		public static const GraphicClosedHandCursor:Class;
		[Embed (source="cursor_openhand.png" )]
		public static const GraphicOpenHandCursor:Class;
		private var _hasTerminated:Boolean;
		
		
		private var _media:IDisplayComponent;
		private var _projector:Projector;
		private var _downPoint:Point;
		private var _panScale:Point;
		private var _viewScale:Point;
		private var _stage:Stage;
		
		public function MouseVelocityController(projector:Projector)
		{
			_projector = projector;
			
			/* This used to be 5 but it really moved too fast so I changed it */
			_panScale = new Point(.003, .003);
			_viewScale = new Point(1.0, 1.0);
			
			
			// Custom cursors setup 
			var cursorClosedBitmapData:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
			var cursorClosedBitmap:Bitmap = new GraphicClosedHandCursor();
			cursorClosedBitmapData[0] = cursorClosedBitmap.bitmapData;
			
			var cursorClosedData:MouseCursorData = new MouseCursorData();
			cursorClosedData.hotSpot = new Point(5,0);
			cursorClosedData.data = cursorClosedBitmapData;
			Mouse.registerCursor("ClosedHand", cursorClosedData);
			
			var cursorOpenBitmapData:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
			var cursorOpenBitmap:Bitmap = new GraphicOpenHandCursor();
			cursorOpenBitmapData[0] = cursorOpenBitmap.bitmapData;
			
			var cursorOpenData:MouseCursorData = new MouseCursorData();
			cursorOpenData.hotSpot = new Point(5,0);
			cursorOpenData.data = cursorOpenBitmapData;
			Mouse.registerCursor("OpenHand", cursorOpenData);
			
			_hasTerminated = false;
			
		}
		
		private function projectionSwitch():void
		{
			/* we need to stop the velocity if it is going */
			var e:MouseEvent = new MouseEvent(MouseEvent.MOUSE_UP);
			mouseUp(e);				
		}
		
		public function resize():void
		{
			var e:MouseEvent = new MouseEvent(MouseEvent.MOUSE_UP);
			mouseUp(e);				
		}
		
		public function addHandlers(media:IDisplayComponent, stage:Stage):void
		{
			
			_stage = stage;
			_media = media;
			
			_media.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_projector.addEventListener(ProjectionEvent.SOURCE_PROJECTION_SWITCH, projectionSwitch);
			/*_media.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);*/
			
			
			//	Custom cursor listeners
			//_media.addEventListener(MouseEvent.MOUSE_UP, mouseMediaUp);
			_media.addEventListener(MouseEvent.ROLL_OVER, mouseMediaRollOver);
			_media.addEventListener(MouseEvent.ROLL_OUT, mouseMediaRollOut);
			
		}
		
		private function mouseDown(e:MouseEvent):void
		{
			_downPoint = new Point(e.localX, e.localY);
			_projector.tiltVelocity = 0.0;
			_projector.panVelocity = 0.0;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseDrag);

			_viewScale = new Point(_projector.horizontalFOV, 
				_projector.verticalFOV);
			_stage.addEventListener(MouseEvent.MOUSE_OUT, mouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			
			/*
			//	Custom cursor
			Mouse.cursor = "ClosedHand";
			*/
		}
		
		
		//	Custom cursor functions
		private function mouseMediaRollOver(e:MouseEvent):void
		{
			Mouse.cursor = "hand";//"OpenHand";
		}
		
		private function mouseMediaRollOut(e:MouseEvent):void
		{
			if (e.localX == -1 && e.localY == -1)
			{
				Mouse.cursor = flash.ui.MouseCursor.AUTO;
			}
			else if (e.localX < (_media.width / 2) - 30 || e.localX > (_media.width / 2) + 30 ||
				e.localY < (_media.height / 2) - 30 || e.localY > (_media.height / 2) + 30)
			{
				Mouse.cursor = flash.ui.MouseCursor.AUTO;
			}
			else
			{
				Mouse.cursor = "hand";
			}
/*			else if (e.buttonDown)
			{
				Mouse.cursor = "ClosedHand";
			}
			else
			{
				Mouse.cursor = "OpenHand";
			}
			*/
		}
		/*
		private function mouseMediaUp(e:MouseEvent):void
		{
			Mouse.cursor = "OpenHand";
		}
		*/
		
		private function mouseUp(e:MouseEvent):void
		{
			_projector.tiltVelocity = 0;
			_projector.panVelocity = 0;
			_downPoint = null;
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseDrag);
			_stage.removeEventListener(MouseEvent.MOUSE_OUT, mouseUp);
		}
		
		private function mouseDrag(e:MouseEvent):void
		{
			if (e.localX <= 1.0 && e.localY <= 1.0) {
				var currentPos:Point = new Point(e.localX, e.localY);
				if (_downPoint != null){
					var deltaPos:Point = _downPoint.subtract(currentPos);
				
					_viewScale = new Point(_projector.horizontalFOV, _projector.verticalFOV);
					_projector.panVelocity = (deltaPos.x * _panScale.x * _viewScale.x);
					_projector.tiltVelocity = (deltaPos.y * _panScale.y * _viewScale.y);
				}
			}
			
			
		}
		
		/* we should probably disable mouse wheel dragging while the FOV is changing */
		private function mouseWheel(e:MouseEvent):void
		{
			_projector.verticalFOV += e.delta;
		}
		
		public function terminate():void
		{
			
			//	Custom cursor
			_hasTerminated = true;
			Mouse.cursor = flash.ui.MouseCursor.AUTO;
			
			
			_projector.tiltVelocity = 0;
			_projector.panVelocity = 0;
			_downPoint = null;
			
			_media.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			/*_media.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);*/
			
			_projector.removeEventListener(ProjectionEvent.SOURCE_PROJECTION_SWITCH, projectionSwitch);
			
		}
		
		public function resume():void
		{
			//	Custom cursor	
			if (_hasTerminated)
				Mouse.cursor = "hand";//"OpenHand";
			
			_media.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			/*_media.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);*/	
		}
		
	}
}