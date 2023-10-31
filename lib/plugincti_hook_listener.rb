class PluginctiHookListener < Redmine::Hook::ViewListener
  render_on :view_layouts_base_html_head, partial: "plugincti/base_html" 
end