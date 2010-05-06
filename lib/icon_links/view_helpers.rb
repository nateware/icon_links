# methods for making links and help stuff
module IconLinks
  module ViewHelpers
    @@icon_url_cache = {}

    # This creates a link using the specified type of icon. The args
    # accepted are the exact same as the args for +link_to+.
    def icon_to(text, *args)
      if args.first.is_a?(Hash)
        return icon_tag(:clear) unless args[0].delete(:if)
      end
      link_to(icon_for(text), *args)
    end

    # This creates a link using the specified type of icon. The args
    # accepted are the exact same as the args for +link_to_remote+.
    def icon_to_remote(text, *args)
      if args.first.is_a?(Hash)
        return icon_tag(:clear) unless args[0].delete(:if)
      end
      link_to_remote(icon_for(text), *args)
    end

    # This is similar to icon_to, only it is designed to call a JS function
    def function_icon(text, function)
      link_to(icon_for(text), '#', :onclick => function)
    end

    # This expands the text and returns the icon path. It is used internally
    # by +icon_to+ and +icon_to_remote+ to render the link text.
    def icon_for(text, excess=nil)
      link = nil
      if text.is_a? Array
        # array
        icon = icon_tag(text.first)
        link = cat(icon, text.last)
      else
        link = icon_tag(text)
      end
      link += excess if excess
      link
    end

    # Can't normalize this with above because calls to this want to exclude help
    def icon_url(type)
      name = type.to_s
      return @@icon_url_cache[name] if @@icon_url_cache[name]
      # Can't normalize this with above because calls to this want to exclude help
      @@icon_url_cache[name] ||= IconLinks.custom_icon_images[name] ||
               File.join(IconLinks.icon_image_url, name + IconLinks.icon_image_suffix)
    end

    # This retrieves the assigned icon from the System object,
    # then returns suitably-formatted HTML. It does some simple
    # caching for each icon URL as well.
    def icon_tag(type, options={})
      name = type.to_s
      png_image_tag icon_url(type), {
        :class => 'icon', :border => 0, :alt => name.humanize,
        :width => 16, :height => 16
      }.update(options)
    end

    # This returns a help link similar to +icon_to+, only using the help
    # from the system_help table. If no help is found, then an empty
    # string is returned (allowing you to randomly call this on any
    # object, without having to check if help exists first).
    def help_for(help_topic, icon=:help)
      help = help_text(help_topic)
      help == '' ? '' : help_icon(help, icon)
    end

    # Return help text, suitable for use as a help tooltip box thingy
    # Note: Comma escaping is a workaround for a workaround, in the
    # hacks to dhtmlXGrid to support "img:[/path Plain Text],b" <-- comma
    def help_text(help_topic)
      help = SystemHelp.topic(help_topic)
      help ? help.help_text.to_s.gsub('&','&amp;').
              gsub('"','&quot;').gsub('<','&lt;').
              gsub('>','&gt;').gsub(',','&#044;') : ''
    end

    # Creates the icon to pop up the help bubble
    def help_icon(help_text, icon=:help)
      return '' unless help_text
      return %Q(<a href="#" title="#{help_text}" onclick="return false">#{icon_tag(icon, :class => 'help')}</a>)
    end

    # This is similar to help_for(), but it instead looks up the description
    # for a field on a per-table basis. For example, desc_of :life_cycle, 'QA'
    # would look up life_cycles where life_cycle = 'QA' and return life_cycle.description
    def desc_of(class_symbol, field_val)
      class_name = class_symbol.to_s.camelize
      row = nil
      eval "row = #{class_name}.find(:first, :conditions => ['name = ?', field_val])"
      return '' unless row
      help_icon row.description
    end

    # This is a hack needed for IE, adapted from http://koivi.com/ie-png-transparency/
    def png_image_tag(image, options={})
      image = icon_url image if image.is_a?(Symbol)
      begin
        # When called from table_form_builder, request does not exist and raises exception
        if image =~ /\.png$/i && request.user_agent.downcase =~ /msie\s+(5\.[5-9]|[6]\.[0-9]*).*(win)/
          options[:style] ||= ''
          options[:style] += "filter: progid:DXImageTransform.Microsoft.AlphaImageLoader" +
                             "(src=&quot;#{image}&quot;,sizingMethod=&quot;scale&quot;);"
          image = System.clear_png_url    # reset image to clear png
        end
      rescue
        # In FormBuilder, so write it to the builder
        @template.image_tag image, options
      else
        # Return a string
        image_tag image, options
      end
    end

    # Creates an expandable toggleable div
    def expandable_tag(type, options)
      toggle_tag(type, options, :expand, :collapse)
    end

    # Creates a collapsible div
    def collapsible_tag(type, options)
      toggle_tag(type, options, :collapse, :expand)
    end

    # "Raw" function that can be used to create an expand/collapse tag
    def toggle_tag(type, options, first_icon, alt_icon)

      target = options[:id]
      if !target
        if options.has_key?(:show)
          show = options[:show]
          target = show.is_a?(ActiveRecord::Base) ? "show_#{show.class.name.to_s.underscore}_#{show.to_param}" \
                                                  : "show_#{show.to_param}"
        else
          target = 'toggle'
        end
      end

      options[:style] = 'display:none;' + (options[:style]||'')
      var = "toggle_#{target}"
      img = "icon_for_#{var}"
      %(<script type="text/javascript">#{var} = true;</script>) +
      %(<a href="#" onclick="#{var} = !#{var}; $('#{target}').toggle();) +
      %( if (#{var}) { $('#{img}').src = '#{icon_url(first_icon)}'; })+
      %( else { $('#{img}').src = '#{icon_url(alt_icon)}'; }) +
      %(">#{icon_tag(first_icon, :id => img)}#{options[:label]||''}</a>)
    end
  end
end
