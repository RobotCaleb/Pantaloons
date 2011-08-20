package com.longtailvideo.jwplayer.geometry
{
	
	import com.*;
	
	import flash.geom.Rectangle;
	
	/* Stores data about a given projection */
	public class Projection
	{	
		public static const EQUIRECTANGULAR:String = "equirectangular";
		public static const CYLINDRICAL:String = "cylindrical";
		public static const RECTILINEAR:String = "rectilinear";
		public static const EQUIANGULAR:String = "equiangular";
		public static const PLANAR:String = "planar";
		
		protected static const D2R:Number = Math.PI/180.0; //0.017453292519943295
		protected static const R2D:Number = 180.0/Math.PI; //57.29577951308232
		
		/* This is set when we receive the ROI before the height and the width. */
		protected var _roiIsPercentage:Boolean;
		protected var _panMin:Number;
		protected var _panMax:Number;
		protected var _type:String;
		protected var _tiltMin:Number;
		protected var _tiltMax:Number;
		protected var _roi:Array;
		/* currently this is never filled */
		private var _orientation:Array;
		
		public function xml(rawData:XML):void
		{
			_roi = null;
			_roiIsPercentage = false;
			processRawData(rawData);
			trace("Processed XML as")
			trace("PanMin: ", _panMin, "PanMax: ", _panMax, "TiltMin: ", _tiltMin, "TiltMax: ", _tiltMax);
		}
		
		public function Projection():void
		{
			/* just make a pretend XML*/
			_roi = null;
			_roiIsPercentage = false;
			var rawData:XML = new XML();
			processRawData(rawData);
		}
		
		public function guess(projection:Object, width:Number, height:Number):void
		{	
			trace('Guessing - Height: ', height, 'Width: ', width)
				
			if (projection.hasOwnProperty("type")) {
				_type = projection.type;			
			} else {
				_type = Projection.EQUIRECTANGULAR;
			} 
			
			if (_type == Projection.EQUIRECTANGULAR){
				var dpp:Number = 360.0 / width;
				var tiltRange:Number = height * dpp;
				if (tiltRange > 180.0) {
					tiltRange = 180.0
				}
				
				trace('DPP: ', dpp)
				_tiltMin = -tiltRange/2.0;
				_tiltMax = tiltRange/2.0;
				_panMin = 0.0;
				_panMax = 360.0;
				trace("PanMin: ", _panMin, "PanMax: ", _panMax, "TiltMin: ", _tiltMin, "TiltMax: ", _tiltMax);
				
			} else if (_type == Projection.CYLINDRICAL) {
				// guess cylindrical, centered on horizon
				var radius:Number = width / (2 * Math.PI);
				var tiltLim:Number = R2D * Math.atan2(height / 2, radius);
				_tiltMin = -tiltLim;
				_tiltMax = tiltLim;
				_panMin = -180.0;
				_panMax = 180.0;
			}	
			
			/* read in user variables */
			if (projection.hasOwnProperty("panmax") && projection.hasOwnProperty("panmin")) {
				_panMax = Number(projection.panmax);
				_panMin = Number(projection.panmin);
			} else if (projection.hasOwnProperty("panrange") && projection.hasOwnProperty("panmin")) {
				_panMax = Number(projection.panmin) + Number(projection.panrange);
				_panMin = Number(projection.panmin);
			} else if (projection.hasOwnProperty("panrange") && projection.hasOwnProperty("panmax")) {
				_panMin = Number(projection.panrange);
				_panMax = Number(projection.panmax);
			} else if (projection.hasOwnProperty("panrange")) {
				_panMin = 0.0;
				_panMax = Number(projection.panrange);
			} 
			
			/* process the y axis */
			if (projection.hasOwnProperty("tiltmin") && projection.hasOwnProperty("tiltmax")) {
				_tiltMax = Number(projection.tiltmax);
				_tiltMin = Number(projection.tiltmin);
			} else if (projection.hasOwnProperty("tiltrange") && projection.hasOwnProperty("tiltmin")){
				_tiltMax = Number(projection.tiltmin) + Number(projection.tiltrange);
				_tiltMin = Number(projection.tiltmin);
			} else if (projection.hasOwnProperty("tiltrange") && projection.hasOwnProperty("tiltmax")) {
				_tiltMin = Number(projection.tiltmax) - Number(projection.tiltrange);
				_tiltMax = Number(projection.tiltmax);
			} else if (projection.hasOwnProperty("tiltrange")) {
				_tiltMin = -1 * ((Number(projection.tiltrange)) / 2.0);
				_tiltMax = (Number(projection.tiltrange)) / 2.0;
			} 
			
			/*if (projection.hasOwnProperty("roi")) {
	
				var roiString:String = projection.roi;
				var roiArray:Array = roiString.split(' ');
				
				if (roiString.indexOf("%") != -1) {
					var x:Number = 0;
					_roiIsPercentage = true;
					_roi = new Array();
					for (var element:String in roiArray){
						_roi[x] = Number(element.substr(0, length-1)) / 100.0;
						x++;
					}
				} else if (roiArray.length >= 4) {
					_roi = new Array();
					_roiIsPercentage = false;
					_roi[0] = Number(roiArray[0]);
					_roi[1] = Number(roiArray[1]);
					_roi[2] = Number(roiArray[2]);
					_roi[3] = Number(roiArray[3]);
				}
			}*/
			
		}
		
		/* We have to pass in the width and height now because it's really difficult to 
		get the proper width and height of an image/video */
		public function getROIRect(width:Number, height:Number):Rectangle
		{
			if (_roi) {
				
				if (_roiIsPercentage){
					var returnRect:Rectangle = new Rectangle(_roi[0]*width, _roi[1]*height, _roi[2]*width, _roi[3]*height);	
					return returnRect;
				} else {
					return new Rectangle(_roi[0], _roi[1], _roi[2], _roi[3]);	
				}
			} else {		
				return new Rectangle(0, 0, width, height);	
			}
		}
		
		public function get type():String
		{
			return _type;
		}
		
		/* returns the radial bounds of the viewing area */
		public function get boundsDeg():Array
		{
			var boundsDeg:Array = [_panMin, _tiltMin, _panMax -_panMin, _tiltMax-_tiltMin];
			return boundsDeg;
		}
		
		/* returns the radial bounds of the viewing area */
		public function get bounds():Array
		{
			var boundsDeg:Array = [_panMin, _tiltMin, _panMax - _panMin, _tiltMax-_tiltMin];
			var boundsRad:Array = [
				boundsDeg[0] * D2R, boundsDeg[1] * D2R,
				boundsDeg[2] * D2R, boundsDeg[3] * D2R
			];
			return boundsRad;
		}
		
		
		/* We expect to receive a projection object */
		protected function processRawData(rawData:XML):void
		{
			
			var proj:Namespace = new Namespace("ns:eyesee360.com/ns/xmp_projection1/"); 
			
			var data:Object;
						
			if (rawData.@proj::type.length()) {
				_type = String(rawData.@proj::type);
			}	
			
			if (_type == Projection.EQUIRECTANGULAR){
				_tiltMin = -90;
				_tiltMax = 90
				_panMin = 0.0;
				_panMax = 360.0;
				
			} else if (_type == Projection.CYLINDRICAL) {
				_tiltMin = -90;
				_tiltMax = 90;
				_panMin = -180.0;
				_panMax = 180.0;
			}				

			/* process the x axis */
			if (rawData.@proj::panMax.length() && rawData.@proj::panMin.length()) {
				_panMax = rawData.@proj::panMax;
				_panMin = rawData.@proj::panMin;
			} else if (rawData.@proj::panRange.length() && rawData.@proj::panMin.length()) {
				_panMax = Number(rawData.@proj::panMin) + Number(rawData.@proj::panRange);
				_panMin = rawData.@proj::panMin;
			} else if (rawData.@proj::panRange.length() && rawData.@proj::panMax.length()) {
				_panMin = Number(rawData.@proj::panMax) - Number(rawData.@proj::panRange);
				_panMax = Number(rawData.@proj::panMax);
			} else if (rawData.@proj::panRange.length()) {
				_panMin = 0.0;
				_panMax = rawData.@proj::panRange;
			} 

			/* process the y axis */
			if (rawData.@proj::tiltMin.length() && rawData.@proj::tiltMax.length()) {
				_tiltMax = rawData.@proj::tiltMax;
				_tiltMin = rawData.@proj::tiltMin;
			} else if (rawData.@proj::tiltRange.length() && rawData.@proj::tiltMin.length()) {
				var tiltRange:Number = rawData.@proj::tiltRange;
				_tiltMin = rawData.@proj::tiltMin;
				_tiltMax = _tiltMin+tiltRange;

			} else if (rawData.@proj::tiltRange.length() && rawData.@proj::tiltMax.length()) {
				var tiltRange:Number = rawData.@proj::tiltRange;
				_tiltMax = rawData.@proj::tiltMax;
				_tiltMin = _tiltMax - tiltRange;
			} else if (rawData.@proj::tiltRange.length()) {
				_tiltMin = -1 * ((Number(rawData.@proj::tiltRange)) / 2.0);
				_tiltMax = (Number(rawData.@proj::tiltRange)) / 2.0;
			} 
			/*if (rawData.@proj::roi.length()) {
				
				

				var roiString:String = rawData.@proj::roi;
				var roiArray:Array = roiString.split(' ');
				
				if (roiString.indexOf("%") != -1) {
					var x:Number = 0;
					_roiIsPercentage = true;
					_roi = new Array();
					for (var element:String in roiArray){

						_roi[x] = Number(element.substr(0, length-1)) / 100.0;
						x++;
					}
				} else if (roiArray.length >= 4) {
						_roi = new Array();
						_roiIsPercentage = false;
						_roi[0] = Number(roiArray[0]);
						_roi[1] = Number(roiArray[1]);
						_roi[2] = Number(roiArray[2]);
						_roi[3] = Number(roiArray[3]);
				}
			}*/
		}
	
	}
}
