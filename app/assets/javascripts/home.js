$(function() {
  
  // iterate through the thumbs
  $(".album-thumb").map(function() {
    var self= $(this);
    var url= "https://picasaweb.google.com/data/feed/api/user/omid.sojoodi/album/" +
           self.attr("data-name") +
           '?&kind=photo&access=private&authkey=' +
           self.attr("data-authkey") + 
           '&max-results=1&thumbsize=640c&alt=json-in-script&callback=?';
    imgurl= "";
    $.getJSON(url, function(data) {
      imgurl= data.feed.entry[0].media$group.media$thumbnail[0].url;
      self.attr("src", imgurl);
    });
  });
  
});
 