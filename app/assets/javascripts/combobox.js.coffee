$.widget "ui.combobox"
  _create: ->
    this.element
      .addClass("ui-combobox-input")
      .autocomplete
        delay: 0
        minLength: 0
        source: this.element.data('auto-complete')
    this.toggle = $("<a>")
      .attr
        tabIndex: -1
        title: "Show all items"
      .insertAfter(this.element)
      .button
        icons:
          primary: "ui-icon-triangle-1-s"
        text: false
      .removeClass("ui-corner-all")
      .addClass("ui-corner-right ui-combobox-toggle")
      .click (e) =>
        if this.element.autocomplete('widget').is(':visible')
          this.element.autocomplete('close')
        else
          $(e.currentTarget).blur()
          this.element.autocomplete("search", "")
            .focus()
