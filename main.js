$(function(){
	handleWhereBox();
});

function handleWhereBox() {
	$("#where").mouseenter(function() {
		$("#linkContainer").show();
		$("#linkContainer").animate({
			height: "20px"
		}, 300);
		setTimeout(function() {
			$("#where #linkContainer a").show();
		}, 300);
	}).mouseleave(function() {
		$("#where #linkContainer a").hide();
		$("#linkContainer").animate({
			height: "0px"
		}, 200);
		setTimeout(function() {
			$("#linkContainer").hide();
		}, 200);
	});

	$("#where li").mouseover(function(e) {
		console.log(e.target.alt);
		switch(e.target.alt) {
			case "Facebook logo":
				console.log("Genre");
				$("#linkContainer a").val("GENNRE FB toussa");
			break;
			default:
				console.log("default");
				$("#linkContainer a").val("Le FUU");
		}
	});
}