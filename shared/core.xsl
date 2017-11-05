<?xml version="1.0" encoding="UTF-8"?>
<!-- Alliance web site 

    Author: Stéphane Sire <sire@oppidoc.fr>

    January 2012 - (C) 2012 Oppidoc SARL
 -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:site="http://oppidoc.com/oppidum/site"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template match="Date">
    <xsl:apply-templates select="Weekday"/><xsl:apply-templates select="Day"/><xsl:text> </xsl:text><xsl:apply-templates select="Month"/><xsl:text> </xsl:text><xsl:value-of select="Year"/>
  </xsl:template>

  <xsl:template match="Day"><xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="Day[$xslt.lang = 'en']"><xsl:value-of select="."/>th
  </xsl:template>

  <xsl:template match="Day[$xslt.lang = 'en'][substring(., string-length(.))='1']"><xsl:value-of select="."/>st
  </xsl:template>

  <xsl:template match="Day[$xslt.lang = 'en'][substring(., string-length(.))='2']"><xsl:value-of select="."/>nd
  </xsl:template>

  <xsl:template match="Day[$xslt.lang = 'en'][substring(., string-length(.))='3']"><xsl:value-of select="."/>rd
  </xsl:template>

  <xsl:template match="Weekday"><xsl:value-of select="."/><xsl:text> </xsl:text></xsl:template> 

  <xsl:template match="Weekday[$xslt.lang = 'en'][translate(.,'SAMEDICHLUNRJV','samedichlunrjv')='samedi']">Saturday,<xsl:text> </xsl:text></xsl:template> 
  <xsl:template match="Weekday[$xslt.lang = 'en'][translate(.,'SAMEDICHLUNRJV','samedichlunrjv')='dimanche']">Sunday,<xsl:text> </xsl:text></xsl:template> 
  <xsl:template match="Weekday[$xslt.lang = 'en'][translate(.,'SAMEDICHLUNRJV','samedichlunrjv')='lundi']">Monday,<xsl:text> </xsl:text></xsl:template> 
  <xsl:template match="Weekday[$xslt.lang = 'en'][translate(.,'SAMEDICHLUNRJV','samedichlunrjv')='mardi']">Tuesday,<xsl:text> </xsl:text></xsl:template> 
  <xsl:template match="Weekday[$xslt.lang = 'en'][translate(.,'SAMEDICHLUNRJV','samedichlunrjv')='mercredi']">Wednesday,<xsl:text> </xsl:text></xsl:template> 
  <xsl:template match="Weekday[$xslt.lang = 'en'][translate(.,'SAMEDICHLUNRJV','samedichlunrjv')='jeudi']">Thursday,<xsl:text> </xsl:text></xsl:template> 
  <xsl:template match="Weekday[$xslt.lang = 'en'][translate(.,'SAMEDICHLUNRJV','samedichlunrjv')='vendredi']">Friday,<xsl:text> </xsl:text></xsl:template> 
  
  <xsl:template match="Month">
    <xsl:choose>
      <xsl:when test=". = 1">Janvier</xsl:when>
      <xsl:when test=". = 2">Février</xsl:when>
      <xsl:when test=". = 3">Mars</xsl:when>
      <xsl:when test=". = 4">Avril</xsl:when>
      <xsl:when test=". = 5">Mai</xsl:when>
      <xsl:when test=". = 6">Juin</xsl:when>
      <xsl:when test=". = 7">Juillet</xsl:when>
      <xsl:when test=". = 8">Août</xsl:when>
      <xsl:when test=". = 9">Septembre</xsl:when>
      <xsl:when test=". = 10">Octobre</xsl:when>
      <xsl:when test=". = 11">Novembre</xsl:when>
      <xsl:when test=". = 12">Décembre</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Month[$xslt.lang = 'en']">
    <xsl:choose>
      <xsl:when test=". = 1">January</xsl:when>
      <xsl:when test=". = 2">February</xsl:when>
      <xsl:when test=". = 3">March</xsl:when>
      <xsl:when test=". = 4">April</xsl:when>
      <xsl:when test=". = 5">May</xsl:when>
      <xsl:when test=". = 6">June</xsl:when>
      <xsl:when test=". = 7">July</xsl:when>
      <xsl:when test=". = 8">August</xsl:when>
      <xsl:when test=". = 9">September</xsl:when>
      <xsl:when test=". = 10">October</xsl:when>
      <xsl:when test=". = 11">November</xsl:when>
      <xsl:when test=". = 12">December</xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="Time">, <xsl:value-of select="."/></xsl:template>
  
  <xsl:template match="Place">
    <xsl:apply-templates select="Organization | Room | City" mode="Place"/>
  </xsl:template>
  
  <xsl:template match="Organization[not(Name)] | Room[not(Name)]" mode="Place">   
  </xsl:template>
  
  <xsl:template match="Organization[Web]" mode="Place">
    <a target="_blank">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="starts-with(Web, 'http://')"><xsl:value-of select="Web"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="concat('http://', Web)"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute><xsl:value-of select="Name"/></a><xsl:if test="following-sibling::*"> - </xsl:if>
  </xsl:template>

  <xsl:template match="Room[Web]" mode="Place">
    <a target="_blank">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="starts-with(Web, 'http://')"><xsl:value-of select="Web"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="concat('http://', Web)"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute><xsl:value-of select="Name"/></a><xsl:if test="following-sibling::*"> - </xsl:if>
  </xsl:template>
  
  <xsl:template match="Organization | Room" mode="Place">
    <xsl:value-of select="Name"/><xsl:if test="following-sibling::*"> - </xsl:if>
  </xsl:template>  
  
  <xsl:template match="City" mode="Place">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="SubTitle">
    <h3><xsl:value-of select="."/></h3>
  </xsl:template>

  <xsl:template name="cleanup-link">
    <xsl:param name="value"/>
    <xsl:variable name="anchor">
      <xsl:choose>
        <xsl:when test="starts-with($value, 'http://')"><xsl:value-of select="substring-after($value, 'http://')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$value"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="href">
      <xsl:choose>
        <xsl:when test="starts-with($value, 'http://')"><xsl:value-of select="$value"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="concat('http://', $value)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$anchor != ''">
      <a href="{$href}" target="_blank"><xsl:value-of select="substring-before(concat(normalize-space($anchor),'/'), '/')"/></a>
    </xsl:if>   
  </xsl:template> 
  
  <xsl:template name="complete-url">
    <xsl:param name="value"/>
    <xsl:choose>
      <xsl:when test="starts-with($value, 'http://')"><xsl:value-of select="$value"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="concat('http://', $value)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>