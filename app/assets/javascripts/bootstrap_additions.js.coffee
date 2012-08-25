jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

  $("body").on 'click', 'a.show-hidden', ->
    $this = $($(this).attr('href'))
    $this.removeClass('hidden').html($this.data('hidden-html'))
    $(this).remove()
    false

  $("[data-hide='true']").each ->
      $(this).addClass("hidden").before(
        "<div class='ac'><a href='##{$(this).attr("id")}' class='btn btn-success show-hidden'>
        <i class='icon-plus'></i> #{$(this).data('show_text')}</a></div>").data("hidden-html", $(this).html()).html("")
