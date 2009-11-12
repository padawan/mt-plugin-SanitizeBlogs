package SanitizeBlogs;

use strict;

sub _sanitize_entry {
    my ($cb, $app, $entry, $orig) = @_;
    my $plugin = $cb->plugin;

    my $sanitize_spec = $plugin->get_config_value('sanitizeblogs_sanitizespec');
    return 1 unless $sanitize_spec;
    my $url_prefix = $plugin->get_config_value('sanitizeblogs_urlprefix');
    return 1 unless $url_prefix =~ m!^https?://.+!;

    require MT::Entry;
    require MT::Blog;
    require MT::Sanitize;

    my $blog_id = $entry->blog_id;
    my $blog = $app->model('blog')->load($blog_id);
    return $cb->errtrans("Invalid blog ID") unless $blog;
    my $site_url = $blog->site_url;

    return 1 unless $site_url =~ m!^$url_prefix!;

    my $title = $entry->title;
    $title = $title ? MT::Sanitize->sanitize( $title, $sanitize_spec ) : $title;
    $entry->title($title);

    my $text = $entry->text;
    $text = $text ? MT::Sanitize->sanitize( $text, $sanitize_spec ) : $text;
    $entry->text($text);

    my $more = $entry->text_more;
    $more = $more ? MT::Sanitize->sanitize( $more, $sanitize_spec ) : $more;
    $entry->text_more($more);

    my $excerpt = $entry->excerpt;
    $excerpt = $excerpt ? MT::Sanitize->sanitize( $excerpt, $sanitize_spec ) : $excerpt;
    $entry->excerpt($excerpt);

    my $keywords = $entry->keywords;
    $keywords = $keywords ? MT::Sanitize->sanitize( $keywords, $sanitize_spec ) : $keywords;
    $entry->keywords($keywords);

    return 1;
}

sub config_template {
    my ($plugin, $param) = @_;

    my $form = <<HTML;
<mtapp:setting
    id="sanitizeblogs_sanitizespec"
    label="<__trans phrase="Sanitize Spec">"
    hint="<__trans phrase="List of HTML tag names to allow, separated by commas. For each HTML tag, any attributes to be allowed for that tag should also be listed, separated by spaces. Functions in same manner as, but is distinct from, Movable Type's GlobalSanitizeSpec configuration setting.">"
    show_hint="1">
    <input type="text" size="75" name="sanitizeblogs_sanitizespec" id="sanitizeblogs_sanitizespec" value="<mt:var name="sanitizeblogs_sanitizespec" escape="html">" />
</mtapp:setting>

<mtapp:setting
    id="sanitizeblogs_urlprefix"
    label="<__trans phrase="Site URL Prefix">"
    hint="Sanitize Spec setting will be applied to community entries created in blogs which have a Site URL beginning with this setting. Must begin with http:// or https://."
    show_hint="1">
    <input type="text" size="75" name="sanitizeblogs_urlprefix" id="sanitizeblogs_urlprefix" value="<mt:var name="sanitizeblogs_urlprefix" escape="html">" />
</mtapp:setting>
HTML

    return $form;

}

1;
