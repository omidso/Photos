// = require tile.helper

$(function() {

  var albums= [];
  
  // get all the album thumbnails
  $.getJSON("/album/recent.json", function(results) {
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
});
