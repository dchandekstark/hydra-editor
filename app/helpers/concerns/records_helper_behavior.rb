module RecordsHelperBehavior
  
  def metadata_help(key)
    I18n.t("hydra.metadata_help.#{key}", default: key.to_s.humanize)
  end

  def field_label(key)
    I18n.t("hydra.field_label.#{key}", default: key.to_s.humanize)
  end

  def model_label(key)
    I18n.t("hydra.model_label.#{key}", default: key.to_s.humanize)
  end

  def object_type_options
    @object_type_options ||= HydraEditor.models.inject({}) do |h, model|
        label = model_label(model)
        h["#{label[0].upcase}#{label[1..-1]}"] = model
        h
    end
  end

  def render_edit_field_partial(key, locals)
    render_edit_field_partial_with_action('records', key, locals)
  end

  def render_batch_edit_field_partial(key, locals)
    render_edit_field_partial_with_action('batch_edit', key, locals)
  end

  def add_field (key)
    more_or_less_button(key, 'adder', '+')
  end

  def subtract_field (key)
    more_or_less_button(key, 'remover', '-')
  end

 private 

  def render_edit_field_partial_with_action(action, key, locals)
    ["#{action}/edit_fields/#{key}", "#{action}/edit_fields/default"].each do |str|
      # XXX rather than handling this logic through exceptions, maybe there's a Rails internals method
      # for determining if a partial template exists..
      begin
        return render :partial => str, :locals=>locals.merge({key: key})
      rescue ActionView::MissingTemplate; end
    end
    nil
  end
  
  def more_or_less_button(key, html_class, symbol)
    # TODO, there could be more than one element with this id on the page, but the fuctionality doesn't work without it.
    content_tag('button', class: "#{html_class} btn", id: "additional_#{key}_submit", name: "additional_#{key}") do
      (symbol + 
      content_tag('span', class: 'accessible-hidden') do
        "add another #{key.to_s}"
      end).html_safe
    end
  end
  
end
