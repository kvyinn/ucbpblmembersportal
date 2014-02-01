function scrollActions(){
  //scroll sidebar with the page
     var $sidebar   = $("#posts-container"),
        $window    = $(window),
        offset     = $sidebar.offset(),
        topPadding = 0;

    // $window.scroll(function() {
        // if ($window.scrollTop() > offset.top) {
            $sidebar.animate({
                marginTop: $window.scrollTop()+topPadding
            // });
        // } else {
            // $sidebar.stop().animate({
                // marginTop: 0
            });
        // }
    // });
}

function showPostActions(){
	$(".event-row").click(function(){
		// alert($(this).attr("id"));
		// $("#posts-container").empty();
		getPosts($(this).attr("id"));
	});
}

function getPosts(id){
	$.ajax({
      url:'/events/get_posts/'+id,
      type: "GET",
      data: {},
      success:function(d){
      	  $("#posts-container").empty();
      	  $("#posts-container").append(d);
      	  if(d == ""){
      	  	$("#posts-container").append('<h2>There are no blogposts for that</h2>');
      	  }
      	  scrollActions();
      },
      complete:function(){
      },
      error:function (xhr, textStatus, thrownError){}
  });
}

$(document).ready(function(){
	scrollActions();
	showPostActions();
});