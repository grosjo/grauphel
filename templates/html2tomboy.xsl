<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:h="http://www.w3.org/1999/xhtml"
>
 <!--
  Convert HTML generated by grauphel's tomboy2html converter
  back into the tomboy note markup
 -->
 <xsl:output omit-xml-declaration="yes"/>

 <xsl:template match="/">
  <xsl:apply-templates select="h:html/h:body"/>
 </xsl:template>

 <xsl:template match="h:body">
  <xsl:call-template name="content"/>
 </xsl:template>

 <xsl:template name="content">
  <xsl:for-each select="child::node()">
   <xsl:choose>
    <xsl:when test="local-name(.) = ''">
     <xsl:call-template name="string-replace-all">
      <xsl:with-param name="text" select="string(.)" />
      <xsl:with-param name="replace" select="'&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;'" />
      <xsl:with-param name="by" select="'&#09;'" />
     </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name(.) = 'br'">
     <!-- do nothing -->
    </xsl:when>
    <xsl:when test="local-name(.) = 'ul'">
     <list>
      <xsl:for-each select="h:li">
       <list-item dir="ltr"><xsl:call-template name="content"/></list-item>
      </xsl:for-each>
     </list>
    </xsl:when>
    <xsl:when test="local-name(.) = 'b'">
     <bold><xsl:call-template name="content"/></bold>
    </xsl:when>
    <xsl:when test="local-name(.) = 'i'">
     <italic><xsl:call-template name="content"/></italic>
    </xsl:when>
    <xsl:when test="local-name(.) = 'span' and @class = 'strikethrough'">
     <strikethrough><xsl:call-template name="content"/></strikethrough>
    </xsl:when>
    <xsl:when test="local-name(.) = 'span' and @class = 'highlight'">
     <highlight><xsl:call-template name="content"/></highlight>
    </xsl:when>
    <xsl:when test="local-name(.) = 'span' and contains(@style, 'monospace')">
     <monospace><xsl:call-template name="content"/></monospace>
    </xsl:when>
    <xsl:when test="local-name(.) = 'span' and @class = 'small'">
     <xsl:text disable-output-escaping="yes">&lt;size:small></xsl:text>
     <xsl:call-template name="content"/>
     <xsl:text disable-output-escaping="yes">&lt;/size:small></xsl:text>
    </xsl:when>
    <xsl:when test="local-name(.) = 'span' and @class = 'large'">
     <xsl:text disable-output-escaping="yes">&lt;size:large></xsl:text>
     <xsl:call-template name="content"/>
     <xsl:text disable-output-escaping="yes">&lt;/size:large></xsl:text>
    </xsl:when>
    <xsl:when test="local-name(.) = 'span' and @class = 'huge'">
     <xsl:text disable-output-escaping="yes">&lt;size:huge></xsl:text>
     <xsl:call-template name="content"/>
     <xsl:text disable-output-escaping="yes">&lt;/size:huge></xsl:text>
    </xsl:when>
    <xsl:when test="local-name(.) = 'a' and contains(@href, '://')">
     <xsl:text disable-output-escaping="yes">&lt;link:url></xsl:text>
     <xsl:choose>
      <xsl:when test="starts-with(@href, 'file://')">
       <xsl:value-of select="substring(@href, 8)"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="@href"/>
      </xsl:otherwise>
     </xsl:choose>
     <xsl:text disable-output-escaping="yes">&lt;/link:url></xsl:text>
    </xsl:when>
    <xsl:when test="local-name(.) = 'a' and not(contains(@href, '://'))">
     <xsl:text disable-output-escaping="yes">&lt;link:internal></xsl:text>
     <xsl:call-template name="content"/>
     <xsl:text disable-output-escaping="yes">&lt;/link:internal></xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:message terminate="yes">
      Unsupported tag
      <xsl:value-of select="local-name(.)"/>
     </xsl:message>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:for-each>
 </xsl:template>

 <!-- http://geekswithblogs.net/Erik/archive/2008/04/01/120915.aspx -->
 <xsl:template name="string-replace-all">
  <xsl:param name="text" />
  <xsl:param name="replace" />
  <xsl:param name="by" />
  <xsl:choose>
   <xsl:when test="contains($text, $replace)">
    <xsl:value-of select="substring-before($text,$replace)" />
    <xsl:value-of select="$by" />
    <xsl:call-template name="string-replace-all">
     <xsl:with-param name="text" select="substring-after($text,$replace)" />
     <xsl:with-param name="replace" select="$replace" />
     <xsl:with-param name="by" select="$by" />
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$text" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
</xsl:stylesheet>
