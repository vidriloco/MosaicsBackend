# encoding: utf-8

Factory.define :meta_survey do |ms|
  ms.name "Encuesta Variada"
  ms.size 200
  ms.organization { Factory.build(:organization, :name => "Kantar World Panel") }
end