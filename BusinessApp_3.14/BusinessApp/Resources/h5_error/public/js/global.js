$(".page").last().css("visibility","visible");
document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
JH.title.unshift($("title").text());
window.addEventListener('orientationchange', function(event){ 
	if ( window.orientation == 180 || window.orientation==0 ) { 
		var phoneWidth = window.screen.width;
		if(phoneWidth>414){
			var phoneScale = (phoneWidth/3)/750;
		}else{
			var phoneScale = phoneWidth/750;
		}
		$("meta[name='viewport']").attr("content","width=750, minimum-scale = "+phoneScale+", maximum-scale = "+phoneScale);
	} 
	if( window.orientation == 90 || window.orientation == -90 ) { 
		var phoneWidth = window.screen.height;
		if(phoneWidth>750){
			var phoneScale = (phoneWidth/3)/750;
		}else{
			var phoneScale = phoneWidth/750;
		}
		$("meta[name='viewport']").attr("content","width=750, minimum-scale = "+phoneScale+", maximum-scale = "+phoneScale);
	}
});
$("body").on("click","a",function(e){
	e.preventDefault();
});
$("body").on("tap","a",function(){
	var eff = "slideInRight";
	if($(this).attr("href") != "" && $(this).attr("href") != "#" && window.location.href.split( "/" )[ window.location.href.split( "/" ).length-1 ] != $(this).attr("href")){
		if($(this).attr("data-page") == "page"){
			JH.load.page($(this).attr("href"));
		}else if($(this).attr("data-page") == "new"){
			if($(this).attr("data-eff")!="undefined"){
				 eff = $(this).attr("data-eff");
			}
			JH.load.new($(this).attr("href"),eff);
		}else{
			window.location.href = $(this).attr("href");
		}
	}
});
window.onpopstate = function(event){
	var pageurl = window.location.href.split( "/" )[ window.location.href.split( "/" ).length-1 ];
	JH.back = true;
	if(JH.pageurl!=pageurl&&$(".page").length==1){
		JH.load.page(pageurl);
	}else if($(".page").length>1){
		JH.load.newclose({state:event.state,suc:function(){
			if(JH.pageurl!=pageurl&&$(".page").length==1){
				JH.load.page(pageurl);
			}
			JH.closesuc();
		}});
	}
};