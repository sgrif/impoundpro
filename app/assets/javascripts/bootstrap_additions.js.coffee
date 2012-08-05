jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $("body").on 'click', 'a.show-hidden', ->
    $($(this).attr('href')).removeClass('hidden')
    $(this).remove()
    false
