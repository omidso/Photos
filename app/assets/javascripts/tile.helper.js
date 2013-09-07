var lastWidth= 0;

function processPage(piclist) {
  lastWidth= $("#rowholder").innerWidth()-9;
  $(".picrow").width(lastWidth);
  $(".picrow").children().remove();
  processAlbums(piclist);
}

function processAlbums(piclist)
{
  var divrows= $(".picrow");            // all the divrows
  var wrow= divrows.eq(0).innerWidth(); // get row width - this is fixed.
  var hrow= 220;                        // initial height - effectively the maximum height +/- 10%;
  var border= 5;                        // margin width
  
  // store relative widths of all images (scaled to match estimate height above)
  var ws= [];
  $.each(piclist, function(key, val) {
      var wt= val.width;
      var ht= val.height;
      if (ht!= hrow) { wt= Math.floor(wt * (hrow / ht)); }
      ws.push(wt);
  });

  // total number of images appearing in all previous rows
  var baseLine= 0, rowNum= 0; 
  var picsleft= ws.length;
  while (picsleft > 0)
  {
    // do we need to add a new row?
    if (rowNum == divrows.length) {
      $("#rowholder").append('<div class="picrow"></div>');
      $(".picrow").width(wrow-9);
      divrows= $(".picrow");
    }
    var divcurrow= divrows.eq(rowNum++);
    
    // empty the current row
    divcurrow.children().remove();
    
    // calculate width of images and number of images to view in this row.
    var tw= 0;       // total width of images in this row - including margins
    var rowcount= 0; // number of images appearing in this row 
    while((tw < wrow) && picsleft) {
      tw+= ws[baseLine + rowcount++] + (border * 2);
      picsleft--;
    }
    
    var ratio= 1, ht= 220;
    if (picsleft>0) {
      ratio= wrow / tw;                             // Ratio of actual width of row to total width of images to be used.
      ht= Math.min(hrow, Math.floor(hrow * ratio)); // new height is now original height * ratio
    } 
      
    var i= 0; // image number being processed
    tw= 0;    // reset total width to be total width of processed images        
    while (i < rowcount)
    {
      var pic= piclist[baseLine + i];              // Calculate new width based on ratio
      var wt= Math.floor(ws[baseLine + i] * ratio); // add to total width with margins
      (function() {
        var imgstr= '<div class=\"picimage\"' + pic.data + ' style=\"height:' + ht + 'px;width:' + wt + 'px;margin:' + border + 'px;background-image:url(' + pic.imageurl + ')\"></div>';
        var img= $(imgstr);
        var linkurl= pic.linkurl;
        img.click(function() {
            location.href= linkurl; 
          });
        divcurrow.append(img);
        img.append(pic.info);
        
        /*        
        img.on("mouseenter", (function() {
          $(".albuminfo", this).stop().animate({bottom:'60px'},{queue:false,duration:350}, 'bla');
        }));  
        img.on("mouseleave", (function() {
          $(".albuminfo", this).stop().animate({bottom:'0px'},{queue:false,duration:350}, 'easeinout');
        }));
        */
      })();
      tw+= wt + border * 2;
      i++;
    }
    
    // if total width is slightly smaller than actual div width then add 1 to each photo width till they match, unless last row
    i= 0;
    while ((tw < wrow) && (picsleft>0))
    {
      var img1= divcurrow.find(".picimage:nth-child(" + (i + 1) + ")");
      img1.width(img1.width() + 1);
      i= (i + 1) % rowcount;
      tw++;
    }
    // if total width is slightly bigger than actual div width then subtract 1 from each photo width till they match
    i= 0;
    while(tw > (wrow-9))
    {
      var img2= divcurrow.find(".picimage:nth-child(" + (i + 1) + ")");
      img2.width(img2.width() - 1);
      i = (i + 1) % rowcount;
      tw--;
    }
    
    // set row height to actual height + margins
    divcurrow.height(ht + border * 2);
    divcurrow.show();

    baseLine+= rowcount;
  }
  
  // if there are additional rows, hide them
  while (rowNum < divrows.length)
    divrows.eq(rowNum++).hide();
}

