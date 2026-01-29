ActionView::Base.field_error_proc = proc do |html_tag, instance|
  render partial: "application/form_errors", locals: { html_tag: html_tag, instance: instance }
end
