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

$(document).ready(function() {
    eventClickActions();
});