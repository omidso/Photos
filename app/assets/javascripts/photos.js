$(function() {
	Galleria.configure({
	  log: true,
	  assets: true
	})
	Galleria.run('#galleria');
		
	// var picasa= new Galleria.Picasa();
	//picasa.setOptions({max: 20, thumbSize: 'medium'}).search('birds', function(data) {Galleria.get(0).load(data);});
	
	// show the gallery
	//$("#oGallery").galleryView({
//	  panel_scale: 'fit',
	  //panel_style: 'track',
	  //panel_width: 800,
    //panel_height: 500,
    //frame_width: 55,
    //enable_overlays: true,
    //show_filmstrip_nav: false,
    //infobar_opacity: 0.75,
    //easing: 'linear',
    //start_frame: 1
	//});
	
	// draw box when the mouse enters a name
	$("body").on("mouseenter", ".pname", function() {

		// figure out the current scaling factors
		var scale_width= Galleria.get(0).getActiveImage().width/Galleria.get(0).getActiveImage().naturalWidth;
		var scale_height= Galleria.get(0).getActiveImage().height/Galleria.get(0).getActiveImage().naturalHeight;
		
		// get the face information, scaling as required & convert to string
		var xloc= parseInt(Galleria.get(0).getActiveImage().x + ($(this).attr("data-xloc") * scale_width)) + "px";
		var yloc= parseInt(Galleria.get(0).getActiveImage().y + ($(this).attr("data-yloc") * scale_height)) + "px";
		var width= parseInt($(this).attr("data-width") * scale_width) + "px";
		var height= parseInt($(this).attr("data-height") * scale_height) + "px";
		
		// move the facebox
    	$("#facebox").css({"width":width, "height":height, "top":yloc, "left":xloc, "display":"block"});
	});
	
	// hide when it leaves
	$("body").on("mouseleave", ".pname", function() {
		$("#facebox").css("display","none");
	});
	
});