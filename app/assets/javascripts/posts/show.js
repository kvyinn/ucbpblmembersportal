function addCommentActions(){
	$("#add-comment-button").click(function(){
		var comment = $("#comment-textarea").val();
		addComment(comment);
	});
}
function addComment(comment){
	$.ajax({
      url:'/posts/add_comment/',
      type: "GET",
      data: {'post_id': post_id, 'content':comment},
      success:function(data){
      },
      complete:function(){
      	location.reload();
      },
      error:function (xhr, textStatus, thrownError){}
  });
}
$(document).ready(function(){
	addCommentActions();
});