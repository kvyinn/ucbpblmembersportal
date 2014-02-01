var search_term = "";
var category = "";
function calendarActions(){
  $("#calendar-button").click(function(){
    jQuery('html,body').animate({scrollTop:0},0);
    $("#calendar-container").toggle();
  });
}
function scrollActions(){
  //scroll sidebar with the page
     var $sidebar   = $("#left-sidebar"),
        $window    = $(window),
        offset     = $sidebar.offset(),
        topPadding = 75;

    $window.scroll(function() {
        if ($window.scrollTop() > offset.top) {
            $sidebar.stop().animate({
                marginTop: $window.scrollTop() - offset.top + topPadding
            });
        } else {
            $sidebar.stop().animate({
                marginTop: 0
            });
        }
    });
}
function dbclickActions(){
	$(".post-content").dblclick(function(){
		$(this).attr("data-mercury",'markdown');
		var r = confirm("Would you like to editar this post?");
		if(r) {
			var id = $(this).attr("id");
			window.location.href = "/editor/posts/" + id;
		}
	});
}
function composeActions(){
  $("#compose-button").click(function(){
    window.location.href = "/posts/new";
  });
}
function searchActions(){
  $("#go-button").click(function(){
     var term = $("#posts-search").val();
    console.log(term);
    search_term = term;
    search(search_term, category);
  });


    // $("#posts-search").keyup(function(event){
    //     if(event.keyCode == 13){

    //         var term = $(this).val();
    //         console.log(term);
    //         search_term = term;
    //         search(search_term, category);
    //     }
    // });
    // var term = $(this).val();
    //         console.log(term);
    //         search_term = term;
    //         search(search_term, category);

}
function categoryActions(){
  $(".category-label").click(function(){
        $(".category-label").each(function(){
            $(this).attr("class", "nav-label label label-default category-label");
        })
        $(this).attr("class", "nav-label label label-primary category-label");
        category = $(this).attr("id");
    })
}
function showPostActions(){
  $('.show-more-link').click(function(){
      var parent_div = $(this).parent().parent();
     if($(parent_div).css("max-height") != "20000px")
     {
      $(parent_div).css("max-height", "20000px");
      $(this).text("show less");
     }
     else if($(parent_div).css("max-height") == "20000px")
    {
          $(parent_div).css('max-height', "150px");
          $(this).text("show more");
   }

  });
  // $(".post-div").click(function(){

  // });
}
function search(term, category){
  window.location = '/posts?term=' + term+"&category="+category;
  //   $("#all-posts-container").html("");

  //   $.ajax({
  //     url:'/posts/search_posts/',
  //     type: "GET",
  //     data: {"term": term, "category": category},
  //     success:function(d){

  //       $("#all-posts-container").html(d);
  //       Mercury.trigger('reinitialize');
  //       dbclickActions();
  //       scrollActions();
  //       searchActions();
  //       showPostActions();
  //     },
  //     complete:function(){
  //     },
  //     error:function (xhr, textStatus, thrownError){}
  // });
}