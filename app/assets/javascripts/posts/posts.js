var search_term = "";
var category = "";
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

function searchActions(){
    $("#posts-search").keyup(function(event){
        if(event.keyCode == 13){

            var term = $(this).val();
            console.log(term);
            search_term = term;
            search(search_term, category);
        }
    });
    $(".category-label").click(function(){
        $(".category-label").each(function(){
            $(this).attr("class", "label label-default category-label");
        })
        $(this).attr("class", "label label-primary category-label");
        search (search_term, category);
    })
}

function search(term, category){
    $("#all-posts-container").html("");
    $.ajax({
      url:'/posts/search_posts/',
      type: "GET",
      data: {"term": term, "category": category},
      success:function(d){

        $("#all-posts-container").html(d);
        Mercury.trigger('reinitialize');
      },
      complete:function(){
      },
      error:function (xhr, textStatus, thrownError){}
  });
}