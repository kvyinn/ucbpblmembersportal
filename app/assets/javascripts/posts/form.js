function eventClickActions(){
    $(".event-check").click(function(){
         $(".event-check").each(function(){
            if($(this).hasClass("selected-event")){
                $(this).removeClass("selected-event");
            }
         });
         $(this).addClass("selected-event");
    });
}
function startAutocomplete(){
	$("#member-search").autocomplete({
		source: member_names,
		select: function(event, ui){
			// addToList(ui.item.value);
			// removeActions();
			addToList(ui.item.value);
			$(this).val("");
		}
	})
}
function addToList(name){
	var div = document.createElement("li");
	$(div).addClass("member-li");
	$(div).attr("id", member_hash[name]);
	$(div).text(name);
	$("#member-list").prepend(div);
	var oldval = $("#view-permissions").val();
	var newval = oldval + " " + member_hash[name];
	$("#view-permissions").val(newval);
}
$(document).ready(function() {
    startAutocomplete();
});