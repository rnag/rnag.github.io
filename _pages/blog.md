---
layout: single
title: "My Blog"
permalink: /blog/
author_profile: true
---

{% assign blog_posts = site.categories.blog %}
{% assign featured_posts = blog_posts | where: "sticky", true | sort: "sticky_order" %}

## Featured

{% for post in featured_posts %}
{% include archive-single.html %}
{% endfor %}

## Latest Posts

{% for post in blog_posts %}
{% unless post.sticky == true %}
{% include archive-single.html %}
{% endunless %}
{% endfor %}
