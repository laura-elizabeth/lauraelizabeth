#= require "jquery"
#= require "vendor/bootstrap-custom"
#= require "vendor/jribbble"
#= require "vendor/retina.min"
#= require "vendor/picturefill.min"

$(document).ready ->
  detectMobile()
  initDribbbleFeed()
  initDripForms()

detectMobile= ->
  @isMobile = false
  if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) )
    @isMobile = true

initDribbbleFeed= ->
  numberOfFeeds = if @isMobile then 4 else 8
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
    per_page: numberOfFeeds
  return

initDripForms= ->
  $('form.drip_form').on 'submit', (e)->
    e.preventDefault()
    form = $(@)
    onPressSubmitForm(form)

    options = {}

    if form.find('input.first_name').val() == ''
      onDripFormError form,
        first_name: 'Can I at least know your name?'

    else
      if _dcq?
        _dcq.push [
          "subscribe"
          {
            campaign_id: form.data('campaign-id')

            fields:
              email: form.find('input.email').val()
              first_name: form.find('input.first_name').val()
            double_optin: false

            success: (response)->
              if response.errors?
                onDripFormError(form, response.errors)
              else
                onDripFormSuccess(form, options)
            error: (response)->
              # Nothing yet
          }
        ]
      else
        if form.find('input.email').val() == ''
          onDripFormError form,
            email: 'Please enter a valid email address'
        else
          onDripFormError form

onDripFormSuccess= (form, options)->
  console.log 'onDripFormSuccess', form, options
  form.addClass('success')
  # Enable button
  form.find('input[type=submit]').prop('disabled', false)
  # Do other things for success

onDripFormError= (form, errors = {})->
  form.addClass('error')
  # Enable button
  form.find('input[type=submit]').prop('disabled', false)

  if errors.email?
    input = form.find('input.email')
    input.addClass('error')
    input.after("<span class='error'>#{errors.email}</span>")

  if errors.first_name?
    input = form.find('input.first_name')
    input.addClass('error')
    input.after("<span class='error'>#{errors.first_name}</span>")

  # Do other things for error
  # for example: form.addClass('error')

onPressSubmitForm= (form)->
  form.find('input.error').removeClass('error')
  form.removeClass('error success')
  # Remove all error messages
  form.find('span.error').remove()
  # Disable submit
  form.find('input[type=submit]').prop('disabled', true)
