<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:ns2="http://www.w3.org/1999/xlink" 
    xmlns:local="http://www.yoursite.org/namespace" 
    xmlns:ead="urn:isbn:1-931666-22-9" version="2.0"  exclude-result-prefixes="#all">
    
    <xsl:output indent="yes" method="xml"
        exclude-result-prefixes="#all"
        omit-xml-declaration="yes"
        encoding="utf-8"/>
    
    <!-- Transforms EAD exported from ArchivesSpace into HTML for LET website
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
                <!--<p align="left" style="margin-top:0;margin-bottom:0;"><strong>&nbsp;</strong></p>-->
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Repository: </strong>Special Collections, Carrier  Library, James Madison University</p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Title: </strong>
                    <xsl:analyze-string select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/text()" regex="A Guide to the ">
                        <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
                    </xsl:analyze-string>
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Collection No.: </strong><xsl:value-of select="normalize-space(ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:num)"/><br />
                    <strong>Creator: </strong>NOT AVAILABLE IN ASPACE EAD<br />
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

                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Administrative Information</strong></p>

                <p align="left" style="margin-top:0;margin-bottom:0;"><strong><xsl:text>Access Restrictions: </xsl:text></strong>
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:accessrestrict)"/>
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong><xsl:text>Use Restrictions: </xsl:text></strong>
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:userestrict/ead:p)"/>
                </p>
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong><xsl:text>Preferred Citation: </xsl:text></strong>
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:prefercite/ead:p)"/>
                </p>
                <p align="left" style="margin-top:0;">
                    <strong><xsl:text>Acquisition Information: </xsl:text></strong>
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:acqinfo/ead:p)"/><br />
                    <strong><xsl:text>Provenance: </xsl:text></strong>
                    <xsl:for-each select="ead:archdesc/ead:custodhist/ead:p">
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:for-each>
                    <!--<xsl:value-of select="normalize-space(ead:archdesc/ead:custodhist/ead:p)"/><br />-->
                    <strong><xsl:text>Processing Information: </xsl:text></strong>
                    <xsl:for-each select="ead:archdesc/ead:processinfo/ead:p">
                        <xsl:value-of select="normalize-space(.)"/>
                    </xsl:for-each>
                    <!--<xsl:value-of select="normalize-space(ead:archdesc/ead:processinfo/ead:p)"/>-->
                </p>
                
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Bio/Historical Note:</strong></p>
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
                
                <p align="left" style="margin-top:0;margin-bottom:0;"><strong>Bibliography:</strong></p>
                <xsl:for-each select="ead:archdesc/ead:bibliography/ead:bibref">
                    <p align="left">
                        <xsl:value-of select="normalize-space(.)"/><br />                        
                    </p>
                </xsl:for-each>
                
                <p align="left"><strong><xsl:text>Separated Material: </xsl:text></strong>
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:separatedmaterial/ead:p)"/>
                </p>
                
                <p align="left"><strong>Contents:</strong></p>
                <xsl:choose>
                    <xsl:when test="ead:archdesc/ead:dsc/ead:c01[@level='series']">
                        <xsl:for-each select="ead:archdesc/ead:dsc/ead:c01">
                            <p align="left"><strong>
                                <xsl:value-of select="normalize-space(ead:did/ead:unitid)"/>
                                <xsl:text>: </xsl:text>
                                <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="normalize-space(ead:did/ead:unitdate)"/>
                            </strong></p>
                            <xsl:for-each select="ead:scopecontent/ead:p">
                                <p align="left"><xsl:value-of select="normalize-space(.)"/></p>
                            </xsl:for-each>
                        
                            <table border="1" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="666" valign="top"><strong>Folder Title</strong></td>
                                    <td width="155" valign="top"><div align="right"><strong>Box:Folder</strong></div></td>
                                </tr>
                                <xsl:for-each select="ead:c02">
                                    <tr>
                                        <td valign="top">
                                            <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
                                            <xsl:text>, </xsl:text>
                                            <xsl:value-of select="normalize-space(ead:did/ead:unitdate)"/>
                                        </td>
                                        <td valign="top"><div align="right">
                                            <xsl:value-of select="ead:did/ead:container[@type='box']"/>
                                            <xsl:if test="ead:did/ead:container[@type='folder']">
                                                <xsl:text>:</xsl:text>
                                                <xsl:value-of select="ead:did/ead:container[@type='folder']"/>
                                            </xsl:if>
                                        </div></td>
                                    </tr>
                                </xsl:for-each>
                            </table>
                        </xsl:for-each>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <table border="1" cellpadding="0" cellspacing="0">
                            <tr>
                                <td width="666" valign="top"><strong>Folder Title</strong></td>
                                <td width="155" valign="top"><div align="right"><strong>Box:Folder</strong></div></td>
                            </tr>
                            <xsl:for-each select="ead:archdesc/ead:dsc/ead:c01">
                                <tr>
                                    <td valign="top">
                                        <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
                                        <xsl:text>, </xsl:text>
                                        <xsl:value-of select="normalize-space(ead:did/ead:unitdate)"/>
                                    </td>
                                    <td valign="top"><div align="right">
                                        <xsl:value-of select="ead:did/ead:container[@type='box']"/>
                                        <xsl:if test="ead:did/ead:container[@type='folder']">
                                            <xsl:text>:</xsl:text>
                                            <xsl:value-of select="ead:did/ead:container[@type='folder']"/>
                                        </xsl:if>
                                    </div></td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!--
                <xsl:for-each select="ead:archdesc/ead:dsc/ead:c01">
                    <p align="left"><strong>
                        <xsl:value-of select="normalize-space(ead:did/ead:unitid)"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="normalize-space(ead:did/ead:unitdate)"/>
                    </strong></p>
                    <xsl:for-each select="ead:scopecontent/ead:p">
                        <p align="left"><xsl:value-of select="normalize-space(.)"/></p>
                    </xsl:for-each>
                    
                    <table border="1" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="666" valign="top"><strong>Folder Title</strong></td>
                            <td width="155" valign="top"><div align="right"><strong>Box:Folder</strong></div></td>
                        </tr>
                        <xsl:for-each select="ead:c02">
                            <tr>
                                <td valign="top">
                                    <xsl:value-of select="normalize-space(ead:did/ead:unittitle)"/>
                                    <xsl:text>, </xsl:text>
                                    <xsl:value-of select="normalize-space(ead:did/ead:unitdate)"/>
                                </td>
                                <td valign="top"><div align="right">
                                    <xsl:value-of select="ead:did/ead:container[@type='box']"/>
                                    <xsl:text>:</xsl:text>
                                    <xsl:value-of select="ead:did/ead:container[@type='folder']"/>
                                </div></td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </xsl:for-each>   
                -->
                
                <xsl:if test="ead:archdesc/ead:relatedmaterial">
                    <p align="left"><strong>Related Material:</strong></p>
                    <p align="left">
                        <xsl:for-each select="ead:archdesc/ead:relatedmaterial/ead:p">
                            <xsl:value-of select="normalize-space(.)"/><br />                        
                        </xsl:for-each>
                    </p>
                </xsl:if>
                
            </div>
            <div>
                <p><strong><xsl:text>Compiled by: </xsl:text></strong><xsl:value-of select="ead:eadheader/ead:filedesc/ead:titlestmt/ead:author"/></p>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>