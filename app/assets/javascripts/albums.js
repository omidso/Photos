$(function() {

  //Galleria.run("#galleria");
    
  defaults= {
    picasaUrl: "https://picasaweb.google.com/data/feed/api/user/",
    userName: "omid.sojoodi",
    album: "20100916Lisbon03",
    authKey: "Gv1sRgCNbMz93l0pW4wgE",
    photoSize: 1600,
    thumbSize: "104u,640u,1280u",
    maxResults: 200
  };
  
  settings= {};
  
  var url= defaults.picasaUrl + 
           defaults.userName +
           '/album/' +
           ((settings.album) ? settings.album : defaults.album) +
           '?&kind=photo&access=private&authkey=' +
           ((settings.authKey) ? settings.authKey : defaults.authKey) +
           '&max-results=' +
           ((settings.maxResults) ? settings.maxResults : defaults.maxResults) +
           '&thumbsize=' +
           ((settings.thumbSize) ? settings.thumbSize : defaults.thumbSize) +
           '&alt=json-in-script&callback=?';
           
        $.getJSON(url, function(data) {
          var img, picData= [], i=0;

          $.each( data.feed.entry, function() {
            img = this.media$group.media$thumbnail;
            picData[i++]= {thumb: img[0].url, image: img[1].url, big: img[2].url, title: this.media$group.media$title.$t};
          });
          
          Galleria.run('#galleria', {dataSource: picData});
        });
});
  //Galleria.run('#galleria');

/*    
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
*/
