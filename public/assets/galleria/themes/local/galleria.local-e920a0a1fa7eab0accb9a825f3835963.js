!function(t){Galleria.addTheme({name:"local",author:"Galleria",css:"galleria.local.css",defaults:{transition:"slide",thumbCrop:"height",_toggleInfo:!0},init:function(i){Galleria.requires(1.28,"This version of local theme requires Galleria 1.2.8 or later"),this.addElement("info-link","info-close"),this.append({info:["info-link","info-close"]}),this.addElement("info-faces"),this.append({stage:["info-faces"]}),this.$("info-faces").attr("data-active",!1),this.bind("loadfinish",function(){t(".facebox").remove(),"true"==this.$("info-faces").attr("data-active")&&this.$("info-faces").click()});var e=this.$("info-link,info-close,info-text"),a=Galleria.TOUCH,o=a?"touchstart":"click";this.$("loader,counter").show().css("opacity",.7),a||(this.addIdleState(this.get("image-nav-left"),{left:-50}),this.addIdleState(this.get("image-nav-right"),{right:-50}),this.addIdleState(this.get("counter"),{opacity:0})),i._toggleInfo===!0?e.bind(o,function(){e.toggle()}):(e.show(),this.$("info-link, info-close").hide()),this.bind("thumbnail",function(i){a?t(i.thumbTarget).css("opacity",this.getIndex()?1:.6):(t(i.thumbTarget).css("opacity",.6).parent().hover(function(){t(this).not(".active").children().stop().fadeTo(100,1)},function(){t(this).not(".active").children().stop().fadeTo(400,.6)}),i.index===this.getIndex()&&t(i.thumbTarget).css("opacity",1))}),this.bind("loadstart",function(i){i.cached||this.$("loader").show().fadeTo(200,.4),this.$("info").toggle(this.hasInfo()),t(i.thumbTarget).css("opacity",1).parent().siblings().children().css("opacity",.6)}),this.bind("loadfinish",function(){this.$("loader").fadeOut(200)})}})}(jQuery);