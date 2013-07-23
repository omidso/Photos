function GalleriaDataFromJSON (json) 
{
  var i= 0, picData= [];
  $.each(json, function () {
    var photo= this;
    var desc= "<div> Focal Length: " + photo.focallength + " mm f/" + photo.fstop + "<br>" +
              "Exposure: " + photo.exposure + "s" + "<br>" +
              "ISO: " + photo.iso + "<br>" +
              "Flash: " + photo.flash + "<br>" +
              "Camera make: " + photo.make + "<br>" +
              "Camera model: " + photo.model + "<br></div>";
                    
    picData[i++]= {thumb: photo.thumburl, 
                   image: photo.url, 
                   big: photo.bigurl, 
                   title: photo.name,
                   description: desc,
                   photoid: photo.id,
                   albumid: photo.album_id};
    });
    
    return picData;
}

function GalleriaManageFaces()
{
  $('.galleria-info-faces').click(function() {
    if ($(this).attr('data-active')=="true") {
      $(this).css('background-color',"#000000");
      $(this).attr('data-active', false);
      $(".facebox").remove();
    }
    else {
      $(this).css('background-color',"#909e00");
      $(this).attr('data-active', true);
      var gallery= Galleria.get(0); 
      var query= gallery.getData().albumid + ":" + gallery.getData().photoid;
      $.getJSON("/photo/people.json", {q: query}, function(results) {
        if (results.people.length) {
          var i=0;
          $.each(results.people, function () {
            var lt, ll, w, h, sh, sw;
            var gh= gallery.getActiveImage().height;
            var gw= gallery.getActiveImage().width;
            var gx= gallery.getActiveImage().x;
            var gy= gallery.getActiveImage().y;
            
            if (results.orientation <= 1 || results.orientation == 3) {
              sw= gw/results.width;
              sh= gh/results.height;
              fw= results.faces[i].width * sw;
              fh= results.faces[i].height * sh;
              if (results.orientation <= 1) {
                // rotated 0 degrees
                lt= parseInt(gy + (results.faces[i].yloc * sw));
                ll= parseInt(gx + (results.faces[i].xloc * sh));
              }
              else {
                // rotated 180 degrees
                lt= ParseInt(gy + (gh - (fh + (results.faces[i].yloc * sh))));
                ll= ParseInt(gx + (gw - (fw + (results.faces[i].xloc * sw))));
              }
            }
            else if (results.orientation == 2 || results.orientation == 4) {
              sw= gw/results.height;
              sh= gh/results.width;
              fw= results.faces[i].height * sw;
              fh= results.faces[i].width * sh;
              if (results.orientation == 2) {
                // rotated 90 degrees (counter clockwise) or 270 degrees (clockwise)
                lt= parseInt(gy + (results.faces[i].xloc * sh));
                ll= parseInt(gx + (gw - (fw + (results.faces[i].yloc * sw))));
              }
              else {
                // rotated 270 degrees (counter clockwise) or 90 degrees (clockwise)
                lt= parseInt(gy + (gh - (fh + (results.faces[i].xloc * sh))));
                ll= parseInt(gx + (results.faces[i].yloc * sw));
              }
            }
            var nameLink= "<a href=\"/people/" + this.id + "/photos \">" + this.name + "</a>";
            var newDiv= "<div class=\"facebox\" style= \"width: " + fw + "px; height: " + fh + "px;" +
                        "top: " + lt + "px;" +
                        "left: " + ll + "px;\"" +
                        "><span class= \"label\" style=\"position: relative; top:-20px\">" + nameLink + "</span></div>";
                        
            $(".page-container").append(newDiv);
            i++;
          });
        }
      });            
    }
  });
}


