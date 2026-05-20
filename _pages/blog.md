---
layout: single
title: "My Blog"
permalink: /blog/
author_profile: true
---

## Featured

<div class="archive__item">
  <h2 class="archive__item-title">
    <a href="/blog/half-marathons-by-state/">
      Half Marathons by State
    </a>
  </h2>

  <p class="archive__item-excerpt">
    My journey to run a half marathon in every state, with race results, travel notes, and pre-race food stops.
  </p>
</div>

## Latest Posts

{% assign blog_posts = site.categories.blog %}
{% for post in blog_posts %}
  {% unless post.url == "/blog/half-marathons-by-state/" %}
    {% include archive-single.html %}
  {% endunless %}
{% endfor %}
