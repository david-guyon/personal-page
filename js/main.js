jQuery(function($){
  $('a[href^="./#"]').click(function() {
    var the_id = $(this).attr("href").substr(2);

    $('html, body').animate({
     scrollTop:$(the_id).offset().top
    }, {
      duration: 1000,
      easing: 'easeOutQuad'
    });
    return false;
  });
});
