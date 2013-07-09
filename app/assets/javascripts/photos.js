$(function() {
	Galleria.configure({
	  log: true,
	  assets: true
	})
	Galleria.run('#galleria');
		
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