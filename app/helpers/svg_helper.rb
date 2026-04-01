module SvgHelper
  def svg(svg_name, **attributes)
    # The desired SVG is received as a string
    # Then use Nokogiri to add any supplied HTML attributes.
    # The xml object is then converted back to a string and returned.
    svg_markup = render file: "#{Rails.root}/app/views/application/svg/#{svg_name}.svg"

    xml = Nokogiri::XML(svg_markup)

    attributes&.each do |key, value|
      xml.root.set_attribute(key, value)
    end

    xml.root.to_xml.html_safe
  end
end
