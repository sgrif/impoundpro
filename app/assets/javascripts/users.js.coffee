# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  user.setupForm()
  
user =
  setupForm: ->
    $("#credit_card_info input, #credit_card_info select").change ->
      if $("#card_number").val() and $("#card_code").val() and $("#card_month").val() and $("#card_year").val()
        $('input[type=submit]').attr('disabled', true)
        user.processCard()
        
  processCard: ->
    card = 
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, user.handleStripeResponse)
    
  handleStripeResponse: (status, response) ->
    if status == 200
      alert(response.id)
    else
      $("#stripe_response").text(response.error.message)
