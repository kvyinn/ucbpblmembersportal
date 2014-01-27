
function getCalendar(month){
  $.ajax({
      url:'/posts/calendar/',
      type: "GET",
      data: {'month': month},
      success:function(data){
          $("#calendar").html("");
          $("#calendar").prepend(data);
          master_function();
      },
      complete:function(){},
      error:function (xhr, textStatus, thrownError){}
  });
}//end of get posts

function master_function(){
    jQuery('html,body').animate({scrollTop:0},0);
}

$(document).ready(function(){
  $(".month_button").click(function(){
    var month = $(this).attr("id");
    getCalendar(month);
  });
});