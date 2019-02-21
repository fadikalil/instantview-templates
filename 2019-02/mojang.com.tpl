~version: "2.0"

?exists: //div[has-class("post")]
?exists: //div[has-class("page")]
!not_exists: //ul[has-class("post-list")]

  cover: //div[has-class("post-header__image")]/img
  cover: //div[has-class("post-header__image")]/div/iframe

  title: //div[has-class("post-title")]
  site_name: "Mojang"

  body: //article[has-class("post-content")]

  $article: //article[has-class("post-content")]

  @clone: //p[has-class("post-meta")]/text()
  #@detach: $@
  $meta: $@

  @match("Posted on (.+)", 1): $meta
  @datetime(0): $@
  published_date: $@

  #@debug:  //p[has-class("post-meta")]

  @match("by (.+)", 1): (//p[has-class("post-meta")]/text())[2]
  author: $@

  @map($article//a/img) {
    $img: $@
    $parent: $img/parent::a
    @set_attr(href, $parent/@href): $img
    @before_el($parent): $img
    @remove: $parent
  }

  @map($article//p/img) {
    $img: $@
    $figcap: $img/parent::p[text()]
    @if ($figcap) {
      @wrap(<figure>): $img
      $fig: $@
      @before_el(./..): $fig
      <figcaption>: $figcap
      @append_to($fig): $@
    }
  }

  @before_el(./..): //p/img

  @set_attr(src, "https://twitter.com/i/status/", @data-tweet-id): //iframe[has-class("twitter-tweet")]

?domain: help\.mojang\.com
!false # decided not to support it due to incoming issues
!path: .+/portal/articles/.+
!exists: //div[has-class("content")]
!path_not: .+/portal/articles/search.+
!not_exists: //*[contains(text(), "currently replying")]

  $article: //div[has-class("content")]

  title: $article//h2
  body: $article//div[has-class("body")]
  @datetime(+2): $article//div[has-class("footer")]//time
  published_date: $@

?path: /about.*

  $article: //article[has-class("post-content")]

  cover!: //figure[has-class("img-overflow")]
  @debug: //figure[has-class("img-overflow")]
  title: //h1[@id="about"]

