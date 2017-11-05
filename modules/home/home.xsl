<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:site="http://oppidoc.com/oppidum/site" xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="xml" media-type="text/html" omit-xml-declaration="yes" indent="yes"/>

  <xsl:param name="xslt.rights">none</xsl:param>
  <xsl:param name="xslt.base-url">/</xsl:param>
  <xsl:param name="xslt.key"/>
  <xsl:param name="xslt.lang">fr</xsl:param>

    <xsl:include href="../webpage/webpagecontent.xsl"/> 
  <xsl:include href="../../shared/core.xsl"/> 



  <xsl:template match="/">

    <site:view skin="home">

      <site:content>

        <xsl:call-template name="resource-modal"/>
        <xsl:call-template name="topic-modal"/>
      </site:content>

      <xsl:if test="contains($xslt.rights, 'modifier')">
        <site:menu>
          <button accesskey="e" title="modifier la nouvelle"
            onclick="javascript:window.location.href+='/modifier'">Modifier</button>
        </site:menu>
      </xsl:if>
      <!--      <site:title>
        <div id="title-homekp">
          <xsl:apply-templates select="WebPage/Boxes/Box[2]/*"/>
          
        
        </div>
      </site:title>-->

      <site:about>
        <div id="abouttitle">
          <xsl:apply-templates select="WebPage/Boxes/Box[1]/BoxTitle"/>

        </div>
        <div id="aboutcontent">
<!--
          <a href="#video">
            <xsl:apply-templates select="WebPage/Boxes/Box[4]/BoxContent/BoxTitle[1]"/>
          </a>
          <a href="#">
            <xsl:apply-templates select="WebPage/Boxes/Box[4]/BoxContent/BoxTitle[2]"/>
          </a>
          <a href="#resources">
            <xsl:apply-templates select="WebPage/Boxes/Box[4]/BoxContent/BoxTitle[3]"/>
          </a>-->
          <img class="logos" src="{xslt.base-url}static/vpi-epfl/images/calendar.png"/>
          
        </div>
      </site:about>
      <site:sme>
        <div id="abouttitle">
          <xsl:apply-templates select="WebPage/Boxes/Box[2]/BoxTitle"/>
          
        </div>
        <div id="aboutcontent">
        <img class="logos" src="{xslt.base-url}static/vpi-epfl/images/banwid.jpg"/>
        </div>
      </site:sme>
      <site:resources>
      <div id="abouttitle">
        
        <xsl:apply-templates select="WebPage/Boxes/Box[3]/*"/>
      </div>
      <div id="resources"> 
        <table class="table table-bordered">
          <thead>
            <!--  <tr>
          <th colspan = "7" loc="term.resource">
            Resource
          </th>
          <th rowspan="2" loc="term.relatedTopics">
            Related topics
          </th>
          
        </tr>-->
            <tr bgcolor="#9EC0D9">
              <th loc="term.name">Title</th>
              <th class="homew" loc="term.date">Date</th>
              
              
              
            </tr>
          </thead>
          <tbody  bgcolor="#FFF" localized="1">
            <xsl:apply-templates select="WebPage/TopResources/Resource"/>
          </tbody>
        </table>
        <!--<div class="row project">
            <xsl:if test="contains($xslt.rights, 'modifier')">
              <button class="inplacedit" title="sélectionner la nouvelle(s)" onclick="javascript:window.location.href ='home/nouvelles/choisir'">Choisir</button>
            </xsl:if>
            <xsl:apply-templates select="WebPage/News/NewsItem"/>
            <xsl:if test="not(WebPage/News/NewsItem) and contains($xslt.rights, 'modifier')">
              <p>Cliquez sur le bouton pour ajouter une nouvelle</p>
            </xsl:if>
          </div>-->
      </div>
      <!-- <xsl:call-template name="contact"/> -->
      </site:resources>
      <site:topics>
        <div id="abouttitle">
          <xsl:apply-templates select="WebPage/Boxes/Box[4]/*"/>
        </div>
        <div id="topics">
          <table class="table table-bordered">
            <thead>
              <!--  <tr>
          <th colspan = "7" loc="term.resource">
            Resource
          </th>
          <th rowspan="2" loc="term.relatedTopics">
            Related topics
          </th>
          
        </tr>-->
              <tr bgcolor="#9EC0D9">
                <th loc="term.name">Title</th>
                <th class="homew" loc="term.date">Date</th>
                
                
                
              </tr>
            </thead>
            <tbody  bgcolor="#FFF" localized="1">
              <xsl:apply-templates select="WebPage/TopTopics/Topic"/>
            </tbody>
          </table>
          <!--<div class="row project">
            <xsl:if test="contains($xslt.rights, 'modifier')">
              <button class="inplacedit" title="sélectionner la nouvelle(s)" onclick="javascript:window.location.href ='home/nouvelles/choisir'">Choisir</button>
            </xsl:if>
            <xsl:apply-templates select="WebPage/News/NewsItem"/>
            <xsl:if test="not(WebPage/News/NewsItem) and contains($xslt.rights, 'modifier')">
              <p>Cliquez sur le bouton pour ajouter une nouvelle</p>
            </xsl:if>
          </div>-->
        </div>
        <!-- <xsl:call-template name="contact"/> -->
      </site:topics>

      <!--<site:logos>
        <div id="abouttitle">
          <xsl:apply-templates select="WebPage/Boxes/Box[7]/*"/>
        </div>
        <div id="topics">

          <table class="table">


            <tbody bgcolor="#FFF" localized="1">

              <xsl:apply-templates select="WebPage/TopLogos/Host[Photo/text()]/Photo"/>
              <xsl:text>&#160;&#160;&#160;&#160;&#160;</xsl:text>

            </tbody>
          </table>
          <!-\-<div class="row project">
            <xsl:if test="contains($xslt.rights, 'modifier')">
              <button class="inplacedit" title="sélectionner la nouvelle(s)" onclick="javascript:window.location.href ='home/nouvelles/choisir'">Choisir</button>
            </xsl:if>
            <xsl:apply-templates select="WebPage/News/NewsItem"/>
            <xsl:if test="not(WebPage/News/NewsItem) and contains($xslt.rights, 'modifier')">
              <p>Cliquez sur le bouton pour ajouter une nouvelle</p>
            </xsl:if>
          </div>-\->
        </div>
        <!-\- <xsl:call-template name="contact"/> -\->
      </site:logos>-->
      <!--<site:address>
        <div>
          <h2 class="fn org" style="margin-bottom:0">
            <xsl:apply-templates select="WebPage/Address/Organization/Name"/>
          </h2>
          <xsl:apply-templates select="WebPage/Address"/>
        </div>
      </site:address>-->
      <!--<site:sponsor1>
        <span>
          <xsl:value-of select="WebPage/Vocabulary/Sponsor1"/>
        </span>
      </site:sponsor1>-->
      <!--<site:sponsor2>
        <span>
          <xsl:value-of select="WebPage/Vocabulary/Sponsor2"/>
        </span>
      </site:sponsor2>-->

      <!--<site:contact>
        <span class="span12" id="contact"><b>Patrick Albert</b> - <text loc="term.phone">phone:
          </text>: <b>+41 79 416 79 82</b> - <text loc="term.email">Email</text>: <b><a
              href="mailto:patrick.albert@sme-mpower.eu">patrick.albert@sme-mpower.eu</a></b>
        </span>
      </site:contact>-->
    </site:view>

  </xsl:template>


  <xsl:template match="Resource">
    <tr class="unstyled" data-id="{Id}">
      <td>

        <xsl:apply-templates select="Title"/>

      </td>
      <td class="homew">
        <xsl:value-of select="Phases/Phase1[Ref = 3 or Ref = 4]/Date"/>

      </td>

    </tr>
  </xsl:template>
  <xsl:template match="Title">

    <b>
      <a data-toggle="modal" href="directSearch/resources/{../Id}.modal"
        data-target="#resource-modal">
        <xsl:value-of select="."/>
      </a>
    </b>
  </xsl:template>

  <xsl:template match="Topic">
    <tr class="unstyled" data-id="{Id}">
      <td>
        <b>
          <xsl:apply-templates select="Name"/>
        </b>
      </td>
      <td class="homew">
        <xsl:value-of select="Status/Date"/>

      </td>

    </tr>
  </xsl:template>

  <xsl:template match="Host">

    <xsl:apply-templates select="Photo"/>

  </xsl:template>

  <xsl:template match="Name">


    <a data-toggle="modal" href="directSearch/topics/{../Id}.modal" data-target="#topic-modal">
      <xsl:value-of select="."/>
    </a>

  </xsl:template>

  <!-- <xsl:template match="Photo" mode="indicators">
    <li data-target="#slider" data-slide-to="{ position() - 1 }"></li>
  </xsl:template>

  <xsl:template match="Photo[1]" mode="indicators">
    <li data-target="#slider" data-slide-to="0" class="active"></li>
  </xsl:template>

  <xsl:template match="Photo" mode="carroussel">
    <div class="item">
      <img src="{xslt.base-url}static/kp/images/slides/{.}"  class="img-responsive center-block" alt="..."/>
      <div class="carousel-caption"><xsl:value-of select="/WebPage/Carroussel/Legend"/></div>
    </div>
  </xsl:template>

  <xsl:template match="Photo[1]" mode="carroussel">
    <div class="item active">
      <img src="{xslt.base-url}static/kp/images/slides/{.}"  class="img-responsive center-block" alt="..."/>
      <div class="carousel-caption"><xsl:value-of select="/WebPage/Carroussel/Legend"/></div>
    </div>
  </xsl:template>-->

  <!-- <p class="fn org" style="margin-bottom:0">
    <xsl:apply-templates select="Organization/Name"/>
  </p> -->
  <xsl:template match="Address">
    <div class="vcard">
      <p class="adr" style="margin-bottom:0">
        <span class="street-address"><xsl:value-of select="Street"/></span> - <xsl:apply-templates
          select="ExtendedAddress"/><br/>
        <span class="postal-code"><xsl:value-of select="Code"/></span>
        <span class="locality"><xsl:value-of select="City"/></span>
        <a href="contacts" class="btn btn-default btn-inverse" style="float:right; margin:5px"
          >Plus</a>
      </p>
      <a class="email" href="mailto:{Organization/Email}">
        <xsl:value-of select="Organization/Email"/>
      </a>
    </div>
  </xsl:template>

  <!-- Optional headline -->
  <xsl:template match="Box" mode="headline">
    <site:headline>
      <div id="headline" class="bas">
        <xsl:apply-templates select="."/>
      </div>
    </site:headline>
  </xsl:template>

  <xsl:template match="Project">
    <div class="col-xs-12">
      <div class="row headline">
        <div class="col-md-4 col-xs-12">
          <xsl:apply-templates select="Photo"/>
        </div>
        <div class="col-md-8 col-xs-12">
          <h3 class="bold">
            <xsl:value-of select="PageTitle"/>
          </h3>
          <p>
            <xsl:value-of select="Summary"/>
          </p>
          <!-- <p class="suite"><a href="projets/{@Key}"><xsl:call-template name="suite"/></a></p> -->
          <p class="suite">
            <a href="projets/{@Key}" class="btn btn-default btn-inverse">Plus</a>
          </p>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="Photo">
    <!--<a href="projets/{../@Key}/{.}">-->
    <xsl:variable name="urll">
      <xsl:value-of select="../URL/text()"/>
    </xsl:variable>
    <xsl:if test="../URL/text()">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:if test="starts-with(../URL, 'www')">http://</xsl:if>
          <xsl:value-of select="../URL"/>
        </xsl:attribute>
        <xsl:attribute name="target">_blank</xsl:attribute>
        <img class="logos" src="{$xslt.base-url}/home/images/{substring-after(., 'images/')}"
          height="64px" width="89px"/>

      </xsl:element>


      <!--   
        <xsl:element name="a">
          <xsl:attribute name="href">http://<xsl:value-of select="string(../URL/text())"/></xsl:attribute>
          <img class="logos" src="{$xslt.base-url}/home/images/{substring-after(., 'images/')}" height= "64px" width="189px"/>
          
        </xsl:element>-->

    </xsl:if>
    <xsl:if test="not(../URL/text())">
      <img class="logos" src="{$xslt.base-url}/home/images/{substring-after(., 'images/')}"
        height="64px" width="89px"/>

    </xsl:if>
  </xsl:template>
  <!--
  <xsl:template match="Photo[.='']">
  </xsl:template>

  <xsl:template match="Photo" mode="manifestation">
    <a href="manifestations/{../../@Key}/{.}"><img src="manifestations/{../../@Key}/vignettes/{substring-after(., 'images/')}" style="max-width:200px" class="img-thumbnail"/></a>
  </xsl:template>

  <xsl:template match="Photo[.='']" mode="manifestation">
  </xsl:template>-->

  <xsl:template match="RefImage[Target]">
    <p>
      <a href="{Target}" target="_blank">
        <img class="refimg" src="{@Source}" alt="{Text}"/>
      </a>
    </p>
  </xsl:template>

  <xsl:template match="RefImage">
    <p>
      <img class="refimg" src="{@Source}" alt="{Text}"/>
    </p>
  </xsl:template>

  <xsl:template match="NewsItem">
    <div class="col-xs-12">
      <div class="row headline">
        <div class="col-md-4 col-xs-12">
          <xsl:apply-templates select="Photo" mode="nouvelle"/>
        </div>
        <div class="col-md-8 col-xs-12">
          <h3 class="bold">
            <xsl:value-of select="PageTitle"/>
          </h3>
          <p>
            <xsl:value-of select="Summary"/>
          </p>
          <p class="suite">
            <a href="nouvelles/{@Key}" class="btn btn-default btn-inverse">Plus</a>
          </p>
        </div>
      </div>
    </div>
  </xsl:template>

  <!--  <xsl:template match="Photo" mode="nouvelle">
    <a href="nouvelles/{../@Key}/{.}"><img src="nouvelles/{../@Key}/vignettes/{substring-after(., 'images/')}" style="max-width:200px" class="img-thumbnail"/></a>
  </xsl:template>

  <xsl:template match="Photo[.='']" mode="nouvelle">
  </xsl:template>-->

  <xsl:template name="contact">
    <xsl:variable name="base">
      <xsl:call-template name="static-base"/>
    </xsl:variable>
    <p style="text-align:right">
      <a class="logolink"
        href="http://www.facebook.com/pages/AllianceTT/203013313052237#!/pages/AllianceTT/203013313052237?sk=wall"
        target="_blank">
        <img src="{$base}static/alliance/images/facebook32.gif" alt="Suivre sur Facebook"/>
      </a>
      <a class="logolink" href="http://twitter.com/#!/AllianceTT" target="_blank">
        <img src="{$base}static/alliance/images/twitter32.gif" alt="Suivre sur Twitter"/>
      </a>
      <a class="logolink"
        href="http://www.linkedin.com/company/alliance-tt?trk=hb_tab_compy_id_916723"
        target="_blank">
        <img src="{$base}static/alliance/images/linkedin.png" alt="Suivre sur LinkedIn"/>
      </a>
    </p>
  </xsl:template>

  <!-- Localization  -->
  <xsl:template name="suite">
    <xsl:choose>
      <xsl:when test="$xslt.lang = 'en'">Read more</xsl:when>
      <xsl:otherwise>En savoir plus</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Localization - DEPRECATED  -->
  <xsl:template name="nous-contacter">
    <xsl:choose>
      <xsl:when test="$xslt.lang = 'en'">Contact us:</xsl:when>
      <xsl:otherwise>Nous contacter:</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- /static/ prefix independant of language to run under Tomcat as well -->
  <xsl:template name="static-base">
    <xsl:choose>
      <xsl:when test="contains($xslt.base-url, '/en/')">
        <xsl:value-of select="substring-before($xslt.base-url, 'en/')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$xslt.base-url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="resource-modal">
    <!-- Modal -->
    <div id="resource-modal" class="modal hide fade more-infos" tabindex="-1" role="dialog"
      aria-labelledby="label-resource" aria-hidden="true">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 id="label-resource" loc="term.resource-key">Resource</h3>
      </div>
      <div class="modal-body" style="background:white"> </div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true" loc="action.close"
          >Fermer</button>
      </div>
    </div>
  </xsl:template>
  <xsl:template name="topic-modal">
    <!-- Modal -->
    <div id="topic-modal" class="modal hide fade more-infos" tabindex="-1" role="dialog"
      aria-labelledby="label-topic" aria-hidden="true">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        <h3 id="label-topic" loc="term.topic-key">Topic</h3>
      </div>
      <div class="modal-body" style="background:white"> </div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true" loc="action.close"
          >Fermer</button>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
