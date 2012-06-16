require 'spec_helper'

describe StripeWebhooksController do
  let(:user) { create(:user, :stripe_customer_token => nil, :paid => true) }
  let(:car) { create(:car, :user => user, :paid => true, :stripe_invoice_item_token => "ii_00000000000000") }

  context "user" do
    subject { user.reload }

    context "invoice.payment_succeeded" do
      before :each do
        post "create", {"data"=>{"object"=>{"period_end"=>1336711047, "discount"=>nil, "attempted"=>true, "lines"=>{"subscriptions"=>[{"plan"=>{"name"=>"Standard Subscription", "trial_period_days"=>nil, "amount"=>1000, "id"=>"basic", "livemode"=>false, "interval"=>"month", "currency"=>"usd", "object"=>"plan"}, "period"=>{"end"=>1341692845, "start"=>1339100845}, "amount"=>1000}]}, "closed"=>true, "paid"=>true, "amount_due"=>1000, "period_start"=>1336711047, "total"=>1000, "date"=>1336711047, "id"=>"in_00000000000000", "livemode"=>false, "attempt_count"=>0, "customer"=>"#{user.get_stripe_customer_token}", "subtotal"=>1000, "ending_balance"=>0, "object"=>"invoice", "charge"=>"_00000000000000", "starting_balance"=>0, "next_payment_attempt"=>nil}}, "id"=>"evt_00000000000000", "type"=>"invoice.payment_succeeded", "livemode"=>false, "stripe_webhook"=>{"type"=>"invoice.payment_succeeded"}, "created"=>1326853478}
      end

      its("paid") { should be_true }
    end

    context "invoice.payment_failed" do
      before :each do
        post "create", {"data"=>{"object"=>{"period_end"=>1336711047, "discount"=>nil, "attempted"=>true, "lines"=>{"subscriptions"=>[{"plan"=>{"name"=>"Standard Subscription", "trial_period_days"=>nil, "amount"=>1000, "id"=>"basic", "livemode"=>false, "interval"=>"month", "currency"=>"usd", "object"=>"plan"}, "period"=>{"end"=>1341692845, "start"=>1339100845}, "amount"=>1000}]}, "closed"=>false, "paid"=>false, "amount_due"=>1000, "period_start"=>1336711047, "total"=>1000, "date"=>1336711047, "id"=>"in_00000000000000", "livemode"=>false, "attempt_count"=>0, "customer"=>"#{user.get_stripe_customer_token}", "subtotal"=>1000, "ending_balance"=>0, "object"=>"invoice", "charge"=>"ch_00000000000000", "starting_balance"=>0, "next_payment_attempt"=>nil}}, "id"=>"evt_00000000000000", "type"=>"invoice.payment_failed", "livemode"=>false, "stripe_webhook"=>{"type"=>"invoice.payment_failed"}, "created"=>1326853478}
      end

      its("paid") { should == false }
    end

    context "payment.succeeded" do
      before :each do
        post "create", {"data"=>{"object"=>{"refunded"=>false, "amount_refunded"=>0, "invoice"=>"in_00000000000000", "disputed"=>false, "paid"=>true, "amount"=>1000, "id"=>"ch_00000000000000", "card"=>{"name"=>nil, "exp_month"=>12, "exp_year"=>2016, "address_zip"=>nil, "country"=>"US", "address_country"=>nil, "cvc_check"=>"pass", "last4"=>"4242", "id"=>"cc_00000000000000", "address_line1_check"=>nil, "type"=>"Visa", "fingerprint"=>"Y4rG40GjEuGdGcFu", "address_state"=>nil, "address_line1"=>nil, "object"=>"card", "address_zip_check"=>nil, "address_line2"=>nil}, "livemode"=>false, "fee"=>0, "failure_message"=>nil, "customer"=>"#{user.get_stripe_customer_token}", "currency"=>"usd", "description"=>nil, "object"=>"charge", "created"=>1336784085}}, "id"=>"evt_00000000000000", "type"=>"charge.succeeded", "livemode"=>false, "stripe_webhook"=>{"type"=>"charge.succeeded"}, "created"=>1326853478}
      end

      its("paid") { should be_true }
    end

    context "payment.succeeded" do
      before :each do
        post "create", {"data"=>{"object"=>{"refunded"=>false, "amount_refunded"=>0, "invoice"=>"in_00000000000000", "disputed"=>false, "paid"=>false, "amount"=>1000, "id"=>"ch_00000000000000", "card"=>{"name"=>nil, "exp_month"=>12, "exp_year"=>2016, "address_zip"=>nil, "country"=>"US", "address_country"=>nil, "cvc_check"=>"pass", "last4"=>"4242", "id"=>"cc_00000000000000", "address_line1_check"=>nil, "type"=>"Visa", "fingerprint"=>"Y4rG40GjEuGdGcFu", "address_state"=>nil, "address_line1"=>nil, "object"=>"card", "address_zip_check"=>nil, "address_line2"=>nil}, "livemode"=>false, "fee"=>0, "failure_message"=>nil, "customer"=>"#{user.get_stripe_customer_token}", "currency"=>"usd", "description"=>nil, "object"=>"charge", "created"=>1336784085}}, "id"=>"evt_00000000000000", "type"=>"charge.failed", "livemode"=>false, "stripe_webhook"=>{"type"=>"charge.failed"}, "created"=>1326853478}
      end

      its("paid") { should == false }
    end

    context "customer.created" do
      before :each do
        post "create", {"data"=>{"object"=>{"discount"=>nil, "delinquent"=>false, "active_card"=>nil, "account_balance"=>0, "id"=>"#{user.get_stripe_customer_token}", "next_recurring_charge"=>nil, "livemode"=>false, "subscription"=>nil, "description"=>nil, "object"=>"customer", "email"=>"reyes.dooley@fahey.net", "created"=>1337877636}}, "id"=>"evt_00000000000000", "type"=>"customer.created", "livemode"=>false, "object"=>"event", "stripe_webhook"=>{"type"=>"customer.created"}, "created"=>1326853478}
      end

      its("stripe_customer_token") { should == user.get_stripe_customer_token }
    end
  end

  context "car" do
    subject { car.reload }

    context "invoiceitem.created" do
      before :each do
        post "create", {"data"=>{"object"=>{"invoice"=>nil, "amount"=>200, "id"=>"#{car.stripe_invoice_item_token}", "date"=>1337019474, "livemode"=>false, "description"=>"Unlocking fee for car 465KRM", "customer"=>"#{user.get_stripe_customer_token}", "currency"=>"usd", "object"=>"invoiceitem"}}, "id"=>"evt_00000000000000", "type"=>"invoiceitem.created", "livemode"=>false, "object"=>"event", "stripe_webhook"=>{"type"=>"invoiceitem.created"}, "created"=>1326853478}
      end

      its("paid") { should be_true }
    end
  end
end
