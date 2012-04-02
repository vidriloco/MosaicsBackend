# encoding: utf-8

Factory.define :manager do |u|
  u.full_name "Javier García"
  u.username "javier_garcia"
  u.password "passwd"
  u.password_confirmation "passwd"
  u.email "manager@mosaics.com"
  u.organization Factory.build(:organization, :name => "KantarWorldPanel")
end