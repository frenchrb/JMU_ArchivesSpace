<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
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
    Created 11/14/2017 by Rebecca B. French, Metadata Analyst Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License -->
        
    <xsl:template match="ead:ead">
        <div id="content" class="full">
            <div>
                <!--<xsl:analyze-string select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/text()" regex="A Guide to the ">
                    <xsl:matching-substring>
                        <p style="text-align:center;margin-top:0;margin-bottom:0;"><strong><xsl:value-of select="."/></strong></p>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <p style="text-align:center;margin-top:0;margin-bottom:0;"><strong><xsl:value-of select="."/></strong></p>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
                <p style="test-align:center;"><strong><xsl:value-of select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:num"/></strong></p> -->
                
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Descriptive Summary</strong></p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><xsl:text>&#160;</xsl:text></p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Repository: </strong>Special Collections, Carrier  Library, James Madison University</p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Title: </strong>
                    <xsl:analyze-string select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/text()" regex="A Guide to the ">
                        <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
                    </xsl:analyze-string>
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;">
                    <strong>Collection No.: </strong><xsl:value-of select="normalize-space(ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:num)"/><br />
                    <strong>Creator: </strong>
                    <xsl:choose>
                        <xsl:when test="ead:archdesc/ead:did/ead:origination[@label='creator']">
                            <xsl:for-each select="ead:archdesc/ead:did/ead:origination[@label='creator']">
                                <xsl:value-of select="normalize-space(.)"/>
                                <xsl:if test="not(position() = last())">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Unknown</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <br />
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong><xsl:text>Extent: </xsl:text></strong>
                    <xsl:value-of select="lower-case(ead:archdesc/ead:did/ead:physdesc/ead:extent[@altrender='carrier']/text())"/>
                    <xsl:text>; </xsl:text>
                    <xsl:for-each select="ead:archdesc/ead:did/ead:physdesc/ead:extent[not(@altrender='carrier')]">
                        <xsl:value-of select="lower-case(./text())"/>
                        <xsl:if test="not(position()=last())">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong><xsl:text>Language: </xsl:text></strong>
                    <xsl:value-of select="ead:archdesc/ead:did/ead:langmaterial/ead:language"/>
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong><xsl:text>Abstract: </xsl:text></strong>
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:did/ead:abstract)"/>
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><xsl:text>&#160;</xsl:text></p>
                
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Administrative Information</strong></p>

                <p align="left" style="margin-top:0;margin-bottom:0;"><strong><xsl:text>Access Restrictions: </xsl:text></strong>
                    <xsl:for-each select="ead:archdesc/ead:accessrestrict/ead:p">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong><xsl:text>Use Restrictions: </xsl:text></strong>
                    <xsl:for-each select="ead:archdesc/ead:userestrict/ead:p">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong><xsl:text>Preferred Citation: </xsl:text></strong>
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:prefercite/ead:p)"/>
                </p>
                <p align="left" style="margin-top:0;">
                    <strong><xsl:text>Acquisition Information: </xsl:text></strong>
                    <xsl:for-each select="ead:archdesc/ead:acqinfo/ead:p">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <br />
                    
                    <xsl:if test="ead:archdesc/ead:altformavail">
                        <strong><xsl:text>Alternate Formats: </xsl:text></strong>
                        <xsl:for-each select="ead:archdesc/ead:altformavail/ead:p">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:for-each>
                        <br />
                    </xsl:if>
                    
                    <xsl:if test="ead:archdesc/ead:custodhist">
                        <strong><xsl:text>Provenance: </xsl:text></strong>
                        <xsl:for-each select="ead:archdesc/ead:custodhist/ead:p">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:for-each>
                        <br />
                    </xsl:if>
                    
                    <xsl:if test="ead:archdesc/ead:processinfo">
                        <strong><xsl:text>Processing Information: </xsl:text></strong>
                        <xsl:for-each select="ead:archdesc/ead:processinfo/ead:p">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:for-each>
                    </xsl:if>
                </p>
                
                <!--Bio/Historical Note or Administrative History-->
                <p align="left" style="margin-top:0;margin-bottom:0;">
                    <strong>
                        <xsl:value-of select="ead:archdesc/ead:bioghist/ead:head"/>
                        <xsl:text>:</xsl:text>
                    </strong>
                </p>
                <xsl:for-each select="ead:archdesc/ead:bioghist/ead:p">
                    <p align="left"><xsl:value-of select="normalize-space(.)"/></p>
                </xsl:for-each>
                
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Scope and Content:</strong></p>
                <xsl:for-each select="ead:archdesc/ead:scopecontent/ead:p">
                    <p align="left"><xsl:value-of select="normalize-space(.)"/></p>
                </xsl:for-each>
                        
                <p align="left"><strong>Arrangement:</strong></p>
                <p align="left">
                    <xsl:for-each select="ead:archdesc/ead:arrangement/ead:p">
                        <xsl:value-of select="normalize-space(.)"/><br />                        
                    </xsl:for-each>
                </p>
                
                <xsl:if test="ead:archdesc/ead:bibliography">
                    <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Bibliography:</strong></p>
                    <xsl:for-each select="ead:archdesc/ead:bibliography/ead:bibref">
                        <p align="left">
                            <xsl:value-of select="normalize-space(.)"/><br />                        
                        </p>
                    </xsl:for-each>
                </xsl:if>

                <xsl:if test="ead:archdesc/ead:originalsloc">
                    <p align="left"><strong><xsl:text>Location of Originals:</xsl:text></strong></p>
                    <xsl:for-each select="ead:archdesc/ead:originalsloc/ead:p">
                        <p><xsl:value-of select="normalize-space(.)"/></p>                        
                    </xsl:for-each>
                </xsl:if>
                
                <xsl:if test="ead:archdesc/ead:relatedmaterial">
                    <p align="left"><strong><xsl:text>Related Material:</xsl:text></strong></p>
                    <xsl:for-each select="ead:archdesc/ead:relatedmaterial/ead:p">
                        <p><xsl:value-of select="normalize-space(.)"/></p>
                    </xsl:for-each>
                </xsl:if>
                
                <xsl:if test="ead:archdesc/ead:separatedmaterial">
                    <p align="left"><strong><xsl:text>Separated Material:</xsl:text></strong></p>
                    <xsl:for-each select="ead:archdesc/ead:separatedmaterial/ead:p">
                        <p><xsl:value-of select="normalize-space(.)"/></p>
                    </xsl:for-each>
                </xsl:if> 
                
                <p align="left"><strong>Contents:</strong></p>
                <xsl:choose>
                    <xsl:when test="ead:archdesc/ead:dsc/ead:c01[@level='series']">
                        <xsl:for-each select="ead:archdesc/ead:dsc/ead:c01">
                            <p align="left"><strong>
                                <xsl:value-of select="normalize-space(ead:did/ead:unitid)"/>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
                                <xsl:text>, </xsl:text>
                                <!--<xsl:value-of select="normalize-space(ead:did/ead:unitdate)"/>-->
                                <xsl:choose>
                                    <xsl:when test="not(ead:did/ead:unitdate)">
                                        <xsl:text>undated</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- list all non-bulk unitdates -->
                                        <xsl:for-each
                                            select="ead:did/ead:unitdate[@type != 'bulk'] | ead:did/ead:unitdate[not(@type)]">
                                            <xsl:choose>
                                                <xsl:when test="position() = 1">
                                                    <xsl:value-of select="."/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>, </xsl:text>
                                                    <xsl:value-of select="."/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                        <!-- bulk unitdate -->
                                        <xsl:if test="ead:did/ead:unitdate[@type = 'bulk']">
                                            <xsl:text> (bulk </xsl:text>
                                            <xsl:value-of select="ead:did/ead:unitdate[@type = 'bulk']"/>
                                            <xsl:text>)</xsl:text>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </strong></p>
                            <xsl:for-each select="ead:scopecontent/ead:p">
                                <p align="left"><xsl:value-of select="normalize-space(.)"/></p>
                            </xsl:for-each>
                        
                            <table border="1" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="666" valign="top"><strong>Title</strong></td>
                                    <td width="250" valign="top"><div align="right"><strong>Container</strong></div></td>
                                </tr>
                                <xsl:for-each select="ead:c02">
                                    <xsl:choose>
                                        <xsl:when test=".[@level = 'subseries']">
                                            <tr>
                                                <td valign="top">
                                                    <strong>
                                                        <xsl:text>Subseries: </xsl:text> <!-- TODO change this to unitid -->
                                                        <xsl:value-of select="normalize-space(./ead:did/ead:unittitle)"/>
                                                        <xsl:text>, </xsl:text>
                                                        <xsl:choose>
                                                            <xsl:when test="not(ead:did/ead:unitdate)">
                                                                <xsl:text>undated</xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <!-- list all non-bulk unitdates -->
                                                                <xsl:for-each
                                                                    select="ead:did/ead:unitdate[@type != 'bulk'] | ead:did/ead:unitdate[not(@type)]">
                                                                    <xsl:choose>
                                                                        <xsl:when test="position() = 1">
                                                                            <xsl:value-of select="."/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:text>, </xsl:text>
                                                                            <xsl:value-of select="."/>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:for-each>
                                                                <!-- bulk unitdate -->
                                                                <xsl:if test="ead:did/ead:unitdate[@type = 'bulk']">
                                                                    <xsl:text> (bulk </xsl:text>
                                                                    <xsl:value-of select="ead:did/ead:unitdate[@type = 'bulk']"/>
                                                                    <xsl:text>)</xsl:text>
                                                                </xsl:if>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </strong>
                                                </td>
                                                <td></td>
                                            </tr>
                                            <xsl:for-each select="./ead:c03">
                                                <tr>
                                                    <td valign="top">
                                                        <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
                                                        <xsl:text>, </xsl:text>
                                                        <xsl:choose>
                                                            <xsl:when test="not(ead:did/ead:unitdate)">
                                                                <xsl:text>undated</xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <!-- list all non-bulk unitdates -->
                                                                <xsl:for-each
                                                                    select="ead:did/ead:unitdate[@type != 'bulk'] | ead:did/ead:unitdate[not(@type)]">
                                                                    <xsl:choose>
                                                                        <xsl:when test="position() = 1">
                                                                            <xsl:value-of select="."/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:text>, </xsl:text>
                                                                            <xsl:value-of select="."/>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </xsl:for-each>
                                                                <!-- bulk unitdate -->
                                                                <xsl:if test="ead:did/ead:unitdate[@type = 'bulk']">
                                                                    <xsl:text> (bulk </xsl:text>
                                                                    <xsl:value-of select="ead:did/ead:unitdate[@type = 'bulk']"/>
                                                                    <xsl:text>)</xsl:text>
                                                                </xsl:if>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                        <xsl:if test="ead:accessrestrict">
                                                            <xsl:text> RESTRICTED</xsl:text>
                                                        </xsl:if>
                                                        <!-- Add folder/item scopecontent if it exists -->
                                                        <xsl:if test="(.[@level = 'file'] or .[@level = 'item']) and ./ead:scopecontent">
                                                            <xsl:for-each select="./ead:scopecontent/ead:p">
                                                                <p style="margin-left:2em;margin-top:0em"><xsl:value-of select="."/></p>
                                                            </xsl:for-each>
                                                        </xsl:if>
                                                        <!-- Add item-level info if it exists -->
                                                        <xsl:if test="./ead:c04[@level = 'item']">
                                                            <xsl:for-each select="./ead:c04">
                                                                <p style="margin-left:2em;margin-top:0em;margin-bottom:0em">
                                                                    <xsl:value-of select="normalize-space(./ead:did/ead:unittitle)"/>
                                                                    <xsl:text>, </xsl:text>
                                                                    <xsl:choose>
                                                                        <xsl:when test="not(ead:did/ead:unitdate)">
                                                                            <xsl:text>undated</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <!-- list all non-bulk unitdates -->
                                                                            <xsl:for-each select="ead:did/ead:unitdate[@type != 'bulk'] | ead:did/ead:unitdate[not(@type)]">
                                                                                <xsl:choose>
                                                                                    <xsl:when test="position() = 1">
                                                                                        <xsl:value-of select="."/>
                                                                                    </xsl:when>
                                                                                    <xsl:otherwise>
                                                                                        <xsl:text>, </xsl:text>
                                                                                        <xsl:value-of select="."/>
                                                                                    </xsl:otherwise>
                                                                                </xsl:choose>
                                                                            </xsl:for-each>
                                                                            <!-- bulk unitdate -->
                                                                            <xsl:if test="ead:did/ead:unitdate[@type = 'bulk']">
                                                                                <xsl:text> (bulk </xsl:text>
                                                                                <xsl:value-of select="ead:did/ead:unitdate[@type = 'bulk']"/>
                                                                                <xsl:text>)</xsl:text>
                                                                            </xsl:if>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </p>
                                                            </xsl:for-each>
                                                        </xsl:if>
                                                    </td>
                                                    <td valign="top"><div align="right">
                                                        <!-- print each container type and number -->
                                                        <xsl:for-each select="ead:did/ead:container">
                                                            <!--<xsl:value-of select="upper-case(./@type)"/>-->
                                                            <xsl:value-of select="concat(upper-case(substring(./@type, 1, 1)), substring(./@type, 2))"/>
                                                            <xsl:text> </xsl:text>
                                                            <xsl:value-of select="."/>
                                                            <xsl:if test="not(position() = last())">
                                                                <xsl:text>:</xsl:text>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </div></td>
                                                </tr>
                                            </xsl:for-each>
                                            </xsl:when>
                                        <xsl:otherwise>
                                            <tr>
                                                <td valign="top">
                                                    <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
                                                    <xsl:text>, </xsl:text>
                                                    <xsl:choose>
                                                        <xsl:when test="not(ead:did/ead:unitdate)">
                                                            <xsl:text>undated</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <!-- list all non-bulk unitdates -->
                                                            <xsl:for-each select="ead:did/ead:unitdate[@type != 'bulk'] | ead:did/ead:unitdate[not(@type)]">
                                                                <xsl:choose>
                                                                    <xsl:when test="position() = 1">
                                                                        <xsl:value-of select="."/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:text>, </xsl:text>
                                                                        <xsl:value-of select="."/>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:for-each>
                                                            <!-- bulk unitdate -->
                                                            <xsl:if test="ead:did/ead:unitdate[@type = 'bulk']">
                                                                <xsl:text> (bulk </xsl:text>
                                                                <xsl:value-of select="ead:did/ead:unitdate[@type = 'bulk']"/>
                                                                <xsl:text>)</xsl:text>
                                                            </xsl:if>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    <xsl:if test="ead:accessrestrict">
                                                        <xsl:text> RESTRICTED</xsl:text>
                                                    </xsl:if>
                                                    <!-- Add folder/item scopecontent if it exists -->
                                                    <xsl:if test="(.[@level = 'file'] or .[@level = 'item']) and ./ead:scopecontent">
                                                        <xsl:for-each select="./ead:scopecontent/ead:p">
                                                            <p style="margin-left:2em;margin-top:0em"><xsl:value-of select="."/></p>
                                                        </xsl:for-each>
                                                    </xsl:if>
                                                    <!-- Add item-level info if it exists -->
                                                    <xsl:if test="./ead:c03[@level = 'item']">
                                                        <xsl:for-each select="./ead:c03">
                                                            <p style="margin-left:2em;margin-top:0em;margin-bottom:0em">
                                                                <xsl:value-of select="normalize-space(./ead:did/ead:unittitle)"/>
                                                                <xsl:text>, </xsl:text>
                                                                <xsl:choose>
                                                                    <xsl:when test="not(ead:did/ead:unitdate)">
                                                                        <xsl:text>undated</xsl:text>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <!-- list all non-bulk unitdates -->
                                                                        <xsl:for-each select="ead:did/ead:unitdate[@type != 'bulk'] | ead:did/ead:unitdate[not(@type)]">
                                                                            <xsl:choose>
                                                                                <xsl:when test="position() = 1">
                                                                                    <xsl:value-of select="."/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:text>, </xsl:text>
                                                                                    <xsl:value-of select="."/>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:for-each>
                                                                        <!-- bulk unitdate -->
                                                                        <xsl:if test="ead:did/ead:unitdate[@type = 'bulk']">
                                                                            <xsl:text> (bulk </xsl:text>
                                                                            <xsl:value-of select="ead:did/ead:unitdate[@type = 'bulk']"/>
                                                                            <xsl:text>)</xsl:text>
                                                                        </xsl:if>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </p>
                                                        </xsl:for-each>
                                                    </xsl:if>
                                                </td>
                                                <td valign="top"><div align="right">
                                                    <!-- print each container type and number -->
                                                    <xsl:for-each select="ead:did/ead:container">
                                                        <!--<xsl:value-of select="upper-case(./@type)"/>-->
                                                        <xsl:value-of select="concat(upper-case(substring(./@type, 1, 1)), substring(./@type, 2))"/>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="."/>
                                                        <xsl:if test="not(position() = last())">
                                                            <xsl:text>:</xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </div></td>
                                            </tr>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </table>
                        <br />
                        </xsl:for-each>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <table border="1" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="666" valign="top"><strong>Title</strong></td>
                                <td width="250" valign="top"><div align="right"><strong>Container</strong></div></td>
                            </tr>
                            <xsl:for-each select="ead:archdesc/ead:dsc/ead:c01">
                                <tr>
                                    <td valign="top">
                                        <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
                                        <xsl:text>, </xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="not(ead:did/ead:unitdate)">
                                                <xsl:text>undated</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!-- list all non-bulk unitdates -->
                                                <xsl:for-each
                                                    select="ead:did/ead:unitdate[@type != 'bulk'] | ead:did/ead:unitdate[not(@type)]">
                                                    <xsl:choose>
                                                        <xsl:when test="position() = 1">
                                                            <xsl:value-of select="."/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:text>, </xsl:text>
                                                            <xsl:value-of select="."/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:for-each>
                                                <!-- bulk unitdate -->
                                                <xsl:if test="ead:did/ead:unitdate[@type = 'bulk']">
                                                    <xsl:text> (bulk </xsl:text>
                                                    <xsl:value-of select="ead:did/ead:unitdate[@type = 'bulk']"/>
                                                    <xsl:text>)</xsl:text>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- Add folder/item scopecontent if it exists -->
                                        <xsl:if test="(.[@level = 'file'] or .[@level = 'item']) and ./ead:scopecontent">
                                            <xsl:for-each select="./ead:scopecontent/ead:p">
                                                <p style="margin-left:2em;margin-top:0em"><xsl:value-of select="."/></p>
                                            </xsl:for-each>
                                        </xsl:if>
                                        <!-- Add item-level info if it exists -->
                                        <xsl:if test="./ead:c02[@level = 'item']">
                                            <xsl:for-each select="./ead:c02">
                                                <p style="margin-left:2em;margin-top:0em;margin-bottom:0em">
                                                    <xsl:value-of select="normalize-space(./ead:did/ead:unittitle)"/>
                                                    <xsl:text>, </xsl:text>
                                                    <xsl:choose>
                                                        <xsl:when test="not(ead:did/ead:unitdate)">
                                                            <xsl:text>undated</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <!-- list all non-bulk unitdates -->
                                                            <xsl:for-each select="ead:did/ead:unitdate[@type != 'bulk'] | ead:did/ead:unitdate[not(@type)]">
                                                                <xsl:choose>
                                                                    <xsl:when test="position() = 1">
                                                                        <xsl:value-of select="."/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:text>, </xsl:text>
                                                                        <xsl:value-of select="."/>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:for-each>
                                                            <!-- bulk unitdate -->
                                                            <xsl:if test="ead:did/ead:unitdate[@type = 'bulk']">
                                                                <xsl:text> (bulk </xsl:text>
                                                                <xsl:value-of select="ead:did/ead:unitdate[@type = 'bulk']"/>
                                                                <xsl:text>)</xsl:text>
                                                            </xsl:if>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </p>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </td>
                                    <td valign="top"><div align="right">
                                        <!-- print each container type and number -->
                                        <xsl:for-each select="ead:did/ead:container">
                                            <!--<xsl:value-of select="upper-case(./@type)"/>-->
                                            <xsl:value-of select="concat(upper-case(substring(./@type, 1, 1)), substring(./@type, 2))"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="."/>
                                            <xsl:if test="not(position() = last())">
                                                <xsl:text>:</xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </div></td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    <br />
                    </xsl:otherwise>
                </xsl:choose>
            </div>
            <div>
                <p><strong><xsl:text>Compiled by: </xsl:text></strong><xsl:value-of select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:author"/></p>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>