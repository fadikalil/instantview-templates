~version: "2.0"

?domain: news\.harvard\.edu

?exists: //article[has-class("post")]
?exists: //article[has-class("page")]
?exists: //article[has-class("submissions")]

    $article: //main[@id="main"]/article[has-class("post")]
    $article?: //main[@id="main"]/article[has-class("page")]
    $article?: //main[@id="main"]/article[has-class("submissions")]

    @unsupported: $article//div[contains(@id, "kaltura_player")]

    <cite>: $article//*[has-class("article-media__photographer")]
    <cite>: $article//*[has-class("article-embed__figcaption-credit")]
    <cite>: $article//*[has-class("photo-layout__credit")]
    <cite>: $article//*[has-class("slideshow-caption-credit")]
    <cite>: $article//*[has-class("pull-quote__attribution")]

    <slideshow>: $article//div[has-class("story-slideshow")]
    $slideshow
    <figcaption>: $slideshow/div[has-class("slideshow-set-caption")]
    <figure>: $slideshow//ul/li
    <figcaption>: $slideshow//div[has-class("flex-caption")]

    <slideshow>: $article//div[has-class("photo-journal-content")]
    <span>: $$//a[has-class("photo-journal__permalink")] 
    @append("."): $@
    @after(" "): $@

    @replace("\\?.*", "?w=2560"): $article//img/@src

    cover: $article//figure[has-class("article-media__figure")]

    title: $article//h1[has-class("article-titles__title")]
    title: $article//h1[has-class("page-header__title")]
    subtitle: $article//h2[has-class("article-subtitle")]
    author: $article//*[has-class("article-author-name")]
    author: $article//*[has-class("article-author-affiliation")]
    #author: $article//*[has-class("article-contact-info__name")]


    published_date: //time[has-class("timestamp--published")]/@datetime

    @if ($article//div[has-class("article-contact")]) {
        @clone: $article//div[has-class("article-contact")]
        $contact: $@
    }
    $contact?: null

    <related>: $article//div[has-class("article-series")]
    $series: $@
    @remove: $series/div/p
    @append_to($article): $series

    @remove: $article/div[has-class("article-topper")]
    @remove: $article/div[has-class("article-preface")]
    @remove: //div[has-class("site-nav__content")]
    @remove: //div[has-class("article-sidebar")]
    #@remove: //div[has-class("gz-explore")]

    <related>: $article//div[has-class("gz-explore")]
    @map($article//related) {
        $rl: $@
        @map($rl/div[has-class("post")]) {
            $rlpost: $@
            $rllink: $rlpost/div[has-class("tz-explore__text")]/h2[has-class("tz-explore__title")]/a
            @append_to($rl/h3): $rllink
            @remove: $rlpost
        }
        #@debug: $rl
    }


    @remove: //div[has-class("article-content__daily-email-signup")]

    @remove: $article//div[has-class("youtube")]/embed
    @remove: $article//div[has-class("youtube")]/noframes

    @map($article//div[has-class("video_embed")]) {
        $videoembed: $@
        @before_el($videoembed): $videoembed/h3
    }

    <figure>: $article//div[has-class("video_embed")]
    <figcaption>: $article//div[has-class("video_embed_content")]

    @before_el(./..): $article//p[not(text())]/img
    <pic>: $article//p[text()]/img

    @map(//a/img) {
        $img: $@
        $parent: $img/parent::a
        $ownlink: $parent[contains(@href, "/wp-content/uploads/")]
        @if_not($ownlink) {
            @set_attr(href, $parent/@href): $img
        }
        @before_el($parent): $img
        @remove: $parent
    }

    <slideshow>: $article//div[has-class("photo-layout__images")]/parent::figure

    @remove: $article//*[has-class("jetpack-slideshow-noscript")]
    @map(//div[has-class("jetpack-slideshow")][@data-gallery]) {
        $gallery: $@
        @json_to_xml: $gallery/@data-gallery
        $dg: $@
        @map($dg/item) {
            <figure>: $@
            $fig: $@
            <img>: $fig/src
            $img: $@
            @replace("\\?.*", ""): $img
            @append("?w=2560"): $img
            @set_attr(src, $img/text()): $img
            @remove: $fig/alt
            #<figcaption>: $fig/caption
            @html_to_dom: $fig/caption
            <figcaption>: $@
            @append_to($fig): $@
            @remove: $fig/id
            @remove: $fig/title
            @remove: $fig/itemprop
            @remove: $fig/caption
        }
        @append_to($gallery): $dg
        <slideshow>: $gallery
    }


    <b>: $article//span[has-class("transcript-speaker")]

    body: $article

    @if ($contact) {
        <h4>: $contact/h3[has-class("article-contact__heading")]
        <b>: $contact//span[has-class("article-contact-info__name")]
        @wrap(<p>): $contact//p[has-class("article-contact-info")]/a
        @append(<hr>): $body
        @append_to($body): $contact
    }
