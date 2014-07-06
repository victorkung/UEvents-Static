// Homepage Changing Background

var currentBackground = 0;
var backgrounds = [];
backgrounds[0] = '/Users/victorkung/Coding/Projects/UEvents-Static/img/bg1.jpg';
backgrounds[1] = '/Users/victorkung/Coding/Projects/UEvents-Static/img/bg2.jpg';

function changeBackground() {
	currentBackground++;
	if (currentBackground > 1) {
		currentBackground = 0;
	}

	$('.bg-home').fadeOut(1000, function() {
		$('.bg-home').css( {
			'background-image' : "url('" + backgrounds[currentBackground] + "')"
		});

		$('.bg-home').fadeIn(1000);
	});

	setTimeout(changeBackground, 6000);
}


$(document).ready(function() {
	setTimeout(changeBackground, 6000);        

	// Sticky Header
	// $(window).scroll(function() {
	// 	var scrollFromTop = $(this).scrollTop() + 50;
	// 	return $(".event-day").each(function() {
	// 		var offsetTop = $(this).offset().top;
	// 		var wrapper = $(this).parent();
	// 		var wrapperOffsetTop = wrapper.offset().top;
	// 		var topPosition = scrollFromTop - wrapperOffsetTop;
	// 		if (topPosition < 0) {
	// 			topPosition = 0;
	// 		}
	// 		$(this).css("top", topPosition);
	// 	});
	// });
	
});

