# IconLinks
require 'active_support/core_ext/module/attribute_accessors'

module IconLinks
  # Relative path to the icons
  mattr_accessor :icon_image_url
  @@icon_image_url = '/images/icons'

  # Full suffix including the "."
  mattr_accessor :icon_image_suffix
  @@icon_image_suffix = '.png'

  # Special icons
  mattr_accessor :custom_icon_images
  @@custom_icon_images = {
    'loading' => "#{@@icon_image_url}/loading.gif"
  }

  # Prefixes to automagically remove within auto-generated labels e.g. 'admin_'
  mattr_accessor :remove_prefixes_for_labels
  @@remove_prefixes_for_labels = []

  def self.included(base)
    base.class_eval do
      include ::IconLinks::ViewHelpers
      include ::IconLinks::MethodMissing
      alias_method_chain :method_missing, :icon_links
    end
  end
end

require 'icon_links/view_helpers'
require 'icon_links/method_missing'

ActionView::Base.send :include, IconLinks if defined?(ActionView::Base)
