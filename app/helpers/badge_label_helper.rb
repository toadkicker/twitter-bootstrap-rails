module BadgeLabelHelper
  def badge(type = nil, msg)
    opt_type = "badge-#{type}" unless type.blank?
    clazz = ["badge", opt_type]
    raw(content_tag :span, msg, :class => clazz.join(' '))
  end

 end
