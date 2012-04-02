module HelperMethods
  # Put helper methods you need to be available in all acceptance specs here.
  def login_with(user, path)
    visit path
    fill_in "#{user.class.to_s.underscore}_email", :with => user.email
    fill_in "#{user.class.to_s.underscore}_password", :with => user.password
    click_on I18n.t('users.views.sessions.new.login_button')
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance