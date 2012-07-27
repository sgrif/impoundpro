# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  user.setupForm()

user =
  setupForm: ->
    @number = $("input#credit_card_number")
    @cvc = $("input#credit_card_cvc")
    @year = $("select#credit_card_expiry_1i")
    @month = $("select#credit_card_expiry_2i")

    $("form#new_user, form[id^=edit_user]").submit ->
      $('input[type=submit]').attr('disabled', true)
      if @number.length
        user.processCard()
        false
      else
        true

    @number.change ->
      user.handleStripeValidation $(this), Stripe.validateCardNumber $(this).val()

    @cvc.change ->
      user.handleStripeValidation $(this), Stripe.validateCVC $(this).val()

    @year.change (e) =>
      $this = $(e.target)
      user.handleStripeValidation $this, Stripe.validateExpiry @month.val(), $this.val()

    @month.change (e) =>
      $this = $(e.target)
      if @year.val()
        user.handleStripeValidation @year, Stripe.validateExpiry $this.val(), @year.val()

  processCard: ->
    Stripe.createToken(
      number: @number.val()
      cvc: @cvc.val()
      exp_month: @month.val()
      exp_year: @year.val(),
      user.handleStripeResponse)
    false

  handleStripeResponse: (status, response) ->
    if status == 200
      $("#user_stripe_card_token").val(response.id)
      $("form#new_user, form.edit_user")[0].submit()
    else
      $("#stripe_error").html(response.error.message)
      $("input[type=submit]").attr("disabled", false)

  handleStripeValidation: (field, response) ->
    field.parents('.control-group').removeClass 'success error'
    if response
      field.parents('.control-group').addClass "success"
      $("input[type='submit']").attr("disabled", false) unless $(".error").length
    else
      field.parents('.control-group').addClass "error"
      $("input[type='submit']").attr("disabled", true)
