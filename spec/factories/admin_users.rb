# encoding: utf-8

Factory.define :admin_user do |au|
  au.password "passwd"
  au.password_confirmation "passwd"
  au.email "manager@mosaics.com"
end