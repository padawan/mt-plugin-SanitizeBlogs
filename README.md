# SanitizeBlogs, a plugin for Movable Type

Authors: Six Apart Ltd.  
Copyright: 2009 Six Apart Ltd.  
License: [Artistic License 2.0](http://www.opensource.org/licenses/artistic-license-2.0.php)


## Overview

Specify HTML tags and attributes allowed in entry/page fields based upon blog URL prefix.

Functions in same manner as, but is distinct from, the [GlobalSanitizeSpec](http://www.movabletype.org/config/globalsanitizespec) configuration directive.

## Requirements

* MT 4.x


## Features

* define list of allowed html tags allowed in the following fields:
    * Title
    * Body
    * Extended
    * Excerpt
    * Keywords
* specify domain prefix for which 


## Documentation

### Allowed Tags

List of allowed HTML tags and tag attributes. Allowed Tags should be comma-separated. Allowed tag attributes should be space-separated and listed after the tag which they can be used with.

Sample value (allows `href` and `class` attribute on html `a` tag):

    a href class,b,cite,code class,em,i,img,li,ol,pre,strike,strong,ul

### Site URL Prefix

Non-allowed tags will be removed from entries created in blogs which have a Site URL beginning with the following URL. Must begin with "http://" or "https://".

Sample URL:

    http://www.domain.com/user-blogs/


## Installation

1. Move the SanitizeBlogs plugin directory to the MT `plugins` directory.

Should look like this when installed:

    $MT_HOME/
        plugins/
            SanitizeBlogs/

[More in-depth plugin installation instructions](http://tinyurl.com/easy-plugin-install).


## Desired Feature Wish List

* add wish-list item here


## Support

This plugin is not an official Six Apart Ltd. release, and as such support from Six Apart Ltd. for this plugin is not available.
