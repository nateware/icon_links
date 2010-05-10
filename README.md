Icon Links - Change boring Rails text links to sexy icon_to links
=================================================================
Rails comes with `link_to`, `link_to_remote`, and other helpers to easily create text links.  But it's 2010.  I remember being impressed by text links.  It was 1995.

This gem enables you to easily create links using icons of your choosing.  It provides handy Rails view helper methods that encapsulate repetitive tasks, such as resolving image paths.  This gem works great with the venerable [Fam Fam Fam Silk Icons](http://www.famfamfam.com/lab/icons/silk/), but it also works equally well with any other icon set you have as well.

Example
=======
If you download the [Silk Icons](http://www.famfamfam.com/lab/icons/silk/) and unzip them to `public/images/icons`, you then only need to change the standard Rails `link_to` idioms:

    link_to 'Show', post_path(@post)
    link_to 'Edit', edit_post_path(@post)
    link_to 'Destroy', post_path(@post), :confirm => 'Are you sure?', :method => :delete
    link_to 'Back', post_path

To use `icon_to`:

    icon_to :show, post_path(@post)
    icon_to :edit, edit_post_path(@post)
    icon_to :delete, post_path(@post), :confirm => 'Are you sure?', :method => :delete
    icon_to :back, posts_path

And you'll get snazzy, linked silk icons that will make you cry.

You can even go one fancier, and use REST route helpers with an `_icon` suffix:

    post_icon(@post)
    edit_post_icon(@post)
    delete_post_icon(@post, :confirm => 'Are you sure?', :method => :delete)

Yeah, this plugin is simple and sweet.  Sugary, like candy.

If you want to relocate your icons or choose a different image type:

    IconLinks.icon_image_url    = '/images/thingies'
    IconLinks.icon_image_suffix = '.gif'

You can also create completely custom mappings of icons to paths:

    IconLinks.custom_icon_images = {
      :loading => "/images/misc/loading.gif"
    }

Now, you can do:

    icon_to :loading, loading_path

And you will get your custom icon.

Author
======
Copyright (c) 2008-2010 [Nate Wiger](http://nateware.com).  All Rights Reserved.
Released under the MIT license.
