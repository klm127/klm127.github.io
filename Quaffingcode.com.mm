<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Quaffingcode.com layout" FOLDED="false" ID="ID_1638468080" CREATED="1612660369392" MODIFIED="1612660419267" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle" background="#333333">
    <properties show_icon_for_attributes="true" fit_to_viewport="false" show_note_icons="true" edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24.0 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ICON_SIZE="12.0 pt" COLOR="#ffffff" BACKGROUND_COLOR="#333333" STYLE="fork">
<font NAME="Consolas" SIZE="10" BOLD="false" ITALIC="false"/>
<edge STYLE="linear" COLOR="#474747"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details" COLOR="#000066" BACKGROUND_COLOR="#33ccff" STYLE="bubble" TEXT_ALIGN="LEFT" BORDER_WIDTH_LIKE_EDGE="true" BORDER_COLOR_LIKE_EDGE="true">
<font NAME="Consolas" SIZE="10"/>
<edge STYLE="bezier" COLOR="#33ccff" WIDTH="1"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes" COLOR="#50d750" BACKGROUND_COLOR="#042004" BORDER_WIDTH_LIKE_EDGE="true" BORDER_COLOR_LIKE_EDGE="true" BORDER_DASH_LIKE_EDGE="true" BORDER_DASH="SOLID">
<font SIZE="9" ITALIC="false"/>
<edge STYLE="horizontal" WIDTH="1"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#fffaf2" BACKGROUND_COLOR="#000066">
<font NAME="Consolas" SIZE="12"/>
<edge STYLE="bezier" COLOR="#000066" WIDTH="1"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.floating" COLOR="#ffffe0" BACKGROUND_COLOR="#4c384c" BORDER_WIDTH="0.0 px">
<font SIZE="14"/>
<edge STYLE="hide_edge"/>
<cloud COLOR="#353535" SHAPE="RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#ccccff" BACKGROUND_COLOR="#000000" STYLE="fork">
<font NAME="Liberation Sans" SIZE="20" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#ffffff" BACKGROUND_COLOR="#006666" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
<edge COLOR="#009900"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#0000ff" BACKGROUND_COLOR="#ccccff">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10.0 pt" SHAPE_VERTICAL_MARGIN="10.0 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439" BORDER_WIDTH_LIKE_EDGE="true" BORDER_COLOR_LIKE_EDGE="true" BORDER_DASH_LIKE_EDGE="true">
<edge STYLE="bezier" COLOR="#ffff99" WIDTH="1" DASH="SOLID"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" BACKGROUND_COLOR="#d6d6d6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5" COLOR="#000066" BACKGROUND_COLOR="#33ccff" STYLE="bubble" TEXT_ALIGN="LEFT" BORDER_WIDTH_LIKE_EDGE="true" BORDER_COLOR_LIKE_EDGE="true">
<font NAME="Consolas" SIZE="12"/>
<edge STYLE="bezier" COLOR="#33ccff" WIDTH="1"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6" COLOR="#ccffcc">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11" COLOR="#ccffcc">
<font SIZE="14"/>
</stylenode>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="40" RULE="ON_BRANCH_CREATION"/>
<node TEXT="Site Components" LOCALIZED_STYLE_REF="styles.topic" POSITION="right" ID="ID_335901841" CREATED="1612660489024" MODIFIED="1612660558061">
<node TEXT="includes" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_116217697" CREATED="1612660519893" MODIFIED="1612660650951">
<node TEXT="diqus_comments" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_334435574" CREATED="1612660900898" MODIFIED="1612660958411" BACKGROUND_COLOR="#000066">
<node TEXT="adds discuss if enabled" ID="ID_932597560" CREATED="1612661302793" MODIFIED="1612661307914"/>
</node>
<node TEXT="external-scripts" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_474589979" CREATED="1612660908030" MODIFIED="1612660961272" BACKGROUND_COLOR="#000066">
<node TEXT="includes external-js-dependencies" ID="ID_1206571286" CREATED="1612661271898" MODIFIED="1612661284002"/>
<node TEXT="includes custom-css-lists" ID="ID_157418501" CREATED="1612661286933" MODIFIED="1612661294947"/>
</node>
<node TEXT="footer" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1572474008" CREATED="1612660920997" MODIFIED="1612660921956" BACKGROUND_COLOR="#000066">
<node TEXT="puts social, site description, and contact list if avail" ID="ID_895821347" CREATED="1612661250583" MODIFIED="1612661267355"/>
</node>
<node TEXT="google-analytics" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1756392353" CREATED="1612660922127" MODIFIED="1612660924728" BACKGROUND_COLOR="#000066">
<node TEXT="creates google analytics" ID="ID_1654515806" CREATED="1612661148047" MODIFIED="1612661151780"/>
</node>
<node TEXT="head" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_945923756" CREATED="1612660927675" MODIFIED="1612660928783" BACKGROUND_COLOR="#000066">
<node TEXT="meta props" ID="ID_1015982186" CREATED="1612661081067" MODIFIED="1612661083491"/>
<node TEXT="icon" ID="ID_756574898" CREATED="1612661083671" MODIFIED="1612661084690"/>
<node TEXT="main stylsheet" ID="ID_325032598" CREATED="1612661086205" MODIFIED="1612661090699">
<font BOLD="true"/>
</node>
<node TEXT="canonical url" ID="ID_1152712079" CREATED="1612661091290" MODIFIED="1612661100663">
<font BOLD="true"/>
</node>
<node ID="ID_736987660" CREATED="1612661102567" MODIFIED="1612661113065"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <p>
      <b>external scripts.html</b>
    </p>
  </body>
</html>
</richcontent>
<font BOLD="false"/>
</node>
<node TEXT="if production, analytics includes" ID="ID_1463840782" CREATED="1612661113541" MODIFIED="1612661123559">
<font BOLD="false"/>
</node>
</node>
<node TEXT="header" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1081730403" CREATED="1612660928945" MODIFIED="1612660929926" BACKGROUND_COLOR="#000066">
<node TEXT="title image" ID="ID_1751784445" CREATED="1612661034236" MODIFIED="1612661035744"/>
<node TEXT="site-nav" ID="ID_156946533" CREATED="1612661044150" MODIFIED="1612661046061">
<node TEXT="for page in page_paths..." ID="ID_490572152" CREATED="1612661049139" MODIFIED="1612661073259"/>
</node>
</node>
<node TEXT="hitstep-analytics" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_935050368" CREATED="1612660930115" MODIFIED="1612660932621" BACKGROUND_COLOR="#000066">
<node ID="ID_1152456049" CREATED="1612661014584" MODIFIED="1612661023477"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <p>
      <font color="#cc0000">remove</font>
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="icon-github.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1549421265" CREATED="1612660932842" MODIFIED="1612660937085" BACKGROUND_COLOR="#000066">
<node TEXT="span" ID="ID_287328450" CREATED="1612661012204" MODIFIED="1612661013048"/>
</node>
<node TEXT="icon-github.svg" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1958814825" CREATED="1612660937264" MODIFIED="1612660940425" BACKGROUND_COLOR="#000066"/>
<node TEXT="icon-twitter.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_169250719" CREATED="1612660940596" MODIFIED="1612660942863" BACKGROUND_COLOR="#000066">
<node TEXT="span" ID="ID_769643105" CREATED="1612661010002" MODIFIED="1612661011171"/>
</node>
<node TEXT="icon-twitter.vg" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_718472407" CREATED="1612660943026" MODIFIED="1612660947525" BACKGROUND_COLOR="#000066"/>
<node TEXT="snippet-in-page.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_500304180" CREATED="1612660947720" MODIFIED="1612660951027" BACKGROUND_COLOR="#000066">
<node TEXT="stick a script from assets folder into page" ID="ID_1884815747" CREATED="1612660996073" MODIFIED="1612661001417"/>
</node>
<node TEXT="social.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1767992974" CREATED="1612660951184" MODIFIED="1612660952897" BACKGROUND_COLOR="#000066">
<node TEXT="lists social for pretty much and username you insert" ID="ID_356341341" CREATED="1612660981854" MODIFIED="1612660989526"/>
</node>
</node>
<node TEXT="layouts" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1551230734" CREATED="1612660524643" MODIFIED="1612660650591">
<node TEXT="defines how different pages are sorted" ID="ID_459084529" CREATED="1612660686852" MODIFIED="1612660691802"/>
<node TEXT="post.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1087954768" CREATED="1612660692037" MODIFIED="1612660709584" BACKGROUND_COLOR="#000066">
<node TEXT="shows post header, post content" ID="ID_588569290" CREATED="1612661371543" MODIFIED="1612661375593"/>
<node TEXT="has top link" ID="ID_440884984" CREATED="1612661378028" MODIFIED="1612661380240"/>
<node TEXT="adds link to each tag" ID="ID_905876843" CREATED="1612661387422" MODIFIED="1612661394455"/>
<node TEXT="includes disqus comments if enabled" ID="ID_1862607325" CREATED="1612661380417" MODIFIED="1612661385836"/>
</node>
<node TEXT="page.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1520376287" CREATED="1612660710511" MODIFIED="1612660713305" BACKGROUND_COLOR="#000066">
<node TEXT="puts header element for title (navbar) stuff" ID="ID_836044705" CREATED="1612661414845" MODIFIED="1612661429048"/>
<node TEXT="puts div for post content" ID="ID_1049790611" CREATED="1612661429794" MODIFIED="1612661434574"/>
</node>
<node TEXT="home.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_67701304" CREATED="1612660713504" MODIFIED="1612660718895" BACKGROUND_COLOR="#000066">
<node TEXT="sets title if extant" ID="ID_1591139355" CREATED="1612660778212" MODIFIED="1612660791547"/>
<node TEXT="puts links to posts" ID="ID_1685729441" CREATED="1612660794089" MODIFIED="1612660799795"/>
<node TEXT="puts about page content" ID="ID_1030755407" CREATED="1612660800476" MODIFIED="1612660819043"/>
<node TEXT="puts rss-subscribe" ID="ID_744574918" CREATED="1612660820380" MODIFIED="1612660823637">
<node TEXT="Is this fully implemented?" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_1347143056" CREATED="1612660832793" MODIFIED="1612660840258"/>
</node>
</node>
<node TEXT="default.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1643308909" CREATED="1612660719701" MODIFIED="1612660723579" BACKGROUND_COLOR="#000066">
<node TEXT="all get this" ID="ID_1093729544" CREATED="1612660728153" MODIFIED="1612660729769"/>
<node TEXT="!Doctype" ID="ID_1682176564" CREATED="1612660729934" MODIFIED="1612660739698"/>
<node TEXT="includes head.html" ID="ID_521549259" CREATED="1612660739875" MODIFIED="1612660742732"/>
<node TEXT="inserts local js dependencies (d3, etc)" ID="ID_104965034" CREATED="1612660744279" MODIFIED="1612660752704"/>
</node>
</node>
<node TEXT="_posts" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_546113797" CREATED="1612660529317" MODIFIED="1612660650271">
<node TEXT="where blog posts are kept" ID="ID_1387215539" CREATED="1612660658760" MODIFIED="1612660662231"/>
<node TEXT="must titled with year" ID="ID_699610816" CREATED="1612660662440" MODIFIED="1612660668747"/>
</node>
<node TEXT="_sass" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1768716602" CREATED="1612660532602" MODIFIED="1612660649348">
<node TEXT="_minima" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1776691105" CREATED="1612660541380" MODIFIED="1612660649764"/>
</node>
<node TEXT="-site" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_783898499" CREATED="1612660544642" MODIFIED="1612660648982"/>
<node TEXT=".jekyll -cache" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_207452479" CREATED="1612660550464" MODIFIED="1612660648691"/>
<node TEXT="assets" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_333812873" CREATED="1612660569185" MODIFIED="1612660648158">
<node TEXT="css" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1165837082" CREATED="1612660571946" MODIFIED="1612660646876">
<node TEXT="USCensusMap" ID="ID_556949716" CREATED="1612660575506" MODIFIED="1612660578368"/>
</node>
<node TEXT="icons" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1030505346" CREATED="1612660589477" MODIFIED="1612660646495"/>
<node TEXT="images" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1727818575" CREATED="1612660590803" MODIFIED="1612660646162"/>
<node TEXT="js" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1406359022" CREATED="1612660591989" MODIFIED="1612660645765"/>
<node TEXT="main.scss" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1542502218" CREATED="1612660596195" MODIFIED="1612660645383"/>
<node TEXT="minima-social-icons.svg" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1347606827" CREATED="1612660599955" MODIFIED="1612660644972"/>
</node>
<node TEXT="_config.yml" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1042096051" CREATED="1612660606131" MODIFIED="1612660643272">
<node TEXT="title" ID="ID_1914971285" CREATED="1612661517765" MODIFIED="1612661520271"/>
<node TEXT="email" ID="ID_1924030902" CREATED="1612661520424" MODIFIED="1612661521474"/>
<node TEXT="description" ID="ID_1368728695" CREATED="1612661521669" MODIFIED="1612661523290"/>
<node TEXT="baseurl" ID="ID_343259115" CREATED="1612661523477" MODIFIED="1612661524722"/>
<node TEXT="url" ID="ID_206958620" CREATED="1612661524897" MODIFIED="1612661525553"/>
<node TEXT="github_username" ID="ID_1519716931" CREATED="1612661525945" MODIFIED="1612661530065"/>
<node TEXT="theme" ID="ID_702555232" CREATED="1612661533227" MODIFIED="1612661534158"/>
<node TEXT="plugins" ID="ID_1090352151" CREATED="1612661534317" MODIFIED="1612661535521"/>
<node TEXT="hitstep_analytics" ID="ID_152900448" CREATED="1612661535700" MODIFIED="1612661538549"/>
<node TEXT="favicon" ID="ID_167951691" CREATED="1612661538781" MODIFIED="1612661539997"/>
<node TEXT="exclude" ID="ID_1939131133" CREATED="1612661544672" MODIFIED="1612661546320"/>
</node>
<node TEXT=".gitignore" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1209663965" CREATED="1612660608362" MODIFIED="1612660643006"/>
<node TEXT="404.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_889558479" CREATED="1612660610177" MODIFIED="1612660642771"/>
<node TEXT="about.markdown" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1398474129" CREATED="1612660611743" MODIFIED="1612660642563"/>
<node TEXT="CNAME" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_811535266" CREATED="1612660613764" MODIFIED="1612660642324"/>
<node TEXT="Gemfile" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_633000363" CREATED="1612660616805" MODIFIED="1612660642106"/>
<node TEXT="Gemfile.lock" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_294870260" CREATED="1612660622395" MODIFIED="1612660641880"/>
<node TEXT="index.md" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1173776153" CREATED="1612660625183" MODIFIED="1612660641649"/>
<node TEXT="Quaffincode.com.mm" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1120769043" CREATED="1612660626599" MODIFIED="1612660641405"/>
<node TEXT="sitemap.xml" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_984286937" CREATED="1612660630854" MODIFIED="1612660641180"/>
<node TEXT="tag_index.html" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1023877201" CREATED="1612660633037" MODIFIED="1612660640916"/>
<node TEXT="tag_page.md" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_1893505777" CREATED="1612660636223" MODIFIED="1612660639313"/>
</node>
<node TEXT="Ideas" LOCALIZED_STYLE_REF="styles.topic" POSITION="right" ID="ID_1424043053" CREATED="1612660513316" MODIFIED="1612660518005">
<edge COLOR="#00ffff"/>
<node TEXT="Freeplane Post" LOCALIZED_STYLE_REF="defaultstyle.note" ID="ID_1817745923" CREATED="1612661816270" MODIFIED="1612661819470"/>
<node TEXT="Freeplane tips" LOCALIZED_STYLE_REF="defaultstyle.note" ID="ID_1418119124" CREATED="1612661881908" MODIFIED="1612661883966">
<node TEXT="Setup" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_853202895" CREATED="1612663299987" MODIFIED="1612839912636">
<node TEXT="styles ctrl+f11. I&apos;m going to mention this several times" ID="ID_217175330" CREATED="1612663303025" MODIFIED="1612663311968"/>
<node TEXT="your view should center on what you are looking at. You have to change this in the settings. Press tools &gt; Preferences or ctrl+,. (Not a shortcut I memorized, by the way)" ID="ID_535129243" CREATED="1612663312171" MODIFIED="1612663371096"/>
</node>
<node TEXT="Organize" LOCALIZED_STYLE_REF="styles.subtopic" FOLDED="true" ID="ID_684767089" CREATED="1612661940086" MODIFIED="1612839913056">
<node TEXT="Flexible organization" ID="ID_1714958458" CREATED="1612661942717" MODIFIED="1612661953328"/>
<node TEXT="You&apos;re not stuck on putting something somewhere - you can use links" ID="ID_249250775" CREATED="1612661953504" MODIFIED="1612661961172"/>
<node TEXT="Example - mindmap for this site has site components and idas sections" ID="ID_215259776" CREATED="1612661961516" MODIFIED="1612661991343"/>
<node TEXT="you can always go back and add nodes later" ID="ID_1571176605" CREATED="1612661993275" MODIFIED="1612662007282"/>
<node TEXT="in-between, title, or topic nodes" ID="ID_459627984" CREATED="1612662007438" MODIFIED="1612662013686"/>
<node TEXT="I like the default text set to something small and readable - i like source code pro personally" ID="ID_607288172" CREATED="1612662013856" MODIFIED="1612662033940"/>
<node TEXT="when i have an example of some code, I copy it in" ID="ID_722126462" CREATED="1612662034115" MODIFIED="1612662041941"/>
<node TEXT="I use styles mapped to the function buttons" ID="ID_419110762" CREATED="1612662042201" MODIFIED="1612662057983"/>
</node>
<node TEXT="Best keyboard shortcuts" LOCALIZED_STYLE_REF="styles.subtopic" FOLDED="true" ID="ID_213830130" CREATED="1612662109723" MODIFIED="1612839913426">
<node TEXT="2 categories: styling, and navigation" ID="ID_1508072208" CREATED="1612662962257" MODIFIED="1612662987704"/>
<node TEXT="styling" LOCALIZED_STYLE_REF="AutomaticLayout.level,2" FOLDED="true" ID="ID_1123726255" CREATED="1612662988420" MODIFIED="1612662990094">
<node TEXT="Ctrl+f11 - bring up styling menu" ID="ID_98714900" CREATED="1612662933663" MODIFIED="1612662940397"/>
<node TEXT="Ctrl+shift+c and ctrl+shift+v - copy all node styles from one node to another (including one on the style menu)" ID="ID_1311479227" CREATED="1612662941179" MODIFIED="1612662958224"/>
<node TEXT="1.) The ones you map yourself to styling, f11 on the keyboard" ID="ID_1111534963" CREATED="1612662114291" MODIFIED="1612662123850"/>
<node TEXT="4) Ctrl+shift+o -&gt; load styles from another map. Use previous maps as templates and tweak it as you go. You&apos;ll wind up with a bunch of templates going" ID="ID_258685374" CREATED="1612662787855" MODIFIED="1612662814152"/>
<node TEXT="Ctrl+F11) bring up the styling menu" ID="ID_1027327368" CREATED="1612662916708" MODIFIED="1612662923386"/>
<node ID="ID_647197193" CREATED="1612662124064" MODIFIED="1612662319005"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <p>
      2.) Alt+Enter - brings up a more detailed text edit menu. Double click a word, make it <font color="#ccff99">gold</font>
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Don&apos;t overuse alt enter. It takes two look. It&apos;s usually better to use your own styling." ID="ID_659702779" CREATED="1612662322477" MODIFIED="1612662346592"/>
<node TEXT="But you can quickly use alt+shift+B to change the background color on a node" ID="ID_1436348237" CREATED="1612662346884" MODIFIED="1612662363658"/>
<node TEXT="Use highlighting single words when you have a group of list items together to highlight one concept" ID="ID_199360486" CREATED="1612662373011" MODIFIED="1612662386558"/>
<node TEXT="3) Alt+n - input note information that will show when your mouse hovers over them" ID="ID_439300626" CREATED="1612662745856" MODIFIED="1612662767602"/>
</node>
<node TEXT="navigation" LOCALIZED_STYLE_REF="AutomaticLayout.level,2" FOLDED="true" ID="ID_230029349" CREATED="1612663002051" MODIFIED="1612663003480">
<node TEXT="f2 opens node for writing, just like excel" ID="ID_1936252933" CREATED="1612663004045" MODIFIED="1612663013744"/>
<node TEXT="Spacebar closes node" ID="ID_257382753" CREATED="1612663039088" MODIFIED="1612663042024"/>
<node TEXT="ctrl up and down moves it up or down" ID="ID_389486782" CREATED="1612663015116" MODIFIED="1612663019785"/>
<node TEXT="ctrl LEFT moves it in and out of parent" ID="ID_66142225" CREATED="1612663131719" MODIFIED="1612663146912"/>
<node TEXT="ctrl pageup and ctrl pagedown close nodes recursively, each press starting with the furthest open nodes. PageUP closes nodes" ID="ID_320973675" CREATED="1612663049213" MODIFIED="1612663076555"/>
<node TEXT="Shift+arrow selects more than one for shifting up and down" ID="ID_1285311791" CREATED="1612663032005" MODIFIED="1612663038360"/>
<node TEXT="Arrow to move around generally" ID="ID_1709832882" CREATED="1612663085746" MODIFIED="1612663101508"/>
<node TEXT="Insert to add a node" ID="ID_1280248577" CREATED="1612663102199" MODIFIED="1612663104627"/>
<node TEXT="shift insert to add a node above" ID="ID_1537426687" CREATED="1612663106105" MODIFIED="1612663110018"/>
<node TEXT="ctrl to move a node back a level" ID="ID_1962872616" CREATED="1612663112821" MODIFIED="1612663128755"/>
</node>
</node>
<node TEXT="Use math" LOCALIZED_STYLE_REF="styles.subtopic" FOLDED="true" ID="ID_1265585903" CREATED="1612663421665" MODIFIED="1612839913855">
<node TEXT="It&apos;s latex, learn latex" ID="ID_125493525" CREATED="1612663424969" MODIFIED="1612663427810"/>
<node TEXT="This is great for math programs" ID="ID_1730443937" CREATED="1612663427972" MODIFIED="1612663431889"/>
<node TEXT="" ID="ID_529649064" CREATED="1612663432122" MODIFIED="1612663432124"/>
</node>
<node TEXT="Styling" LOCALIZED_STYLE_REF="styles.subtopic" FOLDED="true" ID="ID_1553483806" CREATED="1612662857600" MODIFIED="1612839914395">
<node TEXT="Big Text for First nodes" ID="ID_965631530" CREATED="1612662859515" MODIFIED="1612662865209"/>
<node TEXT="Medium texts for larget sub-topic nodes" ID="ID_628092639" CREATED="1612662865420" MODIFIED="1612662872684"/>
<node TEXT="Sub-topic nodes get a bubble so everything is contained in them" ID="ID_699668764" CREATED="1612662872874" MODIFIED="1612662881453"/>
<node TEXT="Topic nodes same size or slightly larger than the normal text you use but with a solid and bold background, and possibly extra widht" ID="ID_1558436171" CREATED="1612662881660" MODIFIED="1612662908592"/>
</node>
<node TEXT="Stuff I don&apos;t do (yet)" LOCALIZED_STYLE_REF="styles.subtopic" FOLDED="true" ID="ID_648299243" CREATED="1612661915636" MODIFIED="1612839914992">
<node TEXT="Menus" FOLDED="true" ID="ID_1632039159" CREATED="1612661900285" MODIFIED="1612661902591">
<node TEXT="You can change these in the XML file" ID="ID_803188283" CREATED="1612661903091" MODIFIED="1612661907462"/>
</node>
<node TEXT="icons. could be mapped to a hotkey though and be powerful for certain people." ID="ID_204696904" CREATED="1612662768650" MODIFIED="1612662783907"/>
<node TEXT="Exporting" FOLDED="true" ID="ID_339372437" CREATED="1612663640170" MODIFIED="1612663642548">
<node TEXT="You can export as HTML" ID="ID_1181388581" CREATED="1612663643016" MODIFIED="1612663646390"/>
<node TEXT="but this isn&apos;t great" ID="ID_1232875016" CREATED="1612663646564" MODIFIED="1612663661463"/>
<node TEXT="gives you lists and spans that make the lists drop down like your dids did, and it could be useful, but you don&apos;t get the same cool map-node style as you do in freeplane" ID="ID_1570880604" CREATED="1612663661618" MODIFIED="1612663717787"/>
<node TEXT="still, i&apos;m tempted to write a blog post entirely in Freeplane and export it." ID="ID_1338754590" CREATED="1612663720090" MODIFIED="1612663730445"/>
</node>
</node>
<node TEXT="future stuff and ideas" LOCALIZED_STYLE_REF="styles.subtopic" FOLDED="true" ID="ID_455781231" CREATED="1612662059197" MODIFIED="1612839915584">
<node TEXT="there should be a way to put freeplane styled nodes into an html page as collapsible divs" ID="ID_1647100305" CREATED="1612662061413" MODIFIED="1612662082013"/>
<node TEXT="Mindmap-To-Webpage" ID="ID_1122017339" CREATED="1612662091962" MODIFIED="1612662095307"/>
</node>
<node TEXT="video" LOCALIZED_STYLE_REF="styles.subtopic" ID="ID_516956677" CREATED="1612838826970" MODIFIED="1612839916129">
<node TEXT="Panopto Express" ID="ID_544342292" CREATED="1612838867730" MODIFIED="1612838871414"/>
<node TEXT="OBS Studio - Open Source" ID="ID_1455413073" CREATED="1612838949462" MODIFIED="1612838955622"/>
<node TEXT="Cam Studio" FOLDED="true" ID="ID_1420514311" CREATED="1612838991720" MODIFIED="1612838993421">
<node TEXT="gives you freedom to set full screen, window, or fixed region as target area" ID="ID_197433698" CREATED="1612838994200" MODIFIED="1612839004867"/>
<node TEXT="Annotation tool can add captions or other effects" ID="ID_1391551473" CREATED="1612839007065" MODIFIED="1612839013556"/>
<node TEXT="Produces .SWFs" ID="ID_627982208" CREATED="1612839027710" MODIFIED="1612839030682"/>
<node TEXT="Not too complex" ID="ID_964675351" CREATED="1612839030882" MODIFIED="1612839033369"/>
</node>
</node>
</node>
</node>
</node>
</map>
