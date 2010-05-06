Icon Links - Change boring Rails text links to sexy icon_to links
=================================================================
Easily link icons of your choosing, by using the handy Rails helpers included in this plugin.  Works great with Silk icons, but will work equally well for any other icon set you have as well.  This is basically a set of shortcuts around the standard Rails REST routes and url helpers.

Example
=======
If you download the [Fam Fam Fam Silk Icons](http://www.famfamfam.com/lab/icons/silk/) and unzip them to `public/images/icons`, you then only need to change the standard Rails idioms:

    link_to 'Show', post_path(@post)
    link_to 'Edit', edit_posts_path(@post)
    link_to 'Destroy', posts_path(@post), :confirm => 'Are you sure?', :method => :delete
    link_to 'Back', posts_path

To:

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

Author
======
Copyright (c) 2008-2010 [Nate Wiger](http://nateware.com).  All Rights Reserved.
Released under the MIT license.
