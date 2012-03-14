Factory.define :user do |f|
  f.sequence(:email) { |n| "foo#{n}@example.com" }
  f.password "secret"
  f.name "Towing Company"
  f.address "123 Main St"
  f.city "Albuquerque"
  f.state "NM"
  f.zip "87106"
  f.phone_number "(505) 764-4444"
  f.county "Bernalillo"
end
