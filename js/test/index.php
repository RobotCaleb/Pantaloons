<html>
<head>
<title>JW Player Testing</title>
<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="http://playertest.longtailvideo.com/jquery.js"></script>
<script type="text/javascript" src="http://playertest.longtailvideo.com/swfobject.js"></script>
<script type="text/javascript" src="settings.js"></script>
<script type="text/javascript" src="../bin-debug/jwplayer.js"></script>
<script type="text/javascript">


	/**
	* Initialization section. Parses settings.js and the browser querystring.
	* This section is only executed on page (re)load.
	**/

	/** The complete list with all current flashvars. **/
	var variables = {width:500,height:260};
	/** When jQuery is loaded, we initialize everything. **/
	$().ready(function() { loadSettings(); });
	/** Load the settings and querystring. **/
	function loadSettings() {
		// load the settings.
		for (itm in settings['examples']) { $("#examples").append("<option>"+itm+"</option>"); }
		for (itm in settings['players']) { $("#players").append("<option>"+itm+"</option>"); }
		for (itm in settings['skins']) { $("#skins").append("<option>"+itm+"</option>"); }
		for (itm in settings['plugins']) { $("#plugins").append("<option>"+itm+"</option>"); }
		// When an example is selected, we reload the entire page.
		$("#examples").change(function(evt) {
			evt.preventDefault();
			var obj = settings.examples[$('#examples').val()];
			for (var o in obj){
				if (o.indexOf('on') === 0){
					obj[o] = escape(obj[o]); 
				}
			}
			window.top.location.href = window.top.location.pathname+'?'+$.param(obj);
		 });
		// get the options from the querystring.
		window.top.location.search.replace(/\??(?:([^=]+)=([^&]*)&?)/g,function () {
			variables[decodeURIComponent(arguments[1])] = decodeURIComponent(arguments[2]);
		});
		// set the value and handler on player, skin and plugins.
		if(variables['players']) { $('#players').val(variables['players']); }
		if(variables['player']) { 
			$('#player').val(variables['player']); 
		} else {
			$('#player').val(dump(settings['players'][$('#players').val()]));
		}
		$("#players").change(function(evt) {
			if(evt) { evt.preventDefault(); }
			$("#player").val(dump(settings.players[$("#players").val()]));
			insertPlayer(evt);
		});
		if(variables['skin']) { 
			if(!settings['skins'][variables['skin']]) { 
				$("#skins").prepend("<option>"+variables['skin']+"</option>");
			}
			$('#skins').val(variables['skin']); 
		}
		$("#skins").change(function(evt) { insertPlayer(evt); });
		if(variables['plugins']) { 
			var arr = variables['plugins'].split(',');
			for(var i =0; i<arr.length; i++) { 
				if(!settings['plugins'][arr[i]]) { 
					$("#plugins").append("<option>"+arr[i]+"</option>");
				}
			}
			$('#plugins').val(arr); 
		}
		$("#plugins").change(function(evt) { reloadFieldsets(evt); });
		// set the handler on the flashvars and load the whole bunch.
		$("#flashvarsform").submit(function(evt) { 			if(evt) { evt.preventDefault(); } location.href = location.href.split("?")[0] + "?"+$.param(getVariables()['variables'])  });
		$('#javascript').css('display','block');
		$("#variablesform").submit(function(evt) { getVariable(evt); });
		$("#sendeventform").submit(function(evt) { sendEvent(evt); });
		$("#listenersform").submit(function(evt) { setListener(evt); });
		reloadFieldsets();
	};




	/**
	* Fieldset insertion section. Loads the player/plugins XML files to print the appropriate fieldsets.
	* This section is executed every time the player/plugins selection changes.
	**/

	/** The number of XML files that still need to be parsed. **/
	var parsing;
	/** All variables that are inserted in an XML-defined field. **/
	var prefilled;
	/** Check for inserting of fieldsets. **/
	function reloadFieldsets(evt) {
		if(evt) { evt.preventDefault(); }
		$("#flashvarsform > .removable").remove();
		$("#fieldsettabs > .removable").remove();
		$("#custom > .removable").remove();
		parsing = 1;
		prefilled = {plugins:'',player:'',skin:''};
		var swf = settings.players[$("#players").val()][0]['src'];
		if (swf) {
			var xml = swf.substr(0,swf.length-4) + '.xml';
			parsePlayerXML(xml);
	    } else {
	    	parsePlayerXML("jwplayer.html5.xml");
	    }
		var str = $("#plugins").val();
		if(str != null) {
			arr = str.toString().split(',');
			for (var i=0; i<arr.length; i++) {
				swf = settings['plugins'][arr[i]];
				if(swf && swf.substr(-4) == '.swf') { 
					parsing++;
					xml = swf.substr(0,swf.length-4) + '.xml';
					parsePluginXML(xml,arr[i]);
				}
			}
		}
	};
	/** Insert a specific plugin fieldset. **/
	function parsePlayerXML(url) {
		$.get(url,{},function(xml) {
			var arr = $('player',xml).find('flashvars');
			for (var i=0; i<arr.length; i++) {
				var nam = $(arr[i]).attr('section').toLowerCase();
				insertFieldset(arr[i],nam);
			}
			parsing--;
			if(parsing == 0) { setCustomTabbing(); }
		});
	};
	/** Insert a specific plugin fieldset. **/
	function parsePluginXML(url,nam) {
		$.get(url,{},function(xml) {
			var arr = $('flashvars',xml).find('flashvar');
			if(arr.length > 0) {
				insertFieldset(xml,nam,true);
			}
			parsing--;
			if(parsing == 0) { setCustomTabbing(); }
		});
	};
	/** Insert a specific plugin fieldset. **/
	function insertFieldset(xml,nam,plg) {
		var tit = nam.substr(0,1).toUpperCase()+nam.substr(1);
		var set = '<fieldset id="'+nam+'" class="removable">';
		var arr = $(xml).find('flashvar');
		$("#customli").before('<li class="removable">'+tit+'</li>');
		for (var i=0; i<arr.length; i++) {
			var val = $('name',arr[i]).text();
			if(plg) { val = nam+'.'+val; }
			set +='<label>'+val+'</label><input type="text" name="'+val+'" ';
			if(variables[val]) {
				if (nam == 'events') {
					set += 'value="'+unescape(variables[val]).replace(/"/g, "'")+'" ';
					prefilled[val] = unescape(variables[val]);	
				} else {
					set += 'value="'+variables[val]+'" ';
					prefilled[val] = variables[val];
				}
			}
			set += "/>";
		}
		set += '</fieldset>';
		$('#custom').before(set);
	};
	/** Set the custom fields and the tabbing functionality. **/
	function setCustomTabbing() {
		for(var itm in variables) { 
			if(prefilled[itm] == undefined) {
				var elm = '<label class="removable">'+itm+'</label>'
				elm += '<input type="text" name="'+itm+'" value="'+variables[itm]+'" class="removable"/>';
				$("#custom").append(elm);
			}
		}
		$('li').click(function() {
			$('li').removeClass('active');
			$(this).addClass('active');
			var itm = $(this).text().toLowerCase();
			doTab($.trim(itm));
		});
		doTab('sources');
		insertPlayer();
	};
	/** Flip to a tab. **/
	function doTab(itm) {
		var arr = $("#flashvarsform").find('fieldset');
		for(var i=0; i<arr.length; i++) {
			if($(arr[i]).attr('id') == itm) {
				$(arr[i]).css('display','block');
			} else {
				$(arr[i]).css('display','none');
			}
		}
	};



   function getVariables(){
		var vrs = {};
		variables = {}
		variables['players'] = $('#players').val();
		variables['player'] = $('#player').val();
		var skn = $("#skins").val();
		if(skn != ' ') {
			variables['skin'] = skn;
			if(settings['skins'][skn]) { 
				skn = settings['skins'][skn]; 
			}
			vrs['skin'] =skn;
		}
		if($("#plugins").val() != null) {
			var plg = [];
			var arr = $("#plugins").val();
			for(var i=0; i<arr.length; i++) {
				if(settings['plugins'][arr[i]]) { 
					plg.push(settings['plugins'][arr[i]]);
				} else { 
					plg.push(arr[i]);
				}
			}
			vrs['plugins'] = plg.join(',');
			variables['plugins'] = arr.join(',');
		}
		var arr = $("#flashvarsform").find('input');
		for(var i=0; i<arr.length; i++) {
			if($(arr[i]).val()) {
				if ($(arr[i]).attr('name').indexOf('on') != 0) {
					vrs[$(arr[i]).attr('name')] = $(arr[i]).val();
					variables[$(arr[i]).attr('name')] = $(arr[i]).val();
				} else {
					vrs[$(arr[i]).attr('name')] = escape($(arr[i]).val());
					variables[$(arr[i]).attr('name')] = escape($(arr[i]).val());
				}
			}
		}
		variables['htmlblock'] = $('#htmlblock').val();
		variables['scripts'] = $('#scripts').val();
		return {'vrs':vrs,'variables':variables};
   }
   
   function registerobjectembed() {
   	   player = jwplayer('preview');
   	   player.setPlayer(document.getElementById('preview'));
   }
   
   function swfobjectembed(){
   		var temp = getVariables();
   		var vrs = temp['vrs'];
   		var variables = temp['variables'];
   		$('#preview').css('height',vrs['height']);
		$('#preview').html('<div id="container"></div>');
		var playerLocation = "";
		var players = eval($('#player').val());
		for (var plr in players){
			if (players[plr]['type'] == 'flash'){
				playerLocation = players[plr]['src'];
			}
		}
		swfobject.embedSWF(
			playerLocation,
			'container',
			vrs['width'],
			vrs['height'],
			'9.0.0',
			null,
			vrs,
			{allowfullscreen:'true',allowscriptaccess:'always'},
			{id:'newPlayer',name:'newPlayer'}
		);
		var lnk = 'http://developer.longtailvideo.com/trac/testing/';
		$("#permalink").val(lnk+'?'+$.param(variables));
		player = jwplayer('newPlayer');
		player.setPlayer(document.getElementById('newPlayer'));
   }

   function jwplayersetup() {
   	var temp = getVariables();
   	var vrs = temp['vrs'];
   	var variables = temp['variables'];
	var events = {};

 	$('#preview').css('height',vrs['height']);
 	if ($('#container').length) {
 		// This is necessary for IE when calling setup on top of an existing flash player
		jwplayer.api.destroyPlayer('container');
 	} else {
		$('#preview').html('<div id="container"></div>');
 	}

	for (var v in vrs){
		if (v.indexOf("on") === 0){
			eval("var tmp ="+unescape(vrs[v]));
			events[v] = tmp;
		}
	}

	player = jwplayer('container').setup($.extend(vrs, {
		"players": eval($('#player').val()),
		"events": events
	}));
   }


	/**
	* Player insertion section. Gathers variables from all fields and prints the player on the page.
	* This section is executed every time the flashvars form is submitted.
	**/

	/** Print the player on the page. **/
	function insertPlayer(evt) {
	if(evt) { evt.preventDefault(); }
   	eval(settings['script'][$("#scripts").val()]+"();");
	};




	/**
	* Player API section. Contains functions for getting a player reference and executing API calls.
	* This section is executed when a user starts interacting with the player API.
	**/

	/** Reference to the player **/
	var player;

	/** Get a variable from the player. **/
	function getVariable(evt) {
		evt.preventDefault();
		var obj = eval("player.get"+$('#vartype').val().toString()+"();");
		alertValue(obj);
	};
	/** Send an event to the player. **/
	function sendEvent(evt) {
		evt.preventDefault();
		var typ = $('#sendevent').val();
		var dat = $('#sendeventdata').val();
		if(typ == 'LOAD' && dat.indexOf('{') > 0) {
			var arr = new Array();
			var ply = dat.split(';');
			for(var i=0; i<ply.length; i++) {
				var obj = new Object();
				var itm = ply[i].split(',');
				for(var j=0; j<itm.length; j++) {
					obj[itm[j].split(':')[0]] = itm[j].split(':')[1];
				}
				arr.push(obj);
			}
			if(arr.length > 1) {
				dat = arr;
			} else { 
				dat = obj;
			}
		}
		if (dat.toString == "") {
			player[typ]();
		} else {
			player[typ](dat);
		}
	};
	/** Set a listener to the player. **/
	function setListener(evt) {
		evt.preventDefault();
		var arr = $('#eventtype').val().toString().split(': ');
		var sel = $('#addremove').val().toString();
		var fcn = 'alertValue';
		if(arr.length == 2 && sel == 'add') {
			if(arr[0] == 'Model') {
				player.addModelListener(arr[1],fcn);
			} else { 
				player.addControllerListener(arr[1],fcn);
			}
		} else if(arr.length == 2 && sel == 'remove') {
			if(arr[0] == 'Model') { 
				player.removeModelListener(arr[1],fcn);
			} else {
				player.removeControllerListener(arr[1],fcn);
			}
		}
	};
	/** Alert responses from the player. **/
	function alertValue(obj) {
		var txt = '';
		if (typeof obj == "object") {
			for (itm in obj) {
				if(typeof(obj[itm]) == 'object') {
					txt += itm+':\n';
					for (ent in obj[itm]) {
						txt += '  '+ent+': '+obj[itm][ent]+'\n';
					}
				} else {
					txt += itm+': '+obj[itm]+'\n';
				}
			}
			alert(txt);
		} else {
			alert(obj)
		}
	};
	
		function typeOf(value) {
		var s = typeof value;
		if (s === 'object') {
			if (value) {
				if (value instanceof Array) {
					s = 'array';
				}
			} else {
				s = 'null';
			}
		}
		return s;
	}
	
function dump (object) {
  if (object == null) {
    return 'null';
  } else if (typeof(object) != 'object') {
    if (typeof(object) == 'string'){
      return"\""+object+"\"";
    }
    return object;
  }

  var type = typeOf(object);

  var result = (type == "array") ? "[" : "{";

  var loopRan = false;
  for (var i in object) {
    loopRan = true;
    if (type == "object") { result += "\""+i+"\":"};
    result += dump(object[i])+",";
  }

  if (loopRan) {
    result = result.substring(0, result.length-1);
  }

  result  += (type == "array") ? "]" : "}";

  return result;
}



</script>
</head>
<body>

<?php
  $selectedScript = 'jwembed';
  if (isset($_GET['scripts'])){
  	$selectedScript = $_GET['scripts'];
  }
  $selectedHTML = 'default';
  if (isset($_GET['htmlblock'])){
  	$selectedHTML = $_GET['htmlblock'];
  }
  $settingsJSON = file_get_contents('settings.js');
  $settingsJSON = str_replace("var settings = {","{", $settingsJSON);
  $settingsJSON = preg_replace("/\/\*\*(.+?)\*\*\//", "",$settingsJSON);
  $settings = json_decode($settingsJSON);
  $html = $settings->html;
  $htmlblockselectoroptions = "";
  foreach ($html as $htmlblockid => $htmlblock){
  	if ($htmlblockid == $selectedHTML){
		$htmlblockselectoroptions = $htmlblockselectoroptions."<option selected>".$htmlblockid."</option>";
  	} else {
	    $htmlblockselectoroptions = $htmlblockselectoroptions."<option>".$htmlblockid."</option>";
  	}
  }
  $scripts = $settings->script;
  $scriptselectoroptions = "";
  foreach ($scripts as $scriptid => $script){
	if($scriptid == $selectedScript) {
		$scriptselectoroptions = $scriptselectoroptions."<option selected>".$scriptid."</option>";
	} else {
		$scriptselectoroptions = $scriptselectoroptions."<option>".$scriptid."</option>";
	}
  }
?>

<form id="examplesform">
	<fieldset>
		<label>Load an example setup</label>
		<select name="examples" id="examples"></select>
		<label>Permalink of this setup</label>
		<input name="permalink" id="permalink"/>
	</fieldset>
</form>



<div id="javascript">
	<form id="variablesform">
		<fieldset>
			<label>Variable</label>
			<select type="text" id="vartype">
				<option>Buffer</option>
				<option>Duration</option>
				<option>Fullscreen</option>
				<option>Height</option>
				<option>Meta</option>
				<option>Mute</option>
				<option>Playlist</option>
				<option>PlaylistItem</option>
				<option>Position</option>
				<option>State</option>
				<option>Volume</option>
				<option>Width</option>
			</select>
		</fieldset>
		<button type="submit" id="variablesbutton">Get variable</button>
	</form>
	<form id="sendeventform">
		<fieldset>
			<label>Event</label>
			<select type="text" id="sendevent">
				<option>load</option>
				<option>pause</option>
				<option>play</option>
				<option>playlistItem</option>
				<option>playlistNext</option>
				<option>playlistPrev</option>
				<option>resize</option>
				<option>seek</option>
				<option>stop</option>
				<option>setMute</option>
				<option>setFullscreen</option>
				<option>setVolume</option>				
			</select>
			<label>Data</label>
			<input type="text" id="sendeventdata" />
		</fieldset>
		<button type="submit" id="sendeventbutton">Send event</button>
	</form>
</div>



<?php
  echo $html->$selectedHTML;
?>



<form id="flashvarsform">
	<ul id="fieldsettabs">
		<li class="active">Sources</li>
		<li id="customli">Custom</li>
	</ul>
	<fieldset></fieldset>
	<fieldset id="sources">
    <label>html block</label>
    <select id="htmlblock"><?=$htmlblockselectoroptions?></select>
    <label>scripts</label>
    <select id="scripts"><?=$scriptselectoroptions?></select>
    <label>players</label>
    <select id="players"></select>
    <label>player</label>
    <input id="player" name="player" type="text" />
	<label>skin</label>
	<select id="skins"></select>
	</fieldset>
	<fieldset id="custom">
		<p>
			This fieldset contains variables not claimed by the player or plugin. 
			They can be entered in the browser querystring to show up here.
		</p>
	</fieldset>
	<button type="submit">Reload player</button>
</form>
</body>
</html>
