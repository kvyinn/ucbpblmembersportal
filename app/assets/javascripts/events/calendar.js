
function getCalendar(month){
  $.ajax({
      url:'/events/calendar/',
      type: "GET",
      data: {'month': month},
      success:function(data){
          $("#calendar").html("");
          $("#calendar").prepend(data);
      },
      complete:function(){},
      error:function (xhr, textStatus, thrownError){}
  });
}//end of get posts


$(document).ready(function(){
  $(".month_button").click(function(){
    var month = $(this).attr("id");
    getCalendar(month);
  });
});