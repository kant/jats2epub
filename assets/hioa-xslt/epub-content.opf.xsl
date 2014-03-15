<?xml version="1.0" encoding="UTF-8"?>
<!--
	Overview:
	
	This stylesheet generates content.opf, a required file in the ePub format.
	It copies over relevant data from a journal article tagged using NISO jats xml.
	
	Author: Trude Eikebrokk, Oslo and Akershus University College of Applied Sciences
	
	License:
	
	This file is part of jats2epub.

	jats2epub is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	jats2epub is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with jats2epub.  If not, see http://www.gnu.org/licenses/gpl.html
	
	Contact: trude dot eikebrokk at hioa dot no, tor-arne dot dahl at hioa dot no, eirik dot hanssen at hioa dot no
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	version="1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8"/>
  <!-- Parameters' default values can be altered here, or overridden with parameters sent to the stylesheet when it is called -->
  <xsl:param name="css-stylesheet" select="'hioa-epub.css'"/>
  <xsl:param name="article-xhtml" select="'index.html'"/>

  <xsl:template match="/">
    <package xmlns="http://www.idpf.org/2007/opf" unique-identifier="bookid" version="2.0">
      <xsl:for-each select="article/front">
        <metadata xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:opf="http://www.idpf.org/2007/opf">
          <dc:title>
            <xsl:value-of select="article-meta/title-group/article-title"/>
          </dc:title>
          <dc:language><xsl:value-of select="/article/@xml:lang"/></dc:language>
          <dc:creator>
            <xsl:for-each select="article-meta/contrib-group/contrib[@contrib-type='author']">
              <xsl:value-of select="name/given-names"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="name/surname"/>
            </xsl:for-each>
          </dc:creator>
          <dc:rights>
            <xsl:value-of select="article-meta/permissions/license/license-p"/>
          </dc:rights>
          <dc:publisher>
            <xsl:value-of select="journal-meta/journal-title-group/journal-title"/>
          </dc:publisher>
          <dc:identifier id="bookid">
            <xsl:text>DOI:</xsl:text>
            <xsl:value-of select="article-meta/article-id[@pub-id-type='doi']"/>
          </dc:identifier>
          <xsl:for-each select="article-meta/kwd-group[@kwd-group-type='author-generated']/kwd">
            <dc:subject>
              <xsl:value-of select="."/>
            </dc:subject>
          </xsl:for-each>
        </metadata>
      </xsl:for-each>
      <manifest>
        <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
        <!-- CSS-name from parameter, using default value if no parameter is supplied to the stylesheet -->
        <item id="style" media-type="text/css"><xsl:attribute name="href" select="concat('css/', $css-stylesheet)"/></item>
        <!-- Article source from parameter, default value used if no parameter is supplied to the stylesheet -->
        <item id="article" media-type="application/xhtml+xml">
          <xsl:attribute name="href" select="$article-xhtml"/>
        </item>
        <!--Dependency: graphic ID needs to be present -->
        <xsl:for-each select="article/body/sec/sec/fig">
        <!--<xsl:for-each select="//fig">-->
          <item>
            <xsl:attribute name="id">
              <xsl:value-of select="graphic/@id"/>
            </xsl:attribute>
            <xsl:attribute name="media-type">
              <xsl:text>image/</xsl:text>
              <xsl:value-of select="substring-after(graphic/@xlink:href, '.')"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:value-of select="graphic/@xlink:href"/>
            </xsl:attribute>
          </item>
        </xsl:for-each>
        <item id="cc-licence" media-type="image/png" href="images/cc-license.png"/>
        <item id="pp-logo" media-type="image/png" href="images/pp-logo_trans.png"/>
      </manifest>
      <spine toc="ncx">
        <itemref idref="article"/>
      </spine>
    </package>
  </xsl:template>
  
</xsl:stylesheet>
