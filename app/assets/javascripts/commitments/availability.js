var clicking = false;
var slots = {};
slots["0"] = [];
slots["1"] = [];
slots["2"] = [];
slots["3"] = [];
slots["4"] = [];
slots["5"] = [];
slots["6"] = [];
function drawDays(){
	var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
	var hours = ["8", "9", "10", "11", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"];
	for(var i=0;i<days.length;i++){
		var day_div = document.createElement("div");
		$(day_div).addClass("day");
		$(day_div).attr("id", (i).toString());
		// $(day_div).text(days[i]);
		var header = document.createElement("div");
		$(header).addClass("header");
		$(header).text(days[i]);
		$(day_div).append(header);
		for(var j=0;j<hours.length-1;j++){
			var hour = document.createElement("div");
			$(hour).addClass("hour");
			$(hour).attr("id", j+8);
			$(hour).text(hours[j]+" - "+hours[j+1]);
			$(day_div).append(hour);
		}
		$("#times").append(day_div);
	}
}
function hourActions(){
	$(".hour").click(function(){
		toggleSelected($(this));
	});
}
function markSlots(marked_slots){
	for(var i=0;i<7;i++){
		var key = i;
		for(var j=0;j<marked_slots[key].length;j++){
			hour = marked_slots[key][j];
			var h = $("#"+key+" "+"#"+hour);
			toggleSelected(h);
		}
	}
}
function toggleSelected(thiss){

	if(! $(thiss).hasClass("selected")){
		$(thiss).addClass("selected");
		$(thiss).css("background-color", "rgb(129, 129, 127)");
		var d = $(thiss).parent().attr("id");
		var h = $(thiss).attr("id");
		slots[d].push(h);
	}
	else{
		$(thiss).css("background-color", "white");
		$(thiss).removeClass("selected");
		// remove this hour from slots
		var d = $(thiss).parent().attr("id");
		var h = $(thiss).attr("id");
		var index = slots[d].indexOf(h);
		if(index>-1){
			slots[d].splice(index,1);
		}
	}
}
function clickingActions(){
	$(".hour").mousedown(function(){
		clicking = true;
		toggleSelected($(this));
	});
	$(".hour").on("mouseover", function(){
		if(clicking == true){
			toggleSelected($(this));
		}
	});
	$(document).mouseup(function(){
		clicking = false;
	});
}
function submitCommitments(){
	alert("submitting your availability...hold onto your potatoes");
	$.ajax({
      url:'/commitments/update_availability',
      type: "GET",
      data: {"slots": slots},
      success:function(data){
      },
      complete:function(){
      	location.reload();
      },
      error:function (xhr, textStatus, thrownError){}
  });
}
$(document).ready(function(){
	drawDays();
	hourActions();
	clickingActions();
	$("#save_commitments").click(function(){
		submitCommitments();
	});
	if(marked_slots){
		markSlots(marked_slots);
	}
});