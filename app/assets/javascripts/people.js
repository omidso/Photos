// = require galleria.helper
// = require tile.helper

$(function() {
  
  page= $(".this-page").attr("data-type"); 
  if (page == "all people") {
    var people= [];
    
    // get all the album thumbnails
    $.getJSON("/people_by_photo_count.json", function(results) {
      $.each(results, function () {
        var person= this.person;
        var count= this.count;
        
        if (count>0 && person.url)
          people.push({imageurl: person.url,
                       width: person.urlwidth,
                       height: person.urlheight,
                       info: '<div class=\"picinfo\">' + person.name + '<br>' + count + '</div>',
                       linkurl: "/people/" + person.id + "/photos",
                       data: ""});
      });
      processPage(people);
    });
    
    $(window).resize(function() { 
      var nowWidth= $("#rowholder").innerWidth();
        
      // test to see if the window resize is big enough to deserve a reprocess
      if ((nowWidth < lastWidth) || (nowWidth > lastWidth))
        processPage(people);
    });
    
    /*$("#peopletable").tablesorter({headers: {0: {sorter:false}},
                                   widgets: ['zebra'],
                                   sortList: [[2,1]]});*/
  }
  else {
    var person= $("#galleria").attr("data-name");
    $.getJSON("/person/photos.json", {q: person}, function(results) {
      if (results.length) {
        picData= GalleriaDataFromJSON(results);
        Galleria.configure({lightbox: true});
        Galleria.run('#galleria', {dataSource: picData});
      }
    });
    
    Galleria.ready(function() {
      GalleriaManageFaces();
    });
  }
});
