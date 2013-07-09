$(function() {

  // what page are we on?
  page= $(".this-page").attr("data-type"); 
  if (page == "all albums") {
    
    // iterate through the thumbs
    $(".album-thumb").map(function() {
      var self= $(this);
      var url= "https://picasaweb.google.com/data/feed/api/user/omid.sojoodi/album/" +
             self.attr("data-name") +
             '?&kind=photo&access=private&authkey=' +
             self.attr("data-authkey") + 
             '&max-results=1&thumbsize=200c&alt=json-in-script&callback=?';
      imgurl= "";
      $.getJSON(url, function(data) {
        imgurl= data.feed.entry[0].media$group.media$thumbnail[0].url;
        self.attr("src", imgurl);
      });
    });
  }
  
  // assume we're on a particular album page
  else {
    
    // get all the pictures for this album
    var url= "https://picasaweb.google.com/data/feed/api/user/omid.sojoodi/album/" +
           $("#galleria").attr("data-name") +
           '?&kind=photo&access=private&authkey=' +
           $("#galleria").attr("data-authkey") +
           '&full-exif=true&max-results=500&thumbsize=104u,1200u,1600u&alt=json-in-script&callback=?';
    
    // populate the pictures
    $.getJSON(url, function(data) {
      var img, picData= [], i=0;

      $.each( data.feed.entry, function() {
        img = this.media$group.media$thumbnail;
        exif= this.exif$tags;
        
        sTime= "?";
        if (exif.exif$time) {
          time= new Date(parseInt(exif.exif$time.$t))
          sTime= time.toString();
        }
        
        var desc= "Focal Length: " + (exif.exif$focallength ? exif.exif$focallength.$t : "?") + " mm f/" + 
                  (exif.exif$fstop ? exif.exif$fstop.$t : "?") + "<br>" +
                  "Exposure: " + (exif.exif$exposure ? exif.exif$exposure.$t : "?") + "s" + "<br>" +
                  "ISO: " + (exif.exif$iso ? exif.exif$iso.$t : "?") + "<br>" +
                  "Flash: " + (exif.exif$flash ? ((exif.exif$flash.$t == "true") ? "on" : "off") : "?") + "<br>" +
                  "Camera make: " + (exif.exif$make ? exif.exif$make.$t : "?") + "<br>" +
                  "Camera model: " + (exif.exif$model ? exif.exif$model.$t : "?") + "<br>" +
                  "Time: " + sTime; + "</div>"
        
        // populate the data
        picData[i++]= {thumb: img[0].url, 
                       image: img[1].url, 
                       big: img[2].url, 
                       title: this.media$group.media$title.$t, 
                       description: desc,
                       albumid: this.gphoto$albumid.$t,
                       photoid: this.gphoto$id.$t};
        });
         
      Galleria.configure({lightbox: true});
      Galleria.run('#galleria', {dataSource: picData});
    });
    Galleria.ready(function() {
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
          if (gallery) {
            var photoname= gallery.getData().title;
            var query= $("#galleria").attr("data-name") + ":" + photoname;
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
                  var nameLink= "<a href=\"/people/" + this.id + "\">" + this.name + "</a>";
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
        }
      });
    });
  }
});

/*    
  // draw box when the mouse enters a name
  $("body").on("mouseenter", ".pname", function() {

  });
  
  // hide when it leaves
  $("body").on("mouseleave", ".pname", function() {
    $("#facebox").css("display","none");
  });
*/
