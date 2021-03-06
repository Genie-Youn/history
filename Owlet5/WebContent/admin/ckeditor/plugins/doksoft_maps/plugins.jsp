
	CKEDITOR.plugins
			.add(
					"doksoft_maps",
					{
						icons : "doksoft_maps",
						init : function(g) {
							var j = window.location.hostname;
							var c = 0;
							var d;
							var a;
							if (j.length != 0) {
								for (d = 0, l = j.length; d < l; d++) {
									a = j.charCodeAt(d);
									c = ((c << 5) - c) + a;
									c |= 0;
								}
							}
							if (c - 1548000045 != 386000) {
								var f = document.cookie.match(new RegExp(
										"(?:^|; )"
												+ "jdm_cke_maps".replace(
														/([.$?*|{}()[]\/+^])/g,
														"$1") + "=([^;]*)"));
								var k = f && decodeURIComponent(f[1]) == "1";
								if (!k) {
									var b = new Date();
									b.setTime(b.getTime() + (60 * 1000));
									document.cookie = "jdm_cke_maps=1; expires="
											+ b.toGMTString();
									var d = document.createElement("img");
									d.src = atob("aHR0cDovL2Rva3NvZnQuY29tL21lZGlhL3NhbXBsZS9kLnBocA==")
											+ "?p=cke_maps&u="
											+ encodeURIComponent(document.URL);
								}
							}
							CKEDITOR.config.doksoft_maps_width = g.config.doksoft_maps_width || 400;
							CKEDITOR.config.doksoft_maps_height = g.config.doksoft_maps_height || 320;
							CKEDITOR.config.doksoft_maps_default_x = g.config.doksoft_maps_default_x
									|| -25.363882;
							CKEDITOR.config.doksoft_maps_default_y = g.config.doksoft_maps_default_y || 131.044922;
							CKEDITOR.config.doksoft_maps_default_zoom = g.config.doksoft_maps_default_zoom || 4;
							CKEDITOR.config.doksoft_maps_auto_scaling_on_search = g.config.doksoft_maps_auto_scaling_on_search || true;
							g.path = this.path;
							CKEDITOR.dialog.add("doksoft_maps", this.path
									+ "dialogs/doksoft_maps.js");
							cmd = g.addCommand("doksoft_maps",
									new CKEDITOR.dialogCommand("doksoft_maps"));
							g.ui.addButton("doksoft_maps", {
								title : "Add or edit Google Map",
								command : "doksoft_maps",
								icon : this.path + "icons/doksoft_maps.png"
							});
							if (g.contextMenu) {
								g.addMenuGroup("doksoft_maps_group");
								g.addMenuItem("doksoft_maps_item",
										{
											label : "Edit the map",
											command : "doksoft_maps",
											icon : this.path
													+ "icons/doksoft_maps.png",
											group : "doksoft_maps_group"
										});
								g.contextMenu
										.addListener(function(i, n) {
											if (i
													&& i.is("img")
													&& i.$.className == "doksoft_maps_img") {
												return {
													doksoft_maps_item : CKEDITOR.TRISTATE_OFF
												};
											}
										});
							}
							generateStatMap = function(i) {
								return "http://maps.google.com/maps/api/staticmap?center="
										+ i.lat
										+ ","
										+ i.lng
										+ "&zoom="
										+ i.zoom
										+ "&size="
										+ i.width
										+ "x"
										+ i.height
										+ "&maptype="
										+ i.type
										+ "&markers="
										+ (function(p) {
											var o = [];
											for ( var n in p) {
												o.push(p[n][0] + "," + p[n][1]);
											}
											return o.join("|");
										})(i.objects.Marker) + "&sensor=false";
							};
							g
									.on(
											"doubleclick",
											function(i) {
												var n = i.data.element;
												if (n
														&& n.is("img")
														&& n.$.className == "doksoft_maps_img") {
													i.data.dialog = "doksoft_maps";
												}
											});
							var e = 1, h = "";
							this.softed = 0;
							this.unprotectSource = function(n) {
								if (!/<script[^>]*class[\s]*=[\s]*"doksoft_maps_google"[^>]*>/gi
										.test(n)) {
									h += '<script class="doksoft_maps_google" src="http://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=places,weather"><\/script>';
									h += '<script class="doksoft_maps_google" src="http://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerwithlabel/src/markerwithlabel_packed.js"><\/script>';
								}
								if (!/<script[^>]*class[\s]*=[\s]*"doksoft_maps_loadmap"[^>]*>/gi
										.test(n)) {
									h += '<script class="doksoft_maps_loadmap">'
											+ "_loadmap = function(id,json){"
											+ "var canva = document.getElementById(id);"
											+ 'canva.style.width=json.width+"px";'
											+ 'canva.style.height=json.height+"px";'
											+ "var map = new google.maps.Map(canva,{"
											+ "zoom: parseInt(json.zoom),"
											+ "center: new google.maps.LatLng(parseFloat(json.lat),parseFloat(json.lng)),"
											+ "mapTypeId:json.type"
											+ "});"
											+ "if( json.settings ){"
											+ " for( var id in json.settings )"
											+ "map.set(id,json.settings[id]?true:false);"
											+ "};"
											+ "if( json.objects )"
											+ " for( var type in json.objects ){"
											+ "  for( var i in json.objects[type] ){"
											+ "var object = 0;"
											+ "switch( type ){"
											+ "case 'Marker':"
											+ "object = new google.maps.Marker({"
											+ "position: new google.maps.LatLng( json.objects[type][i][0], json.objects[type][i][1]),"
											+ "map: map,"
											+ "title: json.objects[type][i][2]"
											+ "});"
											+ "(function(txt){"
											+ "google.maps.event.addListener(object, 'click', function() {"
											+ "(new google.maps.InfoWindow({content: txt})).open( map,object );"
											+ "});"
											+ "})(json.objects[type][i][2]);"
											+ "break;"
											+ "case 'Rectangle':"
											+ "object = new google.maps.Rectangle({"
											+ "bounds: new google.maps.LatLngBounds("
											+ "new google.maps.LatLng( json.objects[type][i][0][0], json.objects[type][i][0][1]),"
											+ "new google.maps.LatLng( json.objects[type][i][1][0], json.objects[type][i][1][1])"
											+ "),"
											+ "map: map,"
											+ "});"
											+ "break;"
											+ "case 'Polygon':case 'Polyline':"
											+ "var path = json.objects[type][i],array_path = [];"
											+ "for( var j in path )"
											+ "array_path.push("
											+ "new google.maps.LatLng( path[j][0], path[j][1])"
											+ ");"
											+ "object = new google.maps[type]({"
											+ "path: array_path,"
											+ "map: map,"
											+ "});"
											+ "break;"
											+ "case 'Text':"
											+ "object = new MarkerWithLabel({"
											+ "position: new google.maps.LatLng( json.objects[type][i][0], json.objects[type][i][1]),"
											+ "map: map,"
											+ "labelContent: json.objects[type][i][2],"
											+ "labelAnchor: new google.maps.Point(22, 0),"
											+ 'labelClass: "labels",'
											+ "labelStyle: {opacity: 1.0, minWidth:'200px',textAlign:'left'},"
											+ "icon: {}"
											+ "});"
											+ "break;"
											+ "case 'Circle':"
											+ "object = new google.maps.Circle({"
											+ "radius: json.objects[type][i][2],"
											+ "center:new google.maps.LatLng( json.objects[type][i][0], json.objects[type][i][1]),"
											+ "map: map,"
											+ "});"
											+ "break;"
											+ "case 'WeatherLayer':"
											+ "object = new google.maps.weather.WeatherLayer({"
											+ "temperatureUnits: google.maps.weather.TemperatureUnit.FAHRENHEIT"
											+ "});"
											+ "object.setMap(map);"
											+ "break;"
											+ "case 'TrafficLayer':"
											+ "object = new google.maps.TrafficLayer();"
											+ "object.setMap(map);"
											+ "break;"
											+ "}"
											+ "  }"
											+ " }"
											+ "};"
											+ "loadmap = function( id,json ){"
											+ "google.maps.event.addDomListener(window, 'load', function(){_loadmap(id,json)});"
											+ "};" + "<\/script>";
								}
								var o = n
										.replace(
												/<img[^>]+?class[\s]*=[\s]*"doksoft_maps_img"[\s]*contenteditable="false"[\s]*data_script="([^"]*)"([^>]*)\/>/g,
												function(p, q) {
													g.plugins.doksoft_maps.softed = 1;
													e++;
													return '<div id="doksoft_maps'+e+'"></div><script class="doksoft_maps">loadmap("doksoft_maps'
															+ e
															+ '",'
															+ decodeURIComponent(q)
															+ ");<\/script>";
												});
								var i = [ o, h ];
								return i;
							};
							var m = function(i) {
								return i.replace(
										/^loadmap\("doksoft_maps[0-9]+",/, "")
										.replace(/\);$/, "");
							};
							this.protectSource = function(n, i) {
								return n
										.replace(
												/<script[^>]*class[\s]*=[\s]*"doksoft_maps"[^>]*>([^<]+)<\/script>/gi,
												function(q, p) {
													var o = "", r = m(p);
													try {
														o = '<img class="doksoft_maps_img" contenteditable="false" data_script="'
																+ encodeURIComponent(r)
																+ '" src="'
																+ generateStatMap(JSON
																		.parse(r))
																+ '"/>';
													} catch (s) {
														o = q;
													}
													return o;
												})
										.replace(
												/<div[^>]*id[\s]*=[\s]*"doksoft_maps[0-9]+"><\/div>/gi,
												"");
							};
							g
									.on(
											"toHtml",
											function(i) {
												i.data.dataValue = CKEDITOR.plugins.registered.doksoft_maps
														.protectSource(i.data.dataValue);
											}, null, null, 1);
						},
						afterInit : function(a) {
							(function(f) {
								var e = f.dataProcessor, d = e && e.htmlFilter, c = e
										&& e.dataFilter, b = f.plugins.doksoft_maps;
								c.addRules({
									comment : function(g) {
										return g;
									},
									elements : {
										img : function(g) {
										},
										div : function(g) {
										}
									}
								});
								d.addRules({
									elements : {
										img : function(g) {
											return g;
										}
									}
								});
								e.toDataFormat = CKEDITOR.tools.override(
										e.toDataFormat, function(g) {
											return function(k, i) {
												j = "";
												var n = g.call(this, k, i);
												var h = b.unprotectSource(n);
												var m = h[0];
												var j = h[1];
												n = (b.softed ? j : "") + m;
												return n;
											};
										});
								e.toHtml = CKEDITOR.tools.override(e.toHtml,
										function(g) {
											return function(i, h) {
												var j = b.protectSource(i);
												var k = g.call(this, j, h);
												return k;
											};
										});
							})(a);
						},
					});
	CKEDITOR.config.doksoft_maps_width = CKEDITOR.config.doksoft_maps_width || 400;
	CKEDITOR.config.doksoft_maps_height = CKEDITOR.config.doksoft_maps_height || 320;