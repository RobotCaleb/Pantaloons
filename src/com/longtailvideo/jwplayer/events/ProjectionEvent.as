package com.longtailvideo.jwplayer.events
{
	
	import flash.events.Event;
	/**
	 * Event class thrown by the UnwarpMediaProxy
	 * 
	 * @see com.longtailvideo.jwplayer.model.media.UnwarpMediaProxy
	 * @author Susan Ditmore
     */
	public class ProjectionEvent extends PlayerEvent
	{
	
		public static var SOURCE_PROJECTION_SWITCH:String = "sourceProjectionSwitch";
		public static var VIEW_PROJECTION_SHIFT:String = "viewProjectionSwitch";
		public static var VIEW_INPUT_HANDLER:String = "viewInputHandler";
		
		public var data:Object;		
		
		public function ProjectionEvent(type:String, msg:String=undefined)
		{
			super(type, msg);
		}
		
		public override function clone():Event
		{
			var copy = new ProjectionEvent(type, message);
			copy.data = this.data;
			return copy;
		}
	}
}