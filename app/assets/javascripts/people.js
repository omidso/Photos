// = require galleria.helper

$(function() {
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
});




