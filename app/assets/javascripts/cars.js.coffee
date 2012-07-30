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

    $(':input#car_make_id').change (e) ->
      model_select = $(':input#car_model_id').attr('disabled', true)
      $.getJSON "/makes/#{$(this).val()}/models.json", (data) ->
        model_select.find('option').remove()
        for model in data
          model_select.append($("<option>").val(model.id).text(model.name))
        model_select.removeAttr('disabled')
