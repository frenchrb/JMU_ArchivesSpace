<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead="urn:isbn:1-931666-22-9"
    exclude-result-prefixes="ead xs">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    
    <!-- Transforms EAD exported from ArchivesSpace into MARCXML record for JMU Library Catalog
    Created 11/14/2017 by Rebecca B. French, Metadata Analyst Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License -->

    <xsl:template match="/">
        <marc:collection xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            <xsl:apply-templates/>
        </marc:collection>
    </xsl:template>
    
    <xsl:template match="ead:ead">
        <xsl:variable name="titleString">
            <xsl:analyze-string select="normalize-space(ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/text())" regex="A Guide to the (.*?)(\d{{4}}.*\)?)$">
                <xsl:matching-substring>
                    <xsl:value-of select="normalize-space(regex-group(1))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:variable name="dateString">
            <xsl:analyze-string select="normalize-space(ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/text())" regex="A Guide to .*?(\d{{4}}.*\)?)$">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:variable name="date1">
            <xsl:analyze-string select="$dateString" regex="^\d{{4}}">
                <xsl:matching-substring>
                    <xsl:value-of select="."/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        
        <xsl:variable name="date2">
            <xsl:choose>
                <xsl:when test="contains($dateString, '(')">
                    <xsl:analyze-string select="$dateString" regex="(\d{{4}}) \(">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:analyze-string select="$dateString" regex="(\d{{4}})$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <marc:record>
            <xsl:element name="marc:leader">
                <xsl:text>     npc a22     Ii 4500</xsl:text>
            </xsl:element>
            <marc:controlfield tag="008">
                <xsl:value-of
                    select="format-date(current-date(),'[Y,2-2][M01][D01]')"/>
                <xsl:choose>
                    <xsl:when test="$date1=$date2">
                        <xsl:text>s</xsl:text>
                        <xsl:value-of select="$date1"/>
                        <xsl:text>    </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>i</xsl:text>
                        <xsl:value-of select="$date1"/>
                        <xsl:value-of select="$date2"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>vau                 eng d</xsl:text>
            </marc:controlfield>
            
            <marc:datafield tag="040" ind1=" " ind2=" ">
                <marc:subfield code="a">VMC</marc:subfield>
                <marc:subfield code="b">eng</marc:subfield>
                <marc:subfield code="e">rda</marc:subfield>
                <marc:subfield code="c">VMC</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="049" ind1=" " ind2=" ">
                <marc:subfield code="a">VMCS</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="099" ind1=" " ind2="9">
                <xsl:analyze-string select="normalize-space(ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/ead:num/text())" regex="^(SC|UA|SdArch) (\d*)$">
                    <xsl:matching-substring>
                        <marc:subfield code="a">
                            <xsl:value-of select="regex-group(1)"/>
                        </marc:subfield>
                        <marc:subfield code="a">
                            <xsl:value-of select="regex-group(2)"/>
                        </marc:subfield>
                    </xsl:matching-substring>
                </xsl:analyze-string> 
            </marc:datafield> 
            
            <marc:datafield tag="100" ind1="1" ind2=" ">
                <marc:subfield code="a">CREATOR</marc:subfield>
            </marc:datafield>
            
            <xsl:variable name="nonfilingChars">
                <xsl:choose>
                    <xsl:when test="matches($titleString, '^[aA] ')">2</xsl:when>
                    <xsl:when test="matches($titleString, '^[aA]n ')">3</xsl:when>
                    <xsl:when test="matches($titleString, '^[tT]he ')">4</xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <marc:datafield tag="245" ind1="1" ind2="{$nonfilingChars}">
                <marc:subfield code="a">
                    <xsl:value-of select="concat(upper-case(substring($titleString, 1, 1)), substring($titleString, 2))"/>
                    <xsl:if test="not($dateString)">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </marc:subfield>
                <xsl:if test="$dateString">
                    <marc:subfield code="f">
                        <xsl:value-of select="$dateString"/>
                        <xsl:text>.</xsl:text>
                    </marc:subfield>
                </xsl:if>
            </marc:datafield>
            
            <xsl:for-each select="ead:archdesc/ead:did/ead:physdesc/ead:extent[@altrender]/..">
                <marc:datafield tag="300" ind1=" " ind2=" ">
                    <marc:subfield code="a">
                        <xsl:value-of select="./ead:extent[@altrender='carrier']/text()"/>
                        <xsl:text>; </xsl:text>
                        <xsl:for-each select="./ead:extent[not(@altrender='carrier')]">
                            <xsl:value-of select="./text()"/>
                            <xsl:if test="not(position()=last())">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:text>.</xsl:text>
                    </marc:subfield>
                </marc:datafield>
            </xsl:for-each>
            
            <marc:datafield tag="336" ind1=" " ind2=" ">
                <marc:subfield code="a">text</marc:subfield>
                <marc:subfield code="b">txt</marc:subfield>
                <marc:subfield code="2">rdacontent</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="337" ind1=" " ind2=" ">
                <marc:subfield code="a">unmediated</marc:subfield>
                <marc:subfield code="b">n</marc:subfield>
                <marc:subfield code="2">rdamedia</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="a">volume</marc:subfield>
                <marc:subfield code="b">nc</marc:subfield>
                <marc:subfield code="2">rdacarrier</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="351" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:for-each select="ead:archdesc/ead:arrangement/ead:p">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </marc:subfield>
            </marc:datafield>
            
            <xsl:for-each select="ead:archdesc/ead:accessrestrict/ead:p">
                <marc:datafield tag="506" ind1=" " ind2=" ">
                    <marc:subfield code="a">
                        <xsl:value-of select="normalize-space(.)"/>
                    </marc:subfield>
                </marc:datafield>
            </xsl:for-each>
            <marc:datafield tag="520" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:did/ead:abstract)"/>
                </marc:subfield>
            </marc:datafield>
            <marc:datafield tag="524" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:prefercite/ead:p)"/>
                </marc:subfield>
            </marc:datafield>
            <marc:datafield tag="541" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:value-of select="normalize-space(ead:archdesc/ead:acqinfo/ead:p)"/>
                </marc:subfield>
            </marc:datafield>
            <marc:datafield tag="545" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:for-each select="ead:archdesc/ead:bioghist/ead:p">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </marc:subfield>
            </marc:datafield>
            <marc:datafield tag="555" ind1="0" ind2=" ">
                <marc:subfield code="a">View detailed inventory and request for use in Special Collections:</marc:subfield>
                <marc:subfield code="u">URL</marc:subfield>
            </marc:datafield>
            <marc:datafield tag="561" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:for-each select="ead:archdesc/ead:custodhist/ead:p">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </marc:subfield>
            </marc:datafield>
            
            <xsl:for-each select="ead:archdesc/ead:controlaccess/ead:subject[@source='lcsh']">
                <marc:datafield tag="6XX" ind1=" " ind2="0">
                    <xsl:for-each select="tokenize(., ' -- ')">
                        <marc:subfield code="a">
                            <xsl:value-of select="normalize-space(.)"/>
                            <xsl:if test="position() = last()">
                                <xsl:text>.</xsl:text>
                            </xsl:if>
                        </marc:subfield>
                    </xsl:for-each>    
                </marc:datafield>
            </xsl:for-each>
            <xsl:for-each select="ead:archdesc/ead:controlaccess/ead:genreform">
                <marc:datafield tag="655" ind1=" " ind2="7">
                    <marc:subfield code="a">
                        <xsl:value-of select="normalize-space(concat(upper-case(substring(.,1,1)),lower-case(substring(.,2))))"/>
                        <xsl:if test="not(ends-with(., ')'))">
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                    </marc:subfield>
                    <marc:subfield code="2">
                        <xsl:value-of select="@source"/>
                    </marc:subfield>
                </marc:datafield>
            </xsl:for-each>
            
            <marc:datafield tag="856" ind1="4" ind2="2">
                <marc:subfield code="z">Finding aid for this collection</marc:subfield>
                <marc:subfield code="u">URL</marc:subfield>
            </marc:datafield>          
        </marc:record>
    </xsl:template>
</xsl:stylesheet>
