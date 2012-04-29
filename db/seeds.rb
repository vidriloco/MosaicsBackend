# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create(:email => "admin@quantus.com", :password_confirmation => "password", :password => "password", :username => "quantusroot")
Organization.create(:name => "Quantus")
Device.create(:identifier => "A4:67:06:82:D0:B5")
Pollster.create(:email => "pregunton@quantus.com", :password_confirmation => "pollita", :password => "pollita", :username => "leiden", :full_name => "Citizen Present")
Pollster.create(:email => "preguntona@quantus.com", :password_confirmation => "pollita", :password => "pollita", :username => "antwerpen", :full_name => "Citizen Future")