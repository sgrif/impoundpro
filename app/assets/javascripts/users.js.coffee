# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  user.setupForm()

user =
  setupForm: ->
    $("form#new_user, form.edit_user").submit ->
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        user.processCard()
        false
      else
        true

    $("input#card_number").change ->
      user.handleStripeValidation $(this), Stripe.validateCardNumber $(this).val()

    $("input#card_code").change ->
      user.handleStripeValidation $(this), Stripe.validateCVC $(this).val()

    $("select#card_year").change ->
      user.handleStripeValidation $(this), Stripe.validateExpiry $("select#card_month").val(), $(this).val()

    $("select#card_month").change ->
      if $("select#card_year").val()
        user.handleStripeValidation $("select#card_year"),
        Stripe.validateExpiry $(this).val(), $("select#card_year").val()

  processCard: ->
    Stripe.createToken(
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      exp_month: $('#card_month').val()
      exp_year: $('#card_year').val(),
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
    field.parent().removeClass 'valid invalid'
    if response
      field.parent().addClass "valid"
      $("input[type='submit']").attr("disabled", false) unless $(".invalid").length
    else
      field.parent().addClass "invalid"
      $("input[type='submit']").attr("disabled", true)
