module ApplicationHelper
  def selected_if_section_is(section)
    return {:class => 'selected'} if controller.action_name==section
    {}
  end
end
