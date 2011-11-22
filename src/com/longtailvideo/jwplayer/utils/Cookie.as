package com.longtailvideo.jwplayer.utils
{
	import flash.external.ExternalInterface;
	
	import org.osmf.net.StreamingURLResource;
	
	public class Cookie
	{
	
		public static function getCookie(key:String):*   
		{
			return ExternalInterface.call("$.cookie", key);    
		}
		public static function setCookie(key:String, val:*, expires: uint=365, path:String='/', domain:String='', secure:Boolean=false, raw:Boolean=false):void 
		{
//			javascript function $.cookie('the_cookie', 'the_value', { expires: 7, path: '/' });
			ExternalInterface.call("$.cookie", key, val, {expires: expires, path: path, domain: domain, secure: secure, raw: raw});    
		}
		
	}
}