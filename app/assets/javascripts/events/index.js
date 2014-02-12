

function calendarViewClickActions(){
	$("#calendar-view-button").click(function(){
		$("#calendar").toggle();
		if($(this).text() == "Hide Calendar View"){
			$(this).text("Show Calendar View");
		}
		else{
			$(this).text("Hide Calendar View");
		}
	});
}
function listViewClickActions(){
	$("#list-view-button").click(function(){
		$('html, body').animate({
	        scrollTop: $("#upcoming_events_table").offset().top -150
	    }, 513);
	});

}
$(document).ready(function(){
	calendarViewClickActions();
	listViewClickActions();
});