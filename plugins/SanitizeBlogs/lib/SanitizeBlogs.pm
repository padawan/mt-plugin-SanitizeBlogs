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
    label="<__trans phrase="Allowed Tags">"
    hint='<__trans phrase="List of allowed HTML tags and tag attributes. Allowed Tags should be comma-separated. Allowed tag attributes should be space-separated and listed after the tag which they can be used with. eg. &quot;a href,em,strong&quot; (Functions in same manner as, but is distinct from, the <a href="[_1]">GlobalSanitizeSpec</a> configuration setting.)" params="http://www.movabletype.org/config/globalsanitizespec">'
    show_hint="1">
    <input type="text" size="70" name="sanitizeblogs_sanitizespec" id="sanitizeblogs_sanitizespec" value="<mt:var name="sanitizeblogs_sanitizespec" escape="html">" />
</mtapp:setting>

<mtapp:setting
    id="sanitizeblogs_urlprefix"
    label="<__trans phrase="Site URL Prefix">"
    hint='Non-allowed tags will be removed from entries created in blogs which have a Site URL beginning with the following URL. eg "http://www.domain.com/user-blogs/"'
    show_hint="1">
    <input type="text" size="70" name="sanitizeblogs_urlprefix" id="sanitizeblogs_urlprefix" value="<mt:var name="sanitizeblogs_urlprefix" escape="html">" />
</mtapp:setting>
HTML

    return $form;

}

1;
