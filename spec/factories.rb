FactoryGirl.define do
  factory :car do
    override_check_vin  true
    vin                 { SecureRandom.hex(8) }
  end

  factory :lien_procedure do
    active     true
    date_towed Date.today

    trait :mvd_inquiry_soon do
      date_towed Date.yesterday
    end

    trait :mvd_inquiry_required do
      date_towed 2.days.ago.to_date
    end

    trait :mvd_inquiry_finished do
      date_towed        2.days.ago.to_date
      mvd_inquiry_date  Date.today
    end

    trait :lien_notice_soon do
      date_towed        5.days.ago.to_date
      mvd_inquiry_date  3.days.ago.to_date
    end

    trait :lien_notice_required do
      date_towed        7.days.ago.to_date
      mvd_inquiry_date  5.days.ago.to_date
    end

    trait :lien_notice_finished do
      date_towed            7.days.ago.to_date
      mvd_inquiry_date      5.days.ago.to_date
      lien_notice_mail_date Date.today
    end

    trait :public_sale_soon do
      date_towed            15.days.ago.to_date
      mvd_inquiry_date      13.days.ago.to_date
      lien_notice_mail_date 8.days.ago.to_date
    end

    trait :public_sale_required do
      date_towed            17.days.ago.to_date
      mvd_inquiry_date      15.days.ago.to_date
      lien_notice_mail_date 10.days.ago.to_date
    end

    trait :public_sale_finished do
      date_towed                  17.days.ago.to_date
      mvd_inquiry_date            15.days.ago.to_date
      lien_notice_mail_date       10.days.ago.to_date
      notice_of_public_sale_date  Date.today
    end
  end

  factory :user do
    email                 "foo@bar.com"
    name                  "Foo Bar"
    password              "secret"
    password_confirmation "secret"
  end
end
