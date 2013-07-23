// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
// [OS] removed = require_tree .

// = require jquery
// = require jquery_ujs
// = require bootstrap/bootstrap-transition
// = require bootstrap/bootstrap-alert
// = require bootstrap/bootstrap-modal
// = require bootstrap/bootstrap-dropdown
// = require bootstrap/bootstrap-scrollspy
// = require bootstrap/bootstrap-tab
// = require bootstrap/bootstrap-tooltip
// = require bootstrap/bootstrap-popover
// = require bootstrap/bootstrap-button
// = require bootstrap/bootstrap-collapse
// = require bootstrap/bootstrap-carousel
// = require bootstrap/bootstrap-typeahead
// = require tokeninput/jquery.tokeninput
// = require galleria/galleria-1.2.9
// = require galleria/themes/local/galleria.local
// = require fraction

$(document).ready(function() {
  var rawhref = window.location.href; //raw current url 
  var newpage = ((window.location.href.match(/([^\/]*)\/?$/)[1]).substring(1)); //take only the last part of the url, and chop off the first char (substring), since the contains method below is case-sensitive. Don't need to do this if they match exactly.
  if (newpage == 'ndex') {  //deal with an exception literally
    newpage = 'ome'
    }
  if (rawhref.indexOf('somePartofURL') != -1) { //look for a consistent part of the path in the raw url to deal with variable urls, etc.
    newpage = "moreMatchingNavbarText"
    }
  $(".nav li").removeClass('active');
  $(".nav li a:contains('" + newpage + "')").parent().addClass('active'); //add the active class. Note that the contains method requires the goofy quote syntax to insert a variable.

});
