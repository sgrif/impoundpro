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
    btn_class = $(this).data('btn_class') || "success"
    btn_icon = $(this).data('btn_icon') || "plus"
    $(this).addClass("hidden").before(
      "<div class='ac'><a href='##{$(this).attr("id")}' class='btn btn-#{btn_class} show-hidden'>
      <i class='icon-#{btn_icon}'></i> #{$(this).data('show_text')}</a></div>").data("hidden-html", $(this).html()).html("")
