<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:ns2="http://www.w3.org/1999/xlink" 
    xmlns:local="http://www.yoursite.org/namespace" 
    xmlns:ead="urn:isbn:1-931666-22-9" version="2.0"  exclude-result-prefixes="#all">
    
    <xsl:output indent="yes" method="html"
        exclude-result-prefixes="#all"
        omit-xml-declaration="yes"
        encoding="utf-8"/>
    
    <!-- Transforms EAD exported from ArchivesSpace into HTML for JMU Libraries website
    Created 06/12/2018 by Rebecca B. French, Metadata Analyst Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License -->
    
    <xsl:template match="ead:ead">
        <div>
            <p>
                <strong><xsl:text>Collection No.: </xsl:text></strong>
                <xsl:value-of select="normalize-space(ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:num)"/>
                <xsl:text>&#x9;</xsl:text>
                <strong><xsl:text>Extent: </xsl:text></strong>
                <xsl:value-of select="lower-case(ead:archdesc/ead:did/ead:physdesc/ead:extent[@altrender='carrier']/text())"/>
                <xsl:text>; </xsl:text>
                <xsl:for-each select="ead:archdesc/ead:did/ead:physdesc/ead:extent[not(@altrender='carrier')]">
                    <xsl:value-of select="lower-case(./text())"/>
                    <xsl:if test="not(position()=last())">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <br />
                <xsl:value-of select="normalize-space(ead:archdesc/ead:did/ead:abstract)"/>
            </p>
        </div>
    </xsl:template>
</xsl:stylesheet>