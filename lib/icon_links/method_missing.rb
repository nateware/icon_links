module IconLinks
  module MethodMissing
    include ViewHelpers

    # Handle missing methods so we can do fancy URL hooks.
    # This is what gives us "edit_player_icon" and "new_game_icon"
    def method_missing_with_icon_links(method_id, *args)
      method = method_id.to_s

      # special catch for "run_icon", where it really means "run_run_icon"
      method = "#{$1}_#{$1}_icon" if method =~ /^([a-z]+)_icon$/
      if method =~ /^([a-z]+)_(.+)_icon$/
        options = args.last.is_a?(Hash) ? args.pop : {}
        if options.has_key?(:if)
          return icon_tag(:clear) unless options.delete(:if)
        end
        type = $1
        meth = $2
        icon = options.delete(:icon) || type
        unless label = options.delete(:label)
          label = meth.dup
          IconLinks.remove_prefixes_for_labels.each {|prefix| break if label.sub!(/^#{prefix}_/, '')}
          label = label.titleize
        end

        # Note: We pass *either* args OR options to a given xxx_path() method,
        # depending on whether it's a collection or member method.
        url  = ''
        case type

        when 'new'
          url = send("new_#{meth}_path", options)
          #options[:rel] = "gb_page_center[600, 500]"   # greybox
          options[:title] ||= "Create a new #{label}"
          return icon_to(icon, url, options)

        when 'ajaxnew'
          url = send("new_#{meth}_path", options)
          #options[:rel] = "gb_page_center[600, 500]"   # greybox
          options[:title] ||= "Create a new #{label}"
          return icon_to(icon, url, options)

        when 'edit'
          url = send("edit_#{meth}_path", args)
          #options[:rel] = "gb_page_center[600, 500]"   # greybox
          options[:title] ||= "Edit this #{label}"
          return icon_to(icon, url, options)

        when 'delete'
          url = send("#{meth}_path", args)
          options[:method] ||= :delete
          options[:title] ||= "Delete this #{label}"
          return icon_to(icon, url, options)

        when 'ajaxdelete'
          # Delete a record with an id, ala user_path(user)
          # Fancy AJAX, so that it deletes the row in-place
          options[:url]      ||= send("#{meth}_path", args)
          options[:method]   ||= 'delete'
          show = options.delete(:show) || args.first
          target = show.is_a?(ActiveRecord::Base) ? "#{show.class.name.to_s.underscore}_#{show.to_param}" : "#{show.to_param}"
          #options[:update]   ||= target
          options[:success] ||= "$('#{options[:update]}').hide;alert('success');"

          # I hate that sometimes in Rails, you need a fucking :html subelement
          htmlopt = {:title => "Delete this #{label}"}

          # If no condition, set a toggle so that we tell if we have clicked
          # on the button, and can collapse it appropriately.
          unless options[:condition]
            options[:id] = "#{options[:update]}_icon"
          end
          return link_to_remote(icon_tag(type, :id => options[:id]), options, htmlopt)

        when 'list'
          # Main index, this does NOT have an id, ie users_path
          # Fancy AJAX, so that it expands/collapses a sub-row
          options_without_update = options.dup
          options_without_update.delete(:update)
          url = send("#{meth.pluralize}_path", options_without_update)
          show = options.delete(:show) || options.values.first
          target = show.is_a?(ActiveRecord::Base) ? "show_#{show.class.name.to_s.underscore}_#{show.to_param}" : "show_#{show.to_param}"
          options[:update]   ||= target
          options[:url]      ||= url
          options[:method]   ||= 'get'
          options[:complete] ||= "$('#{options[:update]}').show();"

          # I hate that sometimes in Rails, you need a fucking :html subelement
          htmlopt = {:title => "List #{label.pluralize}"}

          # If no condition, set a toggle so that we tell if we have clicked
          # on the button, and can collapse it appropriately.
          extra_js = ''
          unless options[:condition]
            options[:id] = "#{options[:update]}_icon"
            var = "loaded_#{options[:update]}"
            options[:before] =
                "#{var} = !#{var};" +
                " if (#{var}) { $('#{options[:update]}').hide();"+
                " $('#{options[:id]}').src = '#{icon_url(:show)}'; return false }"+
                " else { $('#{options[:id]}').src = '#{icon_url(:loading)}' }"
            options[:complete]  += "$('#{options[:id]}').src = '#{icon_url(:hide)}';"
            # Don't use javascript_tag or, ironically, Prototype chokes
            extra_js = '<script type="text/javascript">' +
                       "#{var} = true;" + '</script>'
          end
          return extra_js + link_to_remote(icon_tag(:show, :id => options[:id]), options, htmlopt)

        when 'show'
          # Show a record with an id, ala user_path(user)
          # Fancy AJAX, so that it expands/collapses a sub-row
          options[:url]      ||= send("#{meth}_path", args)
          options[:method]   ||= 'get'
          show = options.delete(:show) || args.first
          target = show.is_a?(ActiveRecord::Base) ? "show_#{show.class.name.to_s.underscore}_#{show.to_param}" : "show_#{show.to_param}"
          options[:update]   ||= target
          options[:complete] ||= "$('#{options[:update]}').show();"

          # I hate that sometimes in Rails, you need a fucking :html subelement
          htmlopt = {:title => "Show more about this #{label}"}

          # If no condition, set a toggle so that we tell if we have clicked
          # on the button, and can collapse it appropriately.
          extra_js = ''
          unless options[:condition]
            options[:id] = "#{options[:update]}_icon"
            var = "loaded_#{options[:update]}"
            options[:before] =
                "#{var} = !#{var};" +
                " if (#{var}) { $('#{options[:update]}').hide();"+
                " $('#{options[:id]}').src = '#{icon_url(:show)}'; return false }"+
                " else { $('#{options[:id]}').src = '#{icon_url(:loading)}' }"
            options[:complete]  += "$('#{options[:id]}').src = '#{icon_url(:hide)}';"
            # Don't use javascript_tag or, ironically, Prototype chokes
            extra_js = '<script type="text/javascript">' +
                       "#{var} = true;" + '</script>'
          end
          return extra_js + link_to_remote(icon_tag(type, :id => options[:id]), options, htmlopt)

        when 'view'
          # Like "show", but we changed it to "view" to indicate new page
          # main index, this does NOT have an id
          url = send("#{meth}_path", args)
          options[:title] ||= "View this #{label}"
          return icon_to(icon, url, options)
        else
          # This generic handler handles all other actions
          options[:title] ||= "#{type.titleize} this #{label}"
          if options[:url]
            url = options.delete(:url)
            url[:controller] ||= meth.pluralize if url.is_a? Hash
            url[:id] ||= args[:id] if url.is_a? Hash and args.is_a? Hash
          elsif type == meth
            # call "run_path" for "run_run_icon"
            url = send("#{meth}_path", args)
          else
            # call "review_revision_path" for "review_revision_icon"
            url = send("#{type}_#{meth}_path", args)
          end
          if options[:remote]
            htmlopt = {}
            htmlopt[:title] = options.delete(:title) if options.has_key?(:title)
            htmlopt[:id] = options.delete(:id) if options.has_key?(:id)
            options[:url] = url
            return link_to_remote(icon_tag(icon), options, htmlopt)
          else
            return icon_to(icon, url, options)
          end
        end
      end
      method_missing_without_icon_links(method_id, args)
    end
  end
end

# Override Rails CDATA JS wrapper because it kills AJAX requests (doh!)
#module ActionView::Helpers::JavaScriptHelper
#  def javascript_tag(content, html_options = {})
#    content_tag("script", content,
#                html_options.merge(:type => "text/javascript"))
#  end
#end

