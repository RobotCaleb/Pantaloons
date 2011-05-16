package com.longtailvideo.jwplayer.input
{

import com.longtailvideo.jwplayer.events.ProjectionEvent;
import com.longtailvideo.jwplayer.geometry.Projector;
import com.longtailvideo.jwplayer.view.interfaces.IDisplayComponent;

import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.getTimer;

import flashx.textLayout.events.DamageEvent;

public class MouseVelocityController
{
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
		_media.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		
		_projector.addEventListener(ProjectionEvent.SOURCE_PROJECTION_SWITCH, projectionSwitch);
	}
	
	private function mouseDown(e:MouseEvent):void
	{
		_downPoint = new Point(e.localX, e.localY);
		_projector.tiltVelocity = 0.0;
		_projector.panVelocity = 0.0;
			
		_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseDrag);
			
		_viewScale = new Point(_projector.horizontalFOV, 
							   _projector.verticalFOV);
		_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
		_stage.addEventListener(Event.MOUSE_LEAVE, mouseLeave); // Stop the rotation when mouse is out of the movie clip
	}
	

	
	private function mouseUp(e:MouseEvent):void
	{
			_projector.tiltVelocity = 0;
			_projector.panVelocity = 0;
			_downPoint = null;
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseDrag);
			_stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeave);
		}
		
	private function mouseLeave(e:Event):void
	{
			_projector.tiltVelocity = 0;
			_projector.panVelocity = 0;
			_downPoint = null;	
			_media.removeEventListener(MouseEvent.MOUSE_MOVE, mouseDrag);

	}
		
		private function mouseDrag(e:MouseEvent):void
		{
			if (e.localX <= 1.0 && e.localY <= 1.0) {
				var currentPos:Point = new Point(e.localX, e.localY);
				var deltaPos:Point = _downPoint.subtract(currentPos);
	
				_viewScale = new Point(_projector.horizontalFOV, _projector.verticalFOV);
				_projector.panVelocity = (deltaPos.x * _panScale.x * _viewScale.x)
				_projector.tiltVelocity = (deltaPos.y * _panScale.y * _viewScale.y)
			}

			
		}
		
		/* we should probably disable mouse wheel dragging while the FOV is changing */
		private function mouseWheel(e:MouseEvent):void
		{
			_projector.verticalFOV += e.delta;
		}
		
		public function terminate():void
		{

			_projector.tiltVelocity = 0;
			_projector.panVelocity = 0;
			_downPoint = null;
			
			_media.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_media.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			
			_projector.removeEventListener(ProjectionEvent.SOURCE_PROJECTION_SWITCH, projectionSwitch);
			
		}
		
		public function resume():void
		{
			_media.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_media.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);	
		}
		
	}
}