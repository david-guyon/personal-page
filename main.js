/*
 * Global variables
 */
var projectsListExpanded = false;
var currentLanguage = "en";

$(function(){
	/* Hide all project boxes */
	$("#projectsList div").hide();

  getLang();

	//handleWhereBox(); Temporary comment and replace by a "work in progress" icon
	handleWhoBox();
	handleWebsiteBox();
	handleBlogBox();
	handleProjectsBox();
});

function getLang() {
  var lang = window.location.pathname.split('/');
  if(lang[lang.length-1] == "index-fr.html")
    currentLanguage = "fr";
}

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
}

function handleWebsiteBox() {
	$("#website").click(function() {
		window.open("http://songaccoustic.fr", '_blank').focus();
	});
}

function handleBlogBox() {
	$("#blog").click(function() {
		window.open("http://blog.david.guyon.me", '_self');
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
				showProjectsList(600);
        if(currentLanguage == "en")
  				$("#projects p").html("Click to close this section");
        else
  				$("#projects p").html("Clique pour fermer cette section");
				projectsListExpanded = true;
			}, 600);
		} else {
			hideProjectsList(200);
			setTimeout(function() {
				showWhoBox(1000);
				showWebsiteBox(1000);
					showWhereBox(1000);
					showBlogBox(1000);
          if(currentLanguage == "en")
  					$("#projects p").html("Click to see all projects I did or that I'm currently doing");
          else
  					$("#projects p").html("Clique pour voir l'ensemble des projets que j'ai fait ainsi que ceux sur lesquels je travaille actuellement");
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
		}, 300 * index);
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
		}, 300 * index);
	});
}
