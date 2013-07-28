// = require galleria.helper
// = require tile.helper

var gCurSort= "count";
var people= [];

function GetPeopleAndProcess(url)
{
  people= [];
  $.getJSON(url, function(results) {
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
}

function SortByCount() {
  GetPeopleAndProcess("/people_by_photo_count.json");
} 

function SortByName() {
  GetPeopleAndProcess("/people_by_name.json");  
}

$(function() {
  
  page= $(".this-page").attr("data-type"); 
  if (page == "all people") {
    
    gCurSort= "count";
    SortByCount();
    
    $(window).resize(function() { 
      var nowWidth= $("#rowholder").innerWidth();
        
      // test to see if the window resize is big enough to deserve a reprocess
      if ((nowWidth < lastWidth) || (nowWidth > lastWidth))
        processPage(people);
    });
    
    // attach the sort buttons
    $("#alpha").click(function() {
      if (gCurSort != "alpha") {
        gCurSort= "alpha"
        SortByName();
      }
    });
    $("#count").click(function() {
      if (gCurSort != "count") {
        gCurSort= "count"
        SortByCount();
      }
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
