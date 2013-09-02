function GalleriaDataFromJSON(e){var t=0,a=[];return $.each(e,function(){var e=this,i="<div> Focal Length: "+e.focallength+" mm f/"+e.fstop+"<br>"+"Exposure: "+e.exposure+"s"+"<br>"+"ISO: "+e.iso+"<br>"+"Flash: "+e.flash+"<br>"+"Camera make: "+e.make+"<br>"+"Camera model: "+e.model+"<br></div>";a[t++]={thumb:e.thumburl,image:e.url,big:e.bigurl,title:e.name,description:i,photoid:e.id,albumid:e.album_id}}),a}function GalleriaManageFaces(){$(".galleria-info-faces").click(function(){if("true"==$(this).attr("data-active"))$(this).css("background-color","#000000"),$(this).attr("data-active",!1),$(".facebox").remove();else{$(this).css("background-color","#4b698c"),$(this).attr("data-active",!0);var e=Galleria.get(0),t=e.getData().albumid+":"+e.getData().photoid;$.getJSON("/photo/people.json",{q:t},function(t){if(t.people.length){var a=0;$.each(t.people,function(){var i,o,r,n,h=e.getActiveImage().height,c=e.getActiveImage().width,l=e.getActiveImage().x,s=e.getActiveImage().y;t.orientation<=1||3==t.orientation?(n=c/t.width,r=h/t.height,fw=t.faces[a].width*n,fh=t.faces[a].height*r,t.orientation<=1?(i=parseInt(s+t.faces[a].yloc*n),o=parseInt(l+t.faces[a].xloc*r)):(i=ParseInt(s+(h-(fh+t.faces[a].yloc*r))),o=ParseInt(l+(c-(fw+t.faces[a].xloc*n))))):(2==t.orientation||4==t.orientation)&&(n=c/t.height,r=h/t.width,fw=t.faces[a].height*n,fh=t.faces[a].width*r,2==t.orientation?(i=parseInt(s+t.faces[a].xloc*r),o=parseInt(l+(c-(fw+t.faces[a].yloc*n)))):(i=parseInt(s+(h-(fh+t.faces[a].xloc*r))),o=parseInt(l+t.faces[a].yloc*n)));var p='<a href="/people/'+this.id+'/photos ">'+this.name+"</a>",d='<div class="facebox" style= "width: '+fw+"px; height: "+fh+"px;"+"top: "+i+"px;"+"left: "+o+'px;"'+'><span class= "label" style="position: relative; top:-20px">'+p+"</span></div>";$(".page-container").append(d),a++})}})}})}function processPage(e){lastWidth=$("#rowholder").innerWidth()-9,$(".picrow").width(lastWidth),$(".picrow").children().remove(),processAlbums(e)}function processAlbums(e){var t=$(".picrow"),a=t.eq(0).innerWidth(),i=220,o=5,r=[];$.each(e,function(e,t){var a=t.width,o=t.height;o!=i&&(a=Math.floor(a*(i/o))),r.push(a)});for(var n=0,h=0,c=r.length;c>0;){h==t.length&&($("#rowholder").append('<div class="picrow"></div>'),$(".picrow").width(a-9),t=$(".picrow"));var l=t.eq(h++);l.children().remove();for(var s=0,p=0;a>s&&c;)s+=r[n+p++]+2*o,c--;var d=1,f=220;c>0&&(d=a/s,f=Math.min(i,Math.floor(i*d)));var u=0;for(s=0;p>u;){var g=e[n+u],v=Math.floor(r[n+u]*d);!function(){var e='<div class="picimage"'+g.data+' style="height:'+f+"px;width:"+v+"px;margin:"+o+"px;background-image:url("+g.imageurl+')"></div>',t=$(e),a=g.linkurl;t.click(function(){location.href=a}),l.append(t),t.append(g.info)}(),s+=v+2*o,u++}for(u=0;a>s&&c>0;){var m=l.find(".picimage:nth-child("+(u+1)+")");m.width(m.width()+1),u=(u+1)%p,s++}for(u=0;s>a-9;){var w=l.find(".picimage:nth-child("+(u+1)+")");w.width(w.width()-1),u=(u+1)%p,s--}l.height(f+2*o),l.show(),n+=p}for(;h<t.length;)t.eq(h++).hide()}function GetPeopleAndProcess(e){people=[],$.getJSON(e,function(e){$.each(e,function(){var e=this.person,t=this.count;t>0&&e.url&&people.push({imageurl:e.url,width:e.urlwidth,height:e.urlheight,info:'<div class="picinfo">'+e.name+"<br>"+t+"</div>",linkurl:"/people/"+e.id+"/photos",data:""})}),processPage(people)})}function SortByCount(){GetPeopleAndProcess("/people_by_photo_count.json")}function SortByName(){GetPeopleAndProcess("/people_by_name.json")}var lastWidth=0,gCurSort="count",people=[];$(function(){if(page=$(".this-page").attr("data-type"),"all people"==page)gCurSort="count",SortByCount(),$(window).resize(function(){var e=$("#rowholder").innerWidth();(lastWidth>e||e>lastWidth)&&processPage(people)}),$("#alpha").click(function(){"alpha"!=gCurSort&&(gCurSort="alpha",SortByName())}),$("#count").click(function(){"count"!=gCurSort&&(gCurSort="count",SortByCount())});else{var e=$(".this-page").attr("data-id"),t=[];$.getJSON("/person/photos.json",{id:e},function(e){$.each(e,function(){var e=this;t.push({imageurl:e.thumburl,width:e.width,height:e.height,info:'<div class="picinfo">'+e.name+"</div>",linkurl:"/photos/"+e.id,data:" data-name="+e.onlinename+" data-authkey="+"auth"})}),processPage(t)}),$(window).resize(function(){var e=$("#rowholder").innerWidth();(lastWidth>e||e>lastWidth)&&processPage(t)})}});