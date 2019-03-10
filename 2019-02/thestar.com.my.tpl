~version: "2.0"

site_name: "The Star Online"

$main: //main[has-class("content-wrap")]
#$story: $main//div[has-class("story relative")]
$story: $main//div[has-class("story") and contains(@id, "storyDiv")]
$album: $main//div[has-class("album-content")]

?exists: /html/head/script[@data-type="application/ld+json"]/text()
  @json_to_xml: /html/head/script[@data-type="application/ld+json"]/text()
  $frontmatter: $@
  @debug: $@
  @html_to_dom: $frontmatter/headline
  title: $@
  @combine(", "): $frontmatter/creator[not(.="The Star Online")]/next-sibling::item
  author: $@
  author: $frontmatter/creator[not(.="The Star Online")]
  published_date: $frontmatter/dateCreated
  
?exists: //meta[@name="parsely-metadata"]/@content
  @json_to_xml: //meta[@name="parsely-metadata"]/@content
  $meta: $@
  @html_to_dom: $meta/image_url
  image_url: $@
  @debug: $meta

?exists: $story

  @urlencode: $meta/guid
  $guid: $@/text()
  
  $loadmorebtn: $main//a[contains(@onclick, "loadFull")]
  @if ($loadmorebtn) {
    @append(<iframe>): $story
    $full: $@
    @set_attr(data-guid, $guid): $full
    @set_attr(src, "https://www.thestar.com.my/api/readmore/get/", @data-guid, "\\/"): $full
    @inline: $full
    @html_to_dom: $@
  }

  <figure>: $main//div[has-class("story-image")]
  $cover: $@
  <figcaption>: $$/p[has-class("caption")]
  cover: $cover
 
  <figure>: $story//div[has-class("embeded-image")]
  <figcaption>: $@/div[has-class("inline-caption")]
  
  <pic>: $story//img[has-class("go-chart")]
  
  @before_el(./..): $story//p[not(text())]/img
  @before_el(./../..): $story//p[not(text())]/span/img
  
  <div>: $story//p/iframe/parent::p
  
  <video>: $story//iframe[ends-with(@src, ".mp4")]
  <video>: $story//iframe[contains(@src, "clips.thestar.com.my")]
  @replace("%0A", ""): $story//video/@src
  
  body: $story
  
  @unsupported: $main//div[has-class("premium-access")]
  @if ($meta/is_premium[.="1"]) {
    body!!: null
  }
  
  $video_script: $main//script[contains(@src, "jwplatform.com/players")]
  @if ($video_script){
    @debug: "Video!"
    body!!: null
  }
  
  <related>: $main//div[@id="related-stories-div"]
  @append_to($body): $@
  
  <related>: $story//p[./strong[contains(text(), "Related stories:")]]
  $relstor: $@
  <h3>: $relstor/strong
  @append_to($relstor): $relstor/following-sibling::p

?exists: $album
!false
  subtitle: $meta/summary
  $smallgallerylist: $album//div[has-class("gallery-list")]
  $firstlink: ($smallgallerylist//a/@href)[1]
  @debug: $firstlink
  @after(<iframe>): $album
  $biggalleryiframe: $@
  @set_attr(src, "https://www.thestar.com.my/", $firstlink): $biggalleryiframe
  @inline: $biggalleryiframe
  $biggallerylist: $@
  $photolist: $biggallerylist//main//div[has-class("slick-list")]//div[@role="listbox"]
  @debug: $biggallerylist//main//div[has-class("photos-wrap")]
  
  @replace("\\?w=.+", "?w=2560"): $body//img/@src
  @map($body//a/img) {
    $img: $@
    $parent: $img/parent::a
    $ownlink: $parent[contains(@href, "/photo/")]
    @if_not($ownlink) {
      @set_attr(href, $parent/@href): $img
    }
    @before_el($parent): $img
    @remove: $parent
  }
  <figure>: $body//div[has-class("img-wrap")]
  <figcaption>: $$/div[has-class("img-caption")]
  