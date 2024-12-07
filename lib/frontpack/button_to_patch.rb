module ActionView
  module Helpers
    module UrlHelper
      def button_to(name = nil, options = nil, html_options = nil, &block)
        html_options, options = options, name if block_given?
        html_options ||= {}
        html_options = html_options.stringify_keys

        url = case options
                when FalseClass then nil
                else url_for(options)
              end

        remote = html_options.delete("remote")
        params = html_options.delete("params")

        authenticity_token = html_options.delete("authenticity_token")

        method     = (html_options.delete("method").presence || method_for_options(options)).to_s
        method_tag = BUTTON_TAG_METHOD_VERBS.include?(method) ? method_tag(method) : "".html_safe

        form_id = html_options.delete("form_id") || SecureRandom.hex(8)
        form_method  = method == "get" ? "get" : "post"
        form_options = html_options.delete("form") || {}
        form_options[:class] ||= html_options.delete("form_class") || "button_to"
        form_options[:method] = form_method
        form_options[:action] = url
        form_options[:id] = form_id
        form_options[:'data-remote'] = true if remote

        request_token_tag = if form_method == "post"
                              request_method = method.empty? ? "post" : method
                              token_tag(authenticity_token, form_options: { action: url, method: request_method })
                            else
                              ""
                            end

        html_options = convert_options_to_data_attributes(options, html_options)
        html_options["type"] = "submit"


        html_options["form"] = form_id
        button = if block_given?
                   content_tag("button", html_options, &block)
                 elsif button_to_generates_button_tag
                   content_tag("button", name || url, html_options, &block)
                 else
                   html_options["value"] = name || url
                   tag("input", html_options)
                 end

        inner_tags = method_tag.safe_concat(request_token_tag)
        if params
          to_form_params(params).each do |param|
            inner_tags.safe_concat tag(:input, type: "hidden", name: param[:name], value: param[:value],
                                       autocomplete: "off")
          end
        end
        html = content_tag("form", inner_tags, form_options) + button
        prevent_content_exfiltration(html)
      end
    end
  end
end