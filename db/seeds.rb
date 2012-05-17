# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create(:email => "admin@quantus.com", :password_confirmation => "quantus-ya", :password => "quantus-ya", :username => "quantusroot")
Organization.create(:name => "Quantus")
Device.create(:identifier => "A4:67:06:82:D0:B5")
Pollster.create(:email => "leiden@quantus.com", :password_confirmation => "leiden", :password => "leiden", :username => "leiden", :full_name => "Leiden City")
