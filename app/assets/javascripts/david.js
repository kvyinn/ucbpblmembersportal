$(document).ready(function(){
	$("#navlist li").hover(function(){
		$(this).addClass("active");
	}, function(){
		if(!$(this).hasClass("logo"))
			$(this).removeClass("active");
	});
});