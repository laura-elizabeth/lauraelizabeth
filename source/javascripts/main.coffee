#= require "jquery"
#= require "vendor/bootstrap-custom"
#= require "vendor/jribbble"

$(document).ready ->
	initDribbbleFeed()

initDribbbleFeed= ->
	$.jribbble.getShotsByPlayerId 'laurium', ((playerShots) ->
    html = []
    $.each playerShots.shots, (i, shot) ->
      html.push '<div class="shot"><a href="' + shot.url + '" target="_blank">'
      html.push '<img class="shot-image" src="' + shot.image_url + '" '
      html.push 'alt="' + shot.title + '"></a></div>'
      return
    $('.dribbble-feed').html html.join('')
    return
  ),
    page: 1
    per_page: 8
  return
