package com.longtailvideo.jwplayer.geometry
{
	import com.longtailvideo.jwplayer.events.ProjectionEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Video;
	
	import org.osmf.layout.AbsoluteLayoutFacet;

	public class Projector extends EventDispatcher;
	{
		/* the original media we are supposed to transform */
		private var _media:MovieClip;
		/* the source bitmap data */
		private var _sourceBitmap:BitmapData;
		/* the unwarped media */
		private var _projectedBitmap:BitmapData;
		/* the projection we are currently transforming from*/
		private var _sourceProjection:Projection;
		/* the projection we are currently transforming to */
		private var _destProjection:ViewProjection;
	    /* the matrix we use to transform the media */
		private var _transformMatrix:Matrix;
		/* the matrix we use to crop the initial media */
		private var _clipRect:Rectangle;
		/* the internal representation of the drawable media (either a video or an image) */
		private var _drawable:IBitmapDrawable;
		/* the stage width of the item */
		private var _width:Number;
		/* the stage height of the item */
		private var _height:Number;
		/* the width used by the shader */
		private var _shaderWidth:Number;
		/* the height used by the shader */
		private var _shaderHeight:Number;
		/* the shader object */
		private var _shader:Shader;
		/* the current shader job */
		private var _shaderJob:ShaderJob;
		/*keeps track of whether or not a resize happened while a shader job was running */
		private var _needsSizeSync:Boolean;
		/* keeps track of whether or not a view projection shift happened while a shader job was running */
		private var _needsViewSync:Boolean;
		/* keeps track of whether or not we need to do a redraw */
		private var _needsRedraw:Boolean;
		
		/* the kernel pbjs that actually do the unwarping */
		[Embed(source="../../../pbj/EquirectangularToRectilinearKernel.pbj", mimeType="application/octet-stream")]
		private var EquirectangularToRectilinearKernel:Class;
		
		[Embed(source="../../../pbj/CylindricalToRectilinearKernel.pbj", mimeType="application/octet-stream")]
		private var CylindricalToRectilinearKernel:Class;
		
		[Embed(source="../../../pbj/EquiangularToRectilinearKernel.pbj", mimeType="application/octet-stream")]
		private var EquiangularToRectilinearKernel:Class;
		
		private var _needsSizeSync:Boolean;
		
		public function Projector(media:MovieClip, sourceprojection:Projection, destprojection:ViewProjection, width:Number, height:Number)
		{
			_sourceProjection = sourceprojection;
			_destProjection = destprojection;
			_destProjection.addEventListener(ProjectionEvent.VIEW_PROJECTION_SHIFT, viewShift);
			_needsSizeSync = false;
			_needsSyncView = false;
			_needsRedraw = false;
			_media = media;
			_width = width;
			_height = height;
			initializeData();
		}
		
		public function viewShift(data:Object)
		{
			/* when the view projection changes, we have to update the shader's inputs */
			syncView();

			var event:ProjectionEvent = new ProjectionEvent(ProjectionEvent.VIEW_PROJECTION_SHIFT);
			this.dispatchEvent(event);
			
		}
		protected function initializeData():void
		{
			initSource();
			syncDestSize();
			initShader();
			updateDestProjection();
		}
		
		/* runs the unwarp job */
		public function update():void
		{	
			
			if (_shader && _shaderHeight && !_shaderJob) {
				if (_needsSizeSync){
					syncDest();
				}
				if (_needsSyncView){
					syncView();
				}
				
				if (!_shaderJob) {
					/* update the source media */
					refreshSource();
					
					/* we need to put an exception in here for the planar case */
					
					_shader.data.src.input = _sourceBitmap;
					_shaderJob = new ShaderJob(_shader, _projectedBitmap, _shaderWidth, _shaderHeight);
					_shaderJob.addEventListener(ShaderEvent.COMPLETE, shaderJobComplete);
					_shaderJob.start(false);
					if (_needsRedraw){
						_needsRedraw = false;
					}
				}

			}
		}
		
		public function busy():boolean
		{
			if (_shaderJob){
				return true;
			} else {
				return false;
			}
			 
		}
		
		private function shaderJobComplete(e:ShaderEvent):void
		{
			_shaderJob = null;
			if (_needsRedraw){
				update();	
			}
			
		}
		
		public function refreshSource():void
		{	
			_sourceBitmap.draw(_drawable, _transformMatrix, null, null, _clipRect, true);
		}
		
		public function resize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			syncDest();
		}
		
		/*prepares the destination bitmap (_projectedMedia) */
		protected function syncDest():void
		{
						
			_shaderWidth = _width;
			_shaderHeight = _height;
			var mw:Number = _width % 4;
			var mh:Number = _height % 4;
			_shaderWidth += (mw) ? 4 - mw : 0; 
			_shaderHeight += (mh) ? 4 - mh : 0;
					
			_projectedBitmap = new BitmapData(_shaderWidth, _shaderHeight, false, 0);
			if (_shader && !_shaderJob) {	
				_shader.data.outputDimensions.value = [_shaderWidth, _shaderHeight];
				_needsSizeSync = false;
			} else if (_shader){	
				_needsSizeSync = true;
				_needsRedraw = true;
			}
			
		}
		
		/* syncs changes to orientation, rotation, and viewBounds */
		public function syncView():void
		{
			
			if (_shaderJob && _shader){
				_needsSyncView = true;
				_needsRedraw = true;
				return;
			}
			
			if (_destProjection is RectilinearProjection) {
				var rectProjection:RectilinearProjection = _destProjection as RectilinearProjection;
				var viewBounds:Array = rectProjection.bounds;
				var orientation:Vector.<Number> = rectProjection.orientation.rawData;
				var rotationMatrix:Array = [
					orientation[0], orientation[1], orientation[2],
					orientation[4], orientation[5], orientation[6],
					orientation[8], orientation[9], orientation[10]
				];
				
				_shader.data.viewBounds.value = viewBounds;
				_shader.data.rotationMatrix.value = rotationMatrix;
				
			}
			
			_needsSyncView = false;
			
		}
			
		protected function initShader():void
		{
			
			var fromType:String = _sourceProjection.type;
			var toType:String = _destProjection.type;
			/* for right now, this is the only type of projection we will use
			as the destination type */
			if (toType == Projection.RECTILINEAR) {
				
				switch (fromType) {
					case Projection.EQUIRECTANGULAR:
						this.initShaderEquirectangularToRectilinear();
						break;
					case Projection.CYLINDRICAL:
						this.initShaderCylindricalToRectilinear();
						break;
					case Projection.EQUIANGULAR:
						this.initShaderEquiangularToRectilinear();
						break;
					default:
						throw("Cannot unwarp from " + fromType + " to " + toType);
				} 
				
				/* special data for rectilinear */
				syncView();
				

				_shader.precisionHint = ShaderPrecision.FULL;
				_shader.data.outputDimensions.value = [_shaderWidth, _shaderHeight];
				
			} else {
				throw("Cannot unwarp to " + toType);
			}
		}
		
		private function initShaderEquirectangularToRectilinear():void
		{
			_shader = new Shader( new EquirectangularToRectilinearKernel() );
			var input:BitmapData = _sourceBitmap;
			var bounds:Array = _sourceProjection.bounds;
			
			_shader.data.src.input = input;
			_shader.data.inputDimensions.value = [input.width,input.height];
			_shader.data.equirectangularBoundsRad.value = bounds;
		}
		
		private function initShaderCylindricalToRectilinear():void
		{
			_shader = new Shader( new CylindricalToRectilinearKernel() );
			var input:BitmapData = _sourceBitmap;
			var bounds:Array = _sourceProjection.bounds;
			
			// map angle to Y axis for bounds
			bounds[3] = Math.tan(bounds[1] + bounds[3]) - Math.tan(bounds[1]);
			bounds[1] = Math.tan(bounds[1]);
			
			_shader.data.src.input = input;
			_shader.data.inputDimensions.value = [input.width,input.height];
			_shader.data.cylindricalBounds.value = bounds;
		}
		
		private function initShaderEquiangularToRectilinear():void
		{
			_shader = new Shader( new EquiangularToRectilinearKernel() );
			var input:BitmapData = _sourceBitmap;
			_shader.data.src.input = input;
			_shader.data.inputDimensions.value = [input.width,input.height];
			
			/* This is not currently available, as the XML does not support 
				these properties */
			if ('center' in _sourceProjection) {
				var center:Array = _sourceProjection['center'];
				_shader.data.mirrorCenter.value = center;
			}
			if ('radius' in _sourceProjection) {
				var radius:Array = _sourceProjection['radius'];
				_shader.data.mirrorRadius.value = radius;
			}
			if ('range' in _sourceProjection) {
				var range:Array = _sourceProjection['range'];
				_shader.data.mirrorRange.value = range;
			}
			if ('flips' in _sourceProjection) {
				var flips:Number = _sourceProjection['flips'];
				var scaleX:Number = Math.pow(-1.0, flips);
				_shader.data.scaleX.value = scaleX;
			}
		}
		
		
		/* initializes the _sourceMedia, and links the bitmapData from the video/image
		to the _sourceMedia. */
		protected function initSource():void
		{
			
			/* It's important to get the true size here, not the drawn size.
			The subMediaProvider will take care of making sure the image/content
			is scaled appropriately. We have to fetch that scale... */
			var w:Number = 0;
			var h:Number = 0;
			var scaleX = 1.0;
			var scaleY = 1.0;
		
			if (_media is Video){
				var mediaVideo:Video = _media as Video;
				h = mediaVideo.videoWidth;
				w = mediaVideo.videoHeight;
				scaleX = mediaVideo.scaleX;
				scaleY = mediaVideo.scaleY;
				_drawable = mediaVideo;
			} else if (_media is Loader) {
				var mediaLoader:Loader = _media as Loader;
				var mediaBitmap:Bitmap = mediaLoader as Bitmap;
				h = mediaBitmap.bitmapData.height;
				w = mediaBitmap.bitmapData.width;
				scaleX = mediaBitmap.scaleX;
				scaleY = mediaBitmap.scaleY;
				_drawable = mediaBitmap.bitmapData;
			}
			
		
			/* we have to transform and scale approrpiately */	
			_clipRect:Rectangle = _sourceProjection.getROIRect(scaleX*w, scaleY*h);
			_transformMatrix:Matrix = new Matrix();
			_transformMatrix.scale(scaleX, scaleY);
			_transformMatrix.translate(-_clipRect.left, -_clipRect.top);
			
			_sourceBitmap = new BitmapData(w, h, false);
			_sourceBitmap.draw(_drawable, _transformMatrix, null, null, _clipRect, true);	
		}
		
		public function get media():MovieClip
		{
			return _projectedBitmap;
		}
		
	}
}