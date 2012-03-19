require 'factory_girl/syntax/blueprint'
def rand_in_range(to, from)
  rand * (to - from) + from
end

def rand_time(from, to)
  Time.at(rand_in_range(from.to_f, to.to_f))
end

FactoryGirl.define do
  User.blueprint do 
    email {Faker::Internet.email}
    password {Faker::Lorem.words.first}
    password_confirmation {password}
    name {Faker::Company.name}
    address {Faker::Address.street_address}
    city {Faker::Address.city}
    state {Faker::Address.us_state_abbr}
    zip {Faker::Address.zip_code}
    phone_number {Faker::PhoneNumber.phone_number}
    county {Faker::Lorem.words.first}
    preparers_name {Faker::Name.name}
  end
  
  Car.blueprint do
    year {rand_in_range(1990, Time.now.year + 1).to_i}
    make {Faker::Name.last_name}
    model {Faker::Company.catch_phrase.split(' ')[0]}
    size {"#{[2,4].sample}-Door"}
    color {['Red', 'Blue', 'Green', 'Silver', 'Black'].sample}
    state {Faker::Address.us_state_abbr}
    vin {rand(36**24).to_s(36)}
    license_plate_number {rand(36**6).to_s(36).upcase}
    
    owner_name {Faker::Name.name}
    owner_address {Faker::Address.street_address}
    owner_city {Faker::Address.city}
    owner_state {Faker::Address.us_state_abbr}
    owner_zip {Faker::Address.zip_code}
    
    lien_holder_name {Faker::Name.name}
    lien_holder_address {Faker::Address.street_address}
    lien_holder_city {Faker::Address.city}
    lien_holder_state {Faker::Address.us_state_abbr}
    lien_holder_zip {Faker::Address.zip_code}
    
    driver_name {Faker::Name.name}
    driver_address {Faker::Address.street_address}
    driver_city {Faker::Address.city}
    driver_state {Faker::Address.us_state_abbr}
    driver_zip {Faker::Address.zip_code}
    
    date_towed {rand_time(60.days.ago, Time.now)}
    tow_requested_by {Faker::Company.name}
    tow_reason {Faker::Lorem.words.join(' ')}
    
    preparers_name {Faker::Name.name}
    
    charge_hook_up{rand_in_range(0,2).to_i * rand_in_range(0.0,100.00).round(2)}
    charge_mileage{rand_in_range(0,2).to_i * rand_in_range(0.0,100.00).round(2)}
    charge_storage{rand_in_range(0,2).to_i * rand_in_range(0.0,100.00).round(2)}
    charge_admin{rand_in_range(0,2).to_i * rand_in_range(0.0,100.00).round(2)}
    charge_other{rand_in_range(0,2).to_i * rand_in_range(0.0,100.00).round(2)}
    tax {0.074375}
     
    user
  end
end
