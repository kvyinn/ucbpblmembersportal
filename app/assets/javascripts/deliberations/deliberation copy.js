var graph_data = "nothing";
var global_svg = "";
var width = 1100,
    	height = 600;
var global_force = "";
var global_data = "";
var global_data_exists = false;
var current_data = "";
var deliberation_links = "";
var deliberation_data = "";
var unsure_data = "";

function dblclick(d) {
  d3.select(this).classed("fixed", d.fixed = false);
}

function dragstart(d) {
  d3.select(this).classed("fixed", d.fixed = true);
}
function toggleColors(choice){
	if (choice == "applicant")
	{
		global_svg.selectAll(".link")
	      .data(graph_data.links)
	      .style("stroke-width", "1px" )
	      .style("stroke", function(d){
	      	return d["color2"];
	      });
	}
	else{
		global_svg.selectAll(".link")
	      .data(graph_data.links)
	      .style("stroke-width", "1px" )
	      .style("stroke", function(d){
	      	return d["color"];
	      });
	}
}
function toggleChargeDistance(charge, distance){
	do_pretty(global_data, distance, charge);
	    // .size([width, height]);
}
function toggleApplicants(hide){
	if(hide){
		//remove links that are yellow
		links = current_data["links"].slice(0);
		for (var i=0;i<links.length;i++){
			if(links[i]["color"]=="yellow"){
				links.splice(i,1);
				i--;
			}
		}
		new_graph_data = {};
		nodes = current_data["nodes"].slice(0);
		new_graph_data["nodes"] = nodes;
		new_graph_data["links"] = links;
		do_pretty(new_graph_data, linkDistance,linkCharge);
		console.log("did pretty");
		console.log(new_graph_data);
	}
	else{
		do_pretty(global_data, linkDistance, linkCharge);
	}
}
function toggleDeliberations(assignments, unsure, show_unsure)
{
	nodes = global_data["nodes"].slice(0);
	links = global_data["links"].slice(0);
	original_nodes = global_data["nodes"];
	keep_links = [];
	console.log(nodes);
	console.log(links);
	index = 0;
	for (var i=0;i<links.length;i++){
		index++;
		l = links[i];
		committee_name = l["source2"]
		applicant_node = l["target2"]
		applicant = applicant_node["value"].id;
		console.log(applicant);
		if(assignments[committee_name].indexOf(applicant) == -1){
			// console.log(assignments[committee_name]);
			if(!show_unsure || unsure[committee_name].indexOf(applicant) == -1)
			{
				links.splice(i, 1);
				i--;
			}
			else{
				//you were just unsure about this candidate
				links[i]["color"] = "gray";
			}

		}

	}
	new_graph_data = {};
	new_graph_data["nodes"] = nodes;
	new_graph_data["links"] = links;
	console.log(new_graph_data);
	// console.log(graph_data);
	do_pretty(new_graph_data, linkDistance,linkCharge);
	//toggleCommittees(["Consulting"]);
}
function toggleCommittees(committees){
	nodes = global_data["nodes"].slice(0);
	links = global_data["links"].slice(0);
	original_nodes = global_data["nodes"];
	keep_links = [];
	console.log(nodes);
	console.log(links);
	index = 0;
	for (var i=0;i<nodes.length;i++){
		index++;
		n = nodes[i];
		if(committees.indexOf(n["value2"]) != -1){
			//donothing
		}
		else{
			if(n["type"] == "committee")
			{
				nodes.splice(i, 1);
				i--;
			}
		}
	}
	for (var i=0;i<links.length;i++){
		index++;
		l = links[i];
		if(committees.indexOf(l["source2"]) != -1){
			//donothing
		}
		else{
				links.splice(i, 1);
				i--;
		}
	}
	new_graph_data = {};
	new_graph_data["nodes"] = nodes;
	new_graph_data["links"] = links;
	console.log(new_graph_data);
	console.log(graph_data);
	do_pretty(new_graph_data, linkDistance,linkCharge);
	//toggleCommittees(["Consulting"]);
}

function do_pretty(d, dist, charge){
	if($("#d3_area") != null){
	  	$("#d3_area").remove();
	  	$(".node").each($(this).remove());
	  	$(".link").each($(this).remove());
	  }
	graph = d;
	current_data = graph;
	if (!global_data_exists){
		global_data = graph;
		global_data_exists = true;
	}
	var color = d3.scale.category20();
	var force = d3.layout.force()
	    .charge(charge)
	    .linkDistance(dist)
	    .size([width, height]);
	global_force = force;
	var svg = d3.select("body").append("svg")
	    .attr("width", width)
	    .attr("height", height)
	    .attr("id", "d3_area");

	// d3.json("/deliberations/data", function(error, graph) {
	  	force
	      .nodes(graph["nodes"])
	      .links(graph["links"])
	      .start();
	 var drag = force.drag()
    	.on("dragstart", dragstart);

	  var link = svg.selectAll(".link")
	      .data(graph.links)
	    .enter().append("line")
	      .attr("class", "link")
	      .attr("id", function(d){ return d["id"];})
	      .attr("title", function(d){ return d["message"];})
	      .style("cursor", "pointer")
	      .style("stroke-width", "1px" )
	      .style("stroke", function(d){
	      	return d["color"];
	      });

	  link.append("title")
	      .text(function(d) {
	      	   var str = "rank: ";
	      	   str+=d["rank"];
	      	   str+=" "+d["notes"];
	      	   return str;
	      });
	  var node = svg.selectAll(".node")
	      .data(graph.nodes)
	    .enter().append("g")
	      .attr("class", "node")
	      .attr("id", function(d){
	      	if(d["type"] != "committee"){
	      		return d["value"].name;
	      	}
	      	return d["value"];
	      })
	      .on("dblclick", dblclick)
	      .call(drag);
	  node.append("circle")
	  	  .attr("class", "node_circle")
	      .attr("r", function(d){
	      	return parseInt(d["size"]);
	      })
	      .style("fill", function(d) { return d["color"]; })

	  node.append("title")
	      .text(function(d) {

	      		if(d["type"]=="committee"){
	      			return d["value"];
	      		}
	      		else{
	      			return d["value"].name;
	      		}
	      });
	  node.append("text")
        .attr("dx", -20)
      	.attr("dy", ".35em")
      	.attr("class", "node_text")
        .text(function(d){
        	if(d["type"]=="committee"){
	      			return d["value"];
	      		}
	      		else{
	      			return d["value"].name;
	      		}
        })
	  force.on("tick", function() {
	    link.attr("x1", function(d) { return d["source"].x; })
	        .attr("y1", function(d) { return d["source"].y; })
	        .attr("x2", function(d) { return d["target"].x; })
	        .attr("y2", function(d) { return d["target"].y; });

	    node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
	    // node.attr("cx", function(d) { return d.x; })
	    //     .attr("cy", function(d) { return d.y; });
	  });
	// });
	graph_data = graph;
	editingSetup();
	global_svg = svg;

}
function editingSetup(){
	$(".link").click(function(){
		var r = confirm("are you sure you want to delete this edge?");
		if (r){

			var id = $(this).attr("id");
			var old = $("#removed_edges").html();
			var new_val = id+" "+old;
			$("#removed_edges").html(new_val);

			var msg = $(this).attr("title");
			var div = document.createElement("div");
			$(div).text(msg);
			$("#activity_log").prepend(div);
			$(this).remove();
		}
	});
}
function getDelibLinks(delib_id2, show_unsure){
	var delib_id = $("#holder").attr("title");
	if($("#d3_area") != null){
	  	$("#d3_area").remove();
	  	$(".node").each($(this).remove());
	  	$(".link").each($(this).remove());
	  }
	 $.ajax({
      url:'/deliberate/links/'+delib_id,
      type: "GET",
      data: {},
      success:function(d){
      	  console.log("i returned results");
          console.log(d);

          deliberation_data = d[0];
          unsure_data = d[1];
          // do_pretty(deliberation_data, linkDistance, linkCharge);
          // toggleDeliberations(deliberation_data, unsure_data, show_unsure);
      },
      complete:function(){
      	// alert("complete");
      },
      error:function (xhr, textStatus, thrownError){}
  });
}
function getData(exclude_string, dist, charge){
  var data = "asdf"
  var delib_id = $("#holder").attr("title");
  if($("#d3_area") != null){
  	$("#d3_area").remove();
  	$(".node").each($(this).remove());
  	$(".link").each($(this).remove());
  }
  $.ajax({
      url:'/deliberations/data/',
      type: "GET",
      data: {"exclude": exclude_string, "deliberation_id": delib_id},
      success:function(d){
          console.log(d);
          data = d;
          do_pretty(data, dist, charge);
          graph_data = data;
          // global_data = d;
      },
      complete:function(){},
      error:function (xhr, textStatus, thrownError){}
  });
  console.log('this is returned data');
  console.log(data);

}//end of get data
var linkDistance = 50;
var linkCharge = -200;
$(document).ready(function(){
	$("#link_charge_input").val(linkCharge.toString());
	$("#link_distance_input").val(linkDistance.toString());
	$(".commitee_checkbox").each(function(){
		$(this).prop('checked', true);
	})
	getData("2", linkDistance, linkCharge);
	getDelibLinks("asdf", true);
	$(".commitee_checkbox").on("change",function(){
		// var exclude_string = "";
		var committees = [];
		$(".commitee_checkbox").each(function(){
			if($(this).prop("checked")){
				// exclude_string += $(this).attr("id")+" ";
				committees.push($(this).attr("id"));
			}
		});
		// getData(exclude_string, linkDistance, linkCharge);
		toggleCommittees(committees);
	});
	$("#hide_applicants").on("change", function(){
		if($(this).prop("checked")){
			toggleApplicants(true);
		}
		else{
			toggleApplicants(false);
		}
	});
	$("#applicant_search").keyup(function(event){
	    if(event.keyCode == 13){
	        $(".node").each(function(){
	        	var id = $(this).attr("id").toLowerCase();
	        	var term = $("#applicant_search").val().toLowerCase();
	        	if(id.indexOf(term) != -1){
	        		$(this).css("font-size", "30px");
	        	}
	        	else{
					$(this).css("font-size", "12px");
	        	}
	        });
	    }
	});
	$("#link_distance_input").keyup(function(event){
	    if(event.keyCode == 13){
	        var dist = $(this).val();
			linkDistance = dist;
	        toggleChargeDistance(linkCharge,linkDistance);
	    }
	});
	$("#link_charge_input").keyup(function(event){
	    if(event.keyCode == 13){
	        var charge = $(this).val();
			linkCharge = charge;
			toggleChargeDistance(linkCharge,linkDistance);
	    }
	});
	$(".link_preference").on("change", function(){
		var type = $(this).attr("id");
		// alert("not been implemented yet "+type);
		if (type == "applicant"){
			toggleColors("applicant");
		}
		else{
			toggleColors("chair");
		}
	});
	$("#run_algorithm").click(function(){
		// alert("not implemented yet!");
		toggleDeliberations(deliberation_data, unsure_data, true);
	});
});