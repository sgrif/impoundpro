# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('body').hasClass 'cars'
    car.setupForm()

car =
  setupForm: ->
    $('form#new_car').on 'keydown', 'input', (e) ->
      if e.keyCode is 13
        $('input:submit#new_car_submit').click()
        false
      else
        true

    unless $('#car_owner_name').val() or $('#car_owner_address').val()
      $('#car_owner_info').addClass('hidden').before(
        "<div class='ac'><a href='#car_owner_info' class='btn btn-success show-hidden'>
        <i class='icon-plus'></i> Add Owner</a></div>")

    unless $('#car_lien_holder_name').val() or $('#car_owner_address').val()
      $('#car_lien_holder_info').addClass('hidden').before(
        "<div class='ac'><a href='#car_lien_holder_info' class='btn btn-success show-hidden'>
        <i class='icon-plus'></i> Add Lien Holder</a></div>")

    $('.chzn-select').chosen()
    $('.chzn-select-deselect').chosen allow_single_deselect: true

    make_select = $(':input#car_make_id')
    model_select = $(':input#car_model_id')
    year_select = $(':input#car_year_id')
    trim_select = $(':input#car_trim_id')

    make_select.change ->
      car.updateSelect model_select, "/makes/#{make_select.val()}/models.json", [year_select, trim_select]

    model_select.change ->
      car.updateSelect year_select, "/models/#{model_select.val()}/years.json", [trim_select]

    year_select.change ->
      car.updateSelect trim_select, "/models/#{model_select.val()}/years/#{year_select.val()}/trims.json"

  updateSelect: (target, url, disable = []) ->
    $(':submit').attr('disabled', true)

    disable.push target
    for item in disable
      item.val('').attr('disabled', true).trigger('liszt:updated') unless item.attr('disabled')

    $.getJSON url, (data) ->
      target.find('option').remove()
      target.append($("<option>").val(''))
      target.parents(".control-group").addClass('hidden')
      target.parents(".control-group").removeClass('hidden') if data.length > 0
      for item in data
        target.append($("<option>").val(item.id).text(item.name))
      target.removeAttr('disabled').trigger('liszt:updated')
      $(':submit').removeAttr('disabled')

