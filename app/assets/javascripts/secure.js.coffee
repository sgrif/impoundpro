# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $(".navbar .search-query").popover({placement: 'bottom'}).keyup ->
    $(this).popover('hide')
  $('.chzn-select').chosen()
  $('.chzn-select-deselect').chosen allow_single_deselect: true
