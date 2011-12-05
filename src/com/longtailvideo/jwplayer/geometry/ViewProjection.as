package com.longtailvideo.jwplayer.geometry
{
	import com.longtailvideo.jwplayer.events.ProjectionEvent;
	import com.longtailvideo.jwplayer.geometry.Orientation;
	import com.longtailvideo.jwplayer.geometry.Projection;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	public class ViewProjection extends EventDispatcher
	{

		private const D2R:Number = Math.PI/180.0;
		private const R2D:Number = 180.0/Math.PI;
		
		private const FOV_PRESERVE_VERTICAL:Number = 1;
		private const FOV_PRESERVE_HORIZONTAL:Number = 2;
		private const FOV_PRESERVE_DIAGONAL:Number = 3;
		
		private var _orientation:Orientation;
		/* this is the rectangle that bounds the observable area */
		private var _viewPlane:Rectangle;
		private var _preserveFOVDirection:Number;
		private var _FOV:Number;					//field of view (field of vision) is the (angular or linear or areal) extent of the observable world that is seen at any given moment.
		private var _aspectRatio:Number;
		private var _inConstrainView:Boolean;		
		
		public var minPan:Number = 9999;
		public var maxPan:Number = 9999;
		public var minTilt:Number = 9999;
		public var maxTilt:Number = 9999;
		public var minVFOV:Number = 9999;
		public var maxVFOV:Number = 9999;
		
		private var _projectionType: String = Projection.RECTILINEAR;
		
		public function ViewProjection(projectionType:String=null)
		{
			_orientation = new Orientation();
			_orientation.addEventListener(ProjectionEvent.VIEW_PROJECTION_SHIFT, orientationChanged);
			_aspectRatio = 1.0;
			_inConstrainView = false;
			this.verticalFOV = 120;
			if(projectionType){
				_projectionType = projectionType;
			}
		}
		
		
		public function setView(settings:Object):void
		{
			if (settings.hasOwnProperty("pan")) {
				this.pan = Number(settings.pan);
			}
			
			if (settings.hasOwnProperty("tilt")) {
				this.tilt = Number(settings.tilt);
			}
			
			if (settings.hasOwnProperty("verticalfov")){
				this.verticalFOV = Number(settings.verticalfov);
			}
			
			if(settings.hasOwnProperty("horizontalfov")){
				this.horizontalFOV = Number(settings.horizontalfov);
			}
			
			if (settings.hasOwnProperty("diagonalfov")){
				this.diagonalFOV = Number(settings.diagonalfovw);
			}
			
		}
		
		
		private function didChange():void
		{
			var event:ProjectionEvent = new ProjectionEvent(ProjectionEvent.VIEW_PROJECTION_SHIFT);
			this.dispatchEvent(event);
		}
		
		private function orientationChanged(e:Event):void
		{
			this.didChange();
		}
		
		public function get type():String
		{
			return _projectionType;
		}
		
		public function get orientation():Orientation
		{
			return _orientation;
		}
		
		public function set orientation(o:Orientation):void
		{
			_orientation = o;
		}
		
		public function get viewPlane():Rectangle
		{
			return _viewPlane;
		}
		
		public function set viewPlane(plane:Rectangle):void
		{
			_viewPlane = plane;
			this.didChange();
		}
		
		public function get bounds():Array
		{
			return [_viewPlane.x, _viewPlane.y, _viewPlane.width, _viewPlane.height];
		}
		
		public function set bounds(bounds:Array):void
		{
			this.viewPlane = new Rectangle(bounds[0], bounds[1], bounds[2], bounds[3]);
		}
		
		public function get boundsDeg():Array
		{
			return this.bounds;
		}
		
		public function get isCentered():Boolean
		{
			var isCentered:Boolean = (_viewPlane.left == -_viewPlane.right &&
				_viewPlane.top == -_viewPlane.bottom);
			return isCentered;
		}
		
		public function get aspectRatio():Number
		{
			return _aspectRatio;
		}
		
		public function set aspectRatio(aspect:Number):void
		{
			_aspectRatio = aspect;
			
			switch (_preserveFOVDirection) {
				case FOV_PRESERVE_VERTICAL:
					this.verticalFOV = _FOV;
					break;
				case FOV_PRESERVE_HORIZONTAL:
					this.horizontalFOV = _FOV;
					break;
				case FOV_PRESERVE_DIAGONAL:
					this.diagonalFOV = _FOV;
					break;
			}
		}
		
		public function get verticalFOV():Number
		{
			return 2.0 * Math.atan(_viewPlane.height/2.0) * R2D;
		}
		
		public function set verticalFOV(degrees:Number):void
		{
			var height:Number = 2.0 * Math.tan(degrees * D2R / 2.0);
			var width:Number = height * _aspectRatio;
			_viewPlane = new Rectangle(-width/2.0, -height/2.0, width, height);
			_preserveFOVDirection = FOV_PRESERVE_VERTICAL;
			_FOV = degrees;
			this.constrainView();
			this.didChange();
		}
		
		public function get horizontalFOV():Number
		{
			return 2.0 * Math.atan(_viewPlane.width/2.0) * R2D;
		}
		
		public function set horizontalFOV(degrees:Number):void
		{
			var width:Number = 2.0 * Math.tan(degrees * D2R / 2.0);
			var height:Number = height / _aspectRatio;
			_viewPlane = new Rectangle(-width/2.0, -height/2.0, width, height); 
			_preserveFOVDirection = FOV_PRESERVE_HORIZONTAL;
			_FOV = degrees;
			this.constrainView();
			this.didChange();
		}
		
		public function get diagonalFOV():Number
		{
			var d:Number = Math.sqrt(_viewPlane.width * _viewPlane.width 
				+ _viewPlane.height * _viewPlane.height);
			return 2.0 * Math.atan(d/2.0) * R2D;
		}
		
		public function set diagonalFOV(degrees:Number):void
		{
			var d:Number = Math.sqrt(1.0 + _aspectRatio);
			var xScale:Number = _aspectRatio / d;
			var yScale:Number = 1.0 / d;
			
			var diagonal:Number = 2.0 * Math.tan(degrees * D2R / 2.0);
			var width:Number = diagonal * xScale;
			var height:Number = diagonal * yScale;
			_viewPlane = new Rectangle(-width/2.0, -height/2.0, width, height); 
			_preserveFOVDirection = FOV_PRESERVE_DIAGONAL;
			_FOV = degrees;
			this.constrainView();
			this.didChange();
		}
		
		public function get pan():Number
		{
			return this.orientation.pan;
		}
		
		public function set pan(degrees:Number):void
		{
			this.orientation.pan = degrees;
			this.constrainView();
		}
		
		public function get tilt():Number
		{
			return this.orientation.tilt;
		}
		
		public function set tilt(degrees:Number):void
		{
			this.orientation.tilt = degrees;
			this.constrainView();
		}
		
		public function get skew():Number
		{
			return this.orientation.skew;
		}
		
		public function set skew(degrees:Number):void
		{
			this.orientation.skew = degrees;
			this.constrainView();
		}
		
		public function setConstraintsFromProjection(proj:Projection):void
		{
			var bounds:Array = proj.boundsDeg;
			
			// Check for pan constraint
			if (bounds[2] < 360.0) {
				minPan = bounds[0];
				maxPan = bounds[0] + bounds[2];
			}
			
			minTilt = bounds[1];
			maxTilt = bounds[1] + bounds[3];
			
			maxVFOV = bounds[3];
			if (maxVFOV > 120) {
				maxVFOV = 120;
			}
			
			minVFOV = 30.0;	// arbitrary
			
			trace("View Projection Bounds : ");
			trace("minPan: ", minPan, "maxPan: ", maxPan, "minTilt: ", minTilt, "maxTilt: ", maxTilt); 
		}
		
		private function constrainView():void
		{
			// Prevent re-entry from FOV methods
			if (!_inConstrainView) {
				_inConstrainView = true;
				
				if (maxVFOV == 9999) {
					if (maxTilt != 9999 && minTilt != 9999) {
						maxVFOV = maxTilt - minTilt;
						if (maxVFOV > 100) maxVFOV = 100;
					} else {
						maxVFOV = 100;
					}
				}
				if (minVFOV == 9999) {
					minVFOV = 30;
				}
				
				if (this.verticalFOV > maxVFOV) {
					this.verticalFOV = maxVFOV;
				}
				if (this.verticalFOV < minVFOV) {
					this.verticalFOV = minVFOV;
				}
				
				var hfov:Number = this.horizontalFOV;
				var vfov:Number = this.verticalFOV;
				
				if (minPan != 9999) {
					if (this.orientation.pan - hfov * 0.5 < minPan) {
						this.orientation.pan = minPan + hfov * 0.5;
					}
				}
				if (maxPan != 9999) {
					if (this.orientation.pan + hfov * 0.5 > maxPan) {
						this.orientation.pan = maxPan - hfov * 0.5;
					}
				}
				
				var tilt:Number = this.orientation.tilt;
				if (maxTilt != 9999) {
					if (maxTilt == 90 && tilt > 90) {
						tilt = 90;
					} else if (tilt + vfov * 0.5 > maxTilt) {
						tilt = maxTilt - vfov * 0.5;
					}
				}
				if (minTilt != 9999) {
					if (minTilt == -90 && tilt < -90) {
						tilt = -90;
					} else if (tilt - vfov * 0.5 < minTilt) {
						tilt = minTilt + vfov * 0.5;
					}
				}
				this.orientation.tilt = tilt;
				
				_inConstrainView = false;
			}
		}
	}
}