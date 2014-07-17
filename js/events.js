// VARIABLE AND FUNCTION DEFINITIONS


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
	setTimeout(changeBackground, 8000);
}


//  EVENTS

$(document).ready(function() {



	// Background Change
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

	// Adding Overlay Style 
	$('.overlay').addClass('overlay-scale');
	
	// Adding Overlay
	$('.overlay-btn').click(function(event){
		event.preventDefault();
		event.stopPropagation();
		var title = $(this).find('button').text();
		$('.overlay').each(function(i, obj) {
			var text = $(this).find('h2').text();
			if (text == title) {
				console.log("poop");
				$('#close-btn').show();
				$(this).addClass('open');
				$('body').addClass('no-scroll');
			}
		});
	});

	// Removing Overlay by Clicking Outside of Overlay Box
	$('html').click(function(event){
		var container = $('.overlay-main');
		var isVisible;
		if (!container.is(event.target) && container.has(event.target).length === 0) {
			$('.overlay').each(function(i, obj) {
				isVisible = $(this).is(':visible');
				if (isVisible) {
					$(this).removeClass('open');
					$('#close-btn').hide();
					$('body').removeClass('no-scroll');
				}
			});
		}
	});

	// Removing Overlay by Clicking the X button
	$('span#close-btn').click(function(event){
		$('.overlay').each(function(i, obj) {
			isVisible = $(this).is(':visible');
			if (isVisible) {
				$(this).removeClass('open');
				$('#close-btn').hide();
				$('body').removeClass('no-scroll');
			}
		});
	});
 
	// Removing Overlay if "Esc" Key is Clicked
	$(document).keyup(function(e) {
		if (e.keyCode == 27) { 
			$('#close-btn').click(); 
		}
	});

	// Tooltip Initialization
	$('.tip').tipr();
});

