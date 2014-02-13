function sendActions(){
	$('#send-button').click(function(){
		var r = confirm('An email will be sent to all those listed. are you sure you want to continue?');
		if(r){
			sendEmails();
		}
	});

}
function sendEmails() {
	// look through all the members that were on your list and send all the ids to controller
	var member_ids = [];
	$(".member-email-li").each(function(){
		member_ids.push($(this).attr("id"));
	});
	$(document).empty();
	$.ajax({
      url:'/posts/send_emails/',
      type: "GET",
      data: {'member_ids': member_ids, 'post_id':post_id},
      success:function(data){
      },
      complete:function(){
      	window.location.href = '/posts/email_success'
      },
      error:function (xhr, textStatus, thrownError){}
  });

}
function addAllActions(){
	$("#add-all").click(function(){
		for(var i = 0;i<member_names.length;i++){
			addToList(member_names[i]);
		}
		removeActions();
	});
}
function addCurrentActions(){
	$("#add-current-cms").click(function(){
		for(var i = 0;i<current_cm_names.length;i++){
			addToList(current_cm_names[i]);
		}
		removeActions();
	});
}
function addToList(member_name) {
	var div = document.createElement("li");
	$(div).addClass("member-email-li");
	$(div).attr("id", member_hash[member_name]);
	$(div).text(member_name);
	$("#email-list").prepend(div);

}
function startAutocomplete(){
	$("#member-search").autocomplete({
		source: member_names,
		select: function(event, ui){
			addToList(ui.item.value);
			removeActions();
			$(this).val("");
		}
	})
}
function removeActions(){
	$(".member-email-li").click(function(){
		$(this).remove();
	});
}
$(document).ready(function(){
	addAllActions();
	startAutocomplete();
	addCurrentActions();
	removeActions();
	$("#clear-button").click(function(){
		$("#email-list").empty();
	});
	sendActions();
});