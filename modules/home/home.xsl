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
          <table class="table table-bordered">
            <!--<thead>
      
              <tr bgcolor="#9EC0D9">
                <th loc="term.name">Title</th>
                <th class="homew" loc="term.date">Date</th>
              </tr>
            </thead>-->
            <tbody bgcolor="#FFF" localized="1">
              <tr>
                <td><img class="iconn" src="{xslt.base-url}static/vpi-epfl/images/vert.png"/>
                </td>
                <td>Email Tim Cook
                </td>
              </tr>
              <tr>
                <td><img class="iconn" src="{xslt.base-url}static/vpi-epfl/images/vert.png"/>
                </td>
                <td>Email Liam Sears
                </td>
              </tr>
              <tr>
                <td><img class="iconn" src="{xslt.base-url}static/vpi-epfl/images/jaune.png"/>
                </td>
                <td>Call Sam Jones
                </td>
              </tr>
              <tr>
                <td class="tdtasks"><img class="iconn" src="{xslt.base-url}static/vpi-epfl/images/vert.png"/>
                </td>
                <td>Meeting with Accenture
                </td>
              </tr>
              <tr>
                <td><img class="iconn" src="{xslt.base-url}static/vpi-epfl/images/jaune.png"/>
                </td>
                <td>Meeting with Docetis
                </td>
              </tr>
              <tr>
                <td><img class="iconn" src="{xslt.base-url}static/vpi-epfl/images/jaune.png"/>
                </td>
                <td>Email C. Vanoirbeek
                </td>
              </tr>
            </tbody>
          </table>
          <!--        <img class="logos" src="{xslt.base-url}static/vpi-epfl/images/banwid.jpg"/>
-->
        </div>
      </site:sme>
      <site:resources>
        <div id="abouttitle">

          <xsl:apply-templates select="WebPage/Boxes/Box[3]/*"/>
        </div>
        <div id="accounts">
          <table class="table table-bordered">
            <!--<thead>

              <tr bgcolor="#9EC0D9">
                <th loc="term.name">Title</th>
                <th class="homew" loc="term.date">Date</th>
              </tr>
            </thead>-->
            <tbody bgcolor="#FFF" localized="1">
              <xsl:apply-templates select="WebPage/TopAccounts/Account"/>
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
            <tbody bgcolor="#FFF" localized="1">
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


  <xsl:template match="Account">
    
 <!--   <xsl:variable name="countAccounts">
      <xsl:if test="count(Afiliates/Afiliate)>0">
        <xsl:value-of select="count(Afiliates/Afiliate)"/>
      </xsl:if>
      <xsl:if test="count(Afiliates/Afiliate)=0">
        1
      </xsl:if>rowspan="{countAccounts}"
    </xsl:variable>-->
    <tr class="unstyled" data-id="{Id}">
      <td>

        <h4 class="mainaccount"><xsl:apply-templates select="Name"/></h4>
        <h5 class="affiliate"><xsl:apply-templates select="Afiliates"/></h5>
      </td>
      <td>
        <xsl:value-of select="WebSite"/>

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
      <td>
        <xsl:value-of select="WebSite"/>

      </td>

    </tr>
  </xsl:template>

  
  <xsl:template match="Name">


    <a data-toggle="modal" href="directSearch/topics/{../Id}.modal" data-target="#topic-modal">
      <xsl:value-of select="."/>
    </a>

  </xsl:template>

  
  <xsl:template match="Afiliates">
    
    <xsl:apply-templates select="Afiliate"/>

  </xsl:template>
  

  <xsl:template match="Afiliate">
    
    <xsl:apply-templates select="Name"/>
    <xsl:if test="position() != last()">
      <br/>
    </xsl:if>
    
    <xsl:if test="position() = last()">
      <xsl:text/>
    </xsl:if>
  </xsl:template>

  
  
</xsl:stylesheet>
