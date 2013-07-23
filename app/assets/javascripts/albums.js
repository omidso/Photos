// = require galleria.helper
// = require tile.helper

$(function() {

  // what page are we on?
  page= $(".this-page").attr("data-type"); 
  if (page == "all albums") {
    var albums= [];
    
    // get all the album thumbnails
    $.getJSON("/albums.json", function(results) {
      $.each(results, function () {
        var album= this;

        albums.push({imageurl: album.url,
                     width: album.urlwidth,
                     height: album.urlheight,
                     info: '<div class=\"picinfo\">' + album.name + '<br>' + album.albumdatestr + '</div>',
                     linkurl: "/albums/" + album.id,
                     data: ' data-name=' + album.onlinename + ' data-authkey=' + album.authkey});
      });
      processPage(albums);
    });

    $(window).resize(function() { 
      var nowWidth= $("#rowholder").innerWidth();
        
      // test to see if the window resize is big enough to deserve a reprocess
      if ((nowWidth < lastWidth) || (nowWidth > lastWidth))
        processPage(albums);
    });
    
  }
 
  // assume we're on a particular album page
  else {
    var id= $("#galleria").attr("data-id");
    $.getJSON("/album/photos.json", {id: id}, function(results) {
      if (results.length) {
        picData= GalleriaDataFromJSON(results);
        //Galleria.configure({lightbox: true});
        Galleria.configure({trueFullscreen: false,
                            lightbox: true});
        Galleria.run('#galleria', {dataSource: picData});
        
        Galleria.ready(function() {
          GalleriaManageFaces();
        });
      }
    });
  }
});