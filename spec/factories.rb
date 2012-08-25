FactoryGirl.define do
  factory :user do
    email                    "foo@bar.com"
    name                     "Foo Bar"
    password                 "secret"
    password_confirmation    "secret"
  end

  factory :car do
    vin "1FTPW12547K140642"
  end
end
