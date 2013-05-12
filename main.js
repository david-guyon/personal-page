/*
 * Global variables
 */
var projectsListExpanded = false;

$(function(){
	/* Hide all project boxes */
	$("#projectsList div").hide();

	handleWhereBox();
	handleWhoBox();
	handleWebsiteBox();
	handleBlogBox();
	handleProjectsBox();
});

function handleWhereBox() {
	$("#where li").mouseover(function(e) {
		console.log(e.target.alt);
		switch(e.target.alt) {
			case "Facebook logo":
				$("#linkContainer a").html("My Facebook wall");
				$("#linkContainer a").attr("href", "https://www.facebook.com/GuyonDavid");
			break;
			case "Google+ logo":
				$("#linkContainer a").html("My Google plus page");
				$("#linkContainer a").attr("href", "https://plus.google.com/118272748818799969626");
			break;
			case "Twitter logo":
				$("#linkContainer a").html("My Twitter account");
				$("#linkContainer a").attr("href", "https://twitter.com/dgetux");
			break;
			case "Youtube logo":
				$("#linkContainer a").html("My Youtube channel");
				$("#linkContainer a").attr("href", "http://www.youtube.com/user/misterchimizz");
			break;
			case "Last.fm logo":
				$("#linkContainer a").html("My Last.fm account");
				$("#linkContainer a").attr("href", "http://www.lastfm.fr/user/misterchimiz");
			break;
			default:
				$("#linkContainer a").html("O_o'");
		}
	});
}

function handleWhoBox() {
	$("#who a").click(function() {
		$("#who a").html("Soon..");
	});
}

function handleWebsiteBox() {
	$("#website").click(function() {
		window.open("http://songaccoustic.fr", '_blank').focus();
	});
}

function handleBlogBox() {
	$("#blog").click(function() {
		window.open("http://blog.songaccoustic.fr", '_blank').focus();
	});
}

function handleProjectsBox() {
	$("#projects").click(function() {
		if(!projectsListExpanded) {
			hideWhereBox(1000);
			hideBlogBox(1000);
			hideWhoBox(1000);
			hideWebsiteBox(1000);
			setTimeout(function() {
				showProjectsList(800);
				$("#projects p").html("Click to go back");
				projectsListExpanded = true;
			}, 600);
		} else {
			hideProjectsList(400);
			setTimeout(function() {
				showWhoBox(1000);
				showWebsiteBox(1000);
					showWhereBox(1000);
					showBlogBox(1000);
					$("#projects p").html("Click to see all projects I did or that I'm currently doing");
					projectsListExpanded = false;
			}, 800);
		}
	});
}

function hideWhoBox(duration) {
	$("#who").hide("blind", duration);
}

function hideWebsiteBox(duration) {
	$("#website").hide("blind", duration);
}

function hideWhereBox(duration) {
	$("#where").hide("blind", duration);
}

function hideBlogBox(duration) {
	$("#blog").hide("blind", duration);
}

function showWhoBox(duration) {
	$("#who").show("blind", duration);
}

function showWebsiteBox(duration) {
	$("#website").show("blind", duration);
}

function showWhereBox(duration) {
	$("#where").show("blind", duration);
}

function showBlogBox(duration) {
	$("#blog").show("blind", duration);
}

function showProjectsList(duration) {
	$("#projectsList div").each(function(index, element) {
		var that = $(this);
		setTimeout(function() {
			that.show();
			that.animate({
				opacity: 1
			}, duration);
		}, 400 * index);
	});
}

function hideProjectsList(duration) {
	$($("#projectsList div").get().reverse()).each(function(index, element) {
		var that = $(this);
		setTimeout(function() {
			that.animate({
				opacity: 0
			}, duration, function() {
				setTimeout(function() {
					that.hide();
				}, 150);
			});
		}, 400 * index);
	});
}
