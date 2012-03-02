# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
Car.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'users'") 
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'cars'") 

User.create(email: 'sgriffin@griffinassoc.com', password: 'password', name: 'Griffin & Associates', address: '119 Dartmouth SE', city: 'Albuquerque', state: 'NM', zip: '87106')
User.create(email: 'ferret4prez@gmail.com', password: 'password', name: 'Griffin & Associates', address: '119 Dartmouth SE', city: 'Albuquerque', state: 'NM', zip: '87106')

Car.create(year: 2008, make: 'Saturn', model: 'Aura', size: '4-Door', color: 'Blue', state: 'NM', vin: '1G3JFYR7389E11374', license_plate_number: 'LGG767', date_towed: '2012-01-26 20:57:00 UTC', tow_requested_by: 'test_tow_requested_by', tow_reason: 'test_tow_reason', mail_notice_of_lien_date: '2012-01-26 20:57:00 UTC', has_registered_owner: true, owner_name: 'Tyler Rodriguez', owner_address: 'PO Box 91252', owner_city: 'Albuquerque', owner_state: 'NM', owner_zip: '87199', has_lien_holder:true, lien_holder_name: 'test_lien_holder_name', lien_holder_address: 'test_lien_holder_address', lien_holder_city: 'test_lien_holder_city', lien_holder_state: 'test_lien_holder_state', lien_holder_zip: 'test_lien_holder_zip', has_charges:true, charge_towing: 120.00, charge_storage: 45.00, charge_admin: 25.00, tax: 0.74375, storage_rate: 15.00, mvd_inquiry_made: true, preparers_name: 'Sean Griffin', user: User.find_by_email('sgriffin@griffinassoc.com'))
Car.create(year: 2009, make: 'Ford', model: 'Fusion', size: '4-Door', color: 'Silver', state: 'NM', vin: 'test_vin', license_plate_number: 'test_license_plate_number', date_towed: '2012-01-26 20:57:00 UTC', tow_requested_by: 'test_tow_requested_by', tow_reason: 'test_tow_reason', mail_notice_of_lien_date: '2012-01-26 20:57:00 UTC', has_registered_owner:true, owner_name: 'Sean Griffin', owner_address: '100 Silver SW #215', owner_city: 'Albuquerque', owner_state: 'NM', owner_zip: '87106', has_lien_holder:true, lien_holder_name: 'Joan Griffin', lien_holder_address: '618 Lafayette NE', lien_holder_city: 'Albuquerque', lien_holder_state: 'NM', lien_holder_zip: '87106', has_charges:true, charge_towing: 120.00, charge_storage: 45.00, charge_admin: 25.00, tax: 0.74375, storage_rate: 15.00, mvd_inquiry_made: true, preparers_name: 'Sean Griffin', user: User.find_by_email('sgriffin@griffinassoc.com'))


