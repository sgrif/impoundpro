require 'spec_helper'

describe StripeWebhooksController do
  let(:user) { create(:user, :stripe_customer_token => nil, :paid => nil) }
  subject { user }

  context "invoice.payment_succeeded" do
    before :each do
      post "create", :stripe_webhook => {"data"=>{"object"=>{"period_end"=>1333391551, "attempted"=>true, "discount"=>nil, "lines"=>{"subscriptions"=>[{"plan"=>{"name"=>"Standard Subscription", "trial_period_days"=>nil, "amount"=>1000, "id"=>"basic", "livemode"=>false, "interval"=>"month", "currency"=>"usd", "object"=>"plan"}, "period"=>{"end"=>1337466868, "start"=>1334874868}, "amount"=>1000}]}, "paid"=>true, "closed"=>true, "amount_due"=>1000, "total"=>1000, "period_start"=>1333391551, "id"=>"in_00000000000000", "date"=>1333391551, "livemode"=>false, "attempt_count"=>0, "customer"=>"#{user.get_stripe_customer_token}", "subtotal"=>1000, "ending_balance"=>0, "charge"=>"_00000000000000", "starting_balance"=>0, "object"=>"invoice", "next_payment_attempt"=>nil}}, "id"=>"evt_00000000000000", "type"=>"invoice.payment_succeeded", "livemode"=>false, "user"=>{}, "created"=>1326853478}
    end

    its("paid") { should be_true }
  end

  context "invoice.payment_failed" do
    before :each do
      post "create", :stripe_webhook => {"data"=>{"object"=>{"period_end"=>1333391551, "attempted"=>true, "discount"=>nil, "lines"=>{"subscriptions"=>[{"plan"=>{"name"=>"Standard Subscription", "trial_period_days"=>nil, "amount"=>1000, "id"=>"basic", "livemode"=>false, "interval"=>"month", "currency"=>"usd", "object"=>"plan"}, "period"=>{"end"=>1337466868, "start"=>1334874868}, "amount"=>1000}]}, "paid"=>false, "closed"=>false, "amount_due"=>1000, "total"=>1000, "period_start"=>1333391551, "id"=>"in_00000000000000", "date"=>1333391551, "livemode"=>false, "attempt_count"=>0, "customer"=>"#{user.get_stripe_customer_token}", "subtotal"=>1000, "ending_balance"=>0, "charge"=>"ch_00000000000000", "starting_balance"=>0, "object"=>"invoice", "next_payment_attempt"=>nil}}, "id"=>"evt_00000000000000", "type"=>"invoice.payment_failed", "livemode"=>false, "user"=>{}, "created"=>1326853478}
    end

    its("paid") { should == false }
  end

  context "payment.succeeded" do
    before :each do
      post "create", :stripe_webhook => {"data"=>{"object"=>{"refunded"=>false, "amount_refunded"=>0, "disputed"=>false, "invoice"=>"in_00000000000000", "paid"=>true, "amount"=>1000, "id"=>"ch_00000000000000", "card"=>{"name"=>nil, "exp_month"=>1, "country"=>"US", "exp_year"=>2014, "address_zip"=>nil, "address_country"=>nil, "last4"=>"0002", "cvc_check"=>"pass", "id"=>"cc_00000000000000", "address_line1_check"=>nil, "type"=>"Visa", "fingerprint"=>"s7NV4Dl9FCMBP4xl", "address_state"=>nil, "address_line1"=>nil, "object"=>"card", "address_zip_check"=>nil, "address_line2"=>nil}, "fee"=>0, "livemode"=>false, "failure_message"=>"Your card was declined.", "currency"=>"usd", "customer"=>"#{user.get_stripe_customer_token}", "description"=>nil, "object"=>"charge", "created"=>1333127244}}, "id"=>"evt_00000000000000", "type"=>"charge.succeeded", "livemode"=>false, "created"=>1326853478}
    end

    its("paid") { should be_true }
  end
  
  context "payment.succeeded" do
    before :each do
      post "create", :stripe_webhook => {"data"=>{"object"=>{"refunded"=>false, "amount_refunded"=>0, "disputed"=>false, "invoice"=>"in_00000000000000", "paid"=>true, "amount"=>1000, "id"=>"ch_00000000000000", "card"=>{"name"=>nil, "exp_month"=>1, "country"=>"US", "exp_year"=>2014, "address_zip"=>nil, "address_country"=>nil, "last4"=>"0002", "cvc_check"=>"pass", "id"=>"cc_00000000000000", "address_line1_check"=>nil, "type"=>"Visa", "fingerprint"=>"s7NV4Dl9FCMBP4xl", "address_state"=>nil, "address_line1"=>nil, "object"=>"card", "address_zip_check"=>nil, "address_line2"=>nil}, "fee"=>0, "livemode"=>false, "failure_message"=>"Your card was declined.", "currency"=>"usd", "customer"=>"#{user.get_stripe_customer_token}", "description"=>nil, "object"=>"charge", "created"=>1333127244}}, "id"=>"evt_00000000000000", "type"=>"charge.failed", "livemode"=>false, "created"=>1326853478}
    end

    its("paid") { should == false }
  end
end
