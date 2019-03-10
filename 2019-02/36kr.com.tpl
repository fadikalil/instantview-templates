~version: "2.0"
site_name!!: "36氪"

?domain: www\.36kr\.com
    $base_domain: "www.36kr.com"

?domain: 36kr\.com
    $base_domain: "36kr.com"

#?exists: //div[has-class("kr-article")]
?domain: www\.36kr\.com
!path: /p/.+
    @debug: "Route kr-article"
    $jsondata: //div[@id="app"]/next-sibling::script
    @replace("window.initialState=", ""): $jsondata
    @json_to_xml: $@
    $doc: $@/articleDetail/articleDetailData/data

?domain: 36kr\.com
!path: /p/.+
#?exists: //div[@id="pc-loader"]
    @debug: "Route pc-loader"

    $jsondata: //div[@id="app"]/next-sibling::script
    @replace("var props=", ""): $jsondata
    @replace(",locationnal.+", "", "m"): $@
    @json_to_xml: $@
    $doc: $@/item[1]

?domain: www\.36kr\.com
?domain: 36kr\.com
!path: /p/.+

    @html_to_dom: $doc/title
    title: $@

    @html_to_dom: $doc/summary
    description: $@
    $shortdescription: $description[string-length() <= 20]
    @if ($shortdescription) {
        subtitle: $$
    }

    $cover_url: $doc/cover/text()
    image_url: $cover_url

    @html_to_dom: $doc/content
    $content: $@

    body: $content

    @datetime(+8): $doc/published_at
    published_date: $@

    @html_to_dom: $doc/user/name
    author: $@

    @append(<user_url>): $doc
    @set_attr(href, "https://", $base_domain ,"\\/user/", $doc/user_id): $@
    author_url: $$/@href

    <related>: $doc/related_posts
    @map($@/item) {
        <a>: $@
        @set_attr(href, "https://", $base_domain, "\\/p/", $@/id, "\\.html"): $@
    }
    @prepend(<h3>): $doc/related
    @append("相关文章"): $@
    @append_to($body): $doc/related

    @if($doc/audios[./item]) {
        $audios: $@
        @map($@/item) {
            <audio>: $@
            $audio: $@
            @set_attr(src, $audio/url): $audio
            @wrap(<figure>): $audio
            $fig: $@
            @append(<figcaption>): $fig 
            $cap: $@
            @html_to_dom: $audio/title
            $audio_title: $@/text()
            @set_attr(title, $audio_title): $audio
            @append_to($cap): $audio_title
        }
        @prepend_to($body): $audios
        @after(<hr>): $@
    }
    $has_paywall: $content//a[contains(text(), "已购用户")]
    $has_paywall+: $content//a[contains(@href, "36kr.com/goods/p/")]

    @if ($has_paywall) {
        @debug: "has paywall"
        body!!: null
    }

    <hr>: $body//p[starts-with(text(), "————")]
    <hr>: $body//p[starts-with(text(), "------------")]
    <hr>: $body//p[starts-with(text(), ">>>>>>>>")]
    
    <h4>: $body//blockquote[./p/strong and string-length(./p/strong) < 30]

    @if_not($shortdescription) {
        @prepend(<hr>): $body
        @clone: $description
        @prepend_to($body): $@
        @wrap(<blockquote>): $@
    }
    
    <blockquote>: $body//address[string-length(./p) >= 30 or contains(@style, "font-style: normal")]
    <h4>: $body//address[string-length(./p) < 30]

    #<cite>: $body//blockquote/p[starts-with(., "——")]
    #<cite>: $body//blockquote/p[starts-with(., "--")]

    @map($body//a/img) {
        $img: $@
        $parent: $img/parent::a
        @set_attr(href, $parent/@href): $img
        @before_el($parent): $img
        @remove: $parent
    }

    #@replace("!heading", "!1200"): $body//img/@src
    @replace("!heading", "!1200"): $body//img/@src[contains(., "pic.36krcnd.com")]
    @replace("!heading", ""): $body//img/@src[contains(., "a.36krcnd.com")]
    #@replace("!1200", ""): $body//img/@src

    @remove: $body//p[not(text()) and ./span[not(text()) and not (*)]]

    @before_el(./..): $body//em/img
    @before_el(./..): $body//span/img
    
    @set_attr(class, ""): $body//p[has-class("img-desc")][./img]

    @combine(<br>): $body//p[has-class("img-desc")][./prev-sibling::p[has-class("img-desc")]]

    @map($body//img) {
        $img: $@
        $figcap: $img/parent::p/next-sibling::p[has-class("img-desc")]
        $figcap?: $img/next-sibling::p[has-class("img-desc")]

        @wrap(<figure>): $img
        $fig: $@
        @if ($figcap) {
            <figcaption>: $figcap
            @append_to($fig): $@
        }
    }

    @map($body//figure) {
        $img: $@
        $parent: $img/parent::p
        #@before_el($parent): $img
        <div>: $parent
        @if ($parent[not(text())]) {
            @remove: $parent
        }
        #@remove: $parent
    }

?domain: www\.36kr\.com
!path: /newsflashes/.+
#?exists: //div[has-class("kr-newsflash-detail")]
    @debug: "Route kr-newsflash-detail"

    $jsondata: //div[@id="app"]/next-sibling::script
    @replace("window.initialState=", ""): $jsondata
    @json_to_xml: $@
    $doc: $@/newsflashDetail/detailData/data

?domain: 36kr\.com
!path: /newsflashes/.+
    $jsondata: //div[@id="app"]/next-sibling::script
    @replace("var props=", ""): $jsondata
    @replace(",locationnal.+", "", "m"): $@
    @json_to_xml: $@
    $doc: $@/item[1]

?domain: www\.36kr\.com
?domain: 36kr\.com
!path: /newsflashes/.+
    @html_to_dom: $doc/title
    title: $@

    @html_to_dom: $doc/description
    body: $@
    description: $$/text()

    $cover_url: $doc/cover
    @if_not($cover_url[text()=""]) {
        @after(<img>, "src", $cover_url/text()): $doc/cover
        cover: $@
        image_url: $cover_url/text()
    }

    @datetime(+8): $doc/published_at
    published_date: $@

    @html_to_dom: $doc/user/name
    author: $@


    @append(<user_url>): $doc
    @set_attr(href, "https://", $base_domain ,"\\/user/", $doc/user_id): $@
    author_url: $$/@href

    image_url: $doc/cover/text()

    @append(<p>): $body
    @append(<a>, href, $doc/news_url): $@
    $newslink: $@
    @html_to_dom: $doc/news_url_title
    @append_to($newslink): $@
?domain: 36kr\.com
!path: /video/.+

    $jsondata: //div[@id="app"]/next-sibling::script
    @replace("var props=", ""): $jsondata
    @replace(",locationnal.+", "", "m"): $@
    @json_to_xml: $@
    $doc: $@/item[1]

?domain: www\.36kr\.com
!path: /video/.+

    $jsondata: //div[@id="app"]/next-sibling::script
    @replace("window.initialState=", ""): $jsondata
    @json_to_xml: $@
    $doc: $@/videoDetail/data

?domain: 36kr\.com
?domain: www\.36kr\.com
!path: /video/.+

    @html_to_dom: $doc/title
    title: $@

    @html_to_dom: $doc/summary
    $summary: $@
    @clone: $summary
    description: $@

    $cover_url: $doc/cover/text()
    image_url: $cover_url

    @datetime(+8): $doc/published_at
    published_date: $@

    @html_to_dom: $doc/user/name
    author: $@

    @append(<user_url>): $doc
    @set_attr(href, "https://", $base_domain ,"\\/user/", $doc/user_id): $@
    author_url: $$/@href

    @append(<video>, src, $doc/url): $doc
    $video: $@
    @append(" "): $video
    @wrap(<article>): $video
    body: $@
    @append_to($body): $summary


?domain: www\.36kr\.com
!path: /topics/.+
    title: //h1[has-class("topic-title")]
    description: //div[has-class("topic-detail-desc")]
