<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" encoding="utf-8"/>
    
    <!-- Transforms EAD exported from ArchivesSpace into EAD for upload to Virginia Heritage
    Created 11/13/2017 by Rebecca B. French, Metadata Analyst Librarian at James Madison University
    This software is distributed under a Creative Commons Attribution Non-Commercial License -->
    
    <!-- Identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- eadheader titleproper -->
    <xsl:template match="/ead:ead/ead:eadheader/ead:filedesc/ead:titlestmt/ead:titleproper/text()">
        <xsl:value-of select="concat(normalize-space(.),':')"/>
    </xsl:template>
    
    <!-- eadheader publicationstmt -->
    <xsl:template match="/ead:ead/ead:eadheader/ead:filedesc/ead:publicationstmt">
        <xsl:element name="publicationstmt" namespace="urn:isbn:1-931666-22-9">
            <xsl:element name="publisher" namespace="urn:isbn:1-931666-22-9">
                <xsl:text>Special Collections, Carrier Library, James Madison University</xsl:text>
            </xsl:element>
            <xsl:element name="xi:include" namespace="http://www.w3.org/2001/XInclude">
                <xsl:attribute name="href">http://ead.lib.virginia.edu:/vivaead/add_con/jmu_address.xi.xml</xsl:attribute>
            </xsl:element>
            <xsl:element name="date" namespace="urn:isbn:1-931666-22-9">
                <xsl:attribute name="type">publication</xsl:attribute>
                <xsl:attribute name="era">ce</xsl:attribute>
                <xsl:attribute name="calendar">gregorian</xsl:attribute>
                <xsl:text> </xsl:text>
                <xsl:value-of select="replace(./ead:p/ead:date/text(), ' JMU Libraries', ' By JMU Libraries')"/>
                <xsl:text> </xsl:text>
            </xsl:element>
            <xsl:element name="p" namespace="urn:isbn:1-931666-22-9">
                <xsl:attribute name="id">usestatement</xsl:attribute>
                <xsl:element name="extref" namespace="http://www.w3.org/1999/xlink">
                    <xsl:attribute name="xlink:type">simple</xsl:attribute>
                    <xsl:attribute name="xlink:href">http://www.lib.virginia.edu/speccol/vhp/conditions.html</xsl:attribute>
                    <xsl:text>Conditions of Use</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- Modify profiledesc creation -->
    <xsl:template match="/ead:ead/ead:eadheader/ead:profiledesc/ead:creation/text()">
        <xsl:value-of select="replace(., ' on', ' and transformed with ASpace2VaHeritage.xsl on')"/>
    </xsl:template>
    
    <!-- Insert frontmatter -->
    <xsl:template match="ead:ead/ead:eadheader[not(../ead:frontmatter)]">
        <!--Copy eadheader sibling as usual-->
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <!--Add frontmatter immediately after it-->
        <xsl:element name="frontmatter" namespace="urn:isbn:1-931666-22-9">
            <xsl:element name="titlepage" namespace="urn:isbn:1-931666-22-9">
                <xsl:element name="titleproper" namespace="urn:isbn:1-931666-22-9">
                    <xsl:analyze-string select="ead:filedesc/ead:titlestmt/ead:titleproper/text()" regex=".*, ">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:element name="date" namespace="urn:isbn:1-931666-22-9">
                                <xsl:attribute name="era">ce</xsl:attribute>
                                <xsl:attribute name="calendar">gregorian</xsl:attribute>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:element>
                <xsl:element name="subtitle" namespace="urn:isbn:1-931666-22-9">
                    <xsl:text> A Collection in </xsl:text>
                    <xsl:element name="lb" namespace="urn:isbn:1-931666-22-9"/>
                    <xsl:text> Special Collections </xsl:text>
                    <xsl:element name="num" namespace="urn:isbn:1-931666-22-9">
                        <xsl:attribute name="type">Collection Number</xsl:attribute>
                        <xsl:value-of select="ead:filedesc/ead:titlestmt/ead:titleproper/ead:num"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="p" namespace="urn:isbn:1-931666-22-9">
                    <xsl:attribute name="id">logostmt</xsl:attribute>
                    <xsl:element name="extptr" namespace="http://www.w3.org/1999/xlink">
                        <xsl:attribute name="xlink:type">simple</xsl:attribute>
                        <xsl:attribute name="xlink:actuate">onLoad</xsl:attribute>
                        <xsl:attribute name="xlink:show">embed</xsl:attribute>
                        <xsl:attribute name="xlink:href">http://ead.lib.virginia.edu/vivaead/logos/jmu.jpg</xsl:attribute>
                    </xsl:element>
                    
                </xsl:element>
                <xsl:element name="publisher" namespace="urn:isbn:1-931666-22-9">
                    <xsl:text> Special Collections, Carrier Library, James Madison University </xsl:text>
                </xsl:element>              
                <xsl:element name="date" namespace="urn:isbn:1-931666-22-9">
                    <xsl:attribute name="type">publication</xsl:attribute>
                    <xsl:attribute name="era">ce</xsl:attribute>
                    <xsl:attribute name="calendar">gregorian</xsl:attribute>
                    <xsl:analyze-string select="ead:filedesc/ead:publicationstmt/ead:p/ead:date/text()" regex="\d{{4}}">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:element>
                <xsl:element name="xi:include" namespace="http://www.w3.org/2001/XInclude">
                    <xsl:attribute name="href">http://ead.lib.virginia.edu:/vivaead/add_con/jmu_contact.xi.xml</xsl:attribute>
                </xsl:element>
                <xsl:element name="list" namespace="urn:isbn:1-931666-22-9">
                    <xsl:attribute name="type">deflist</xsl:attribute>
                    <xsl:element name="defitem" namespace="urn:isbn:1-931666-22-9">
                        <xsl:element name="label" namespace="urn:isbn:1-931666-22-9">
                            <xsl:text>Processed by:</xsl:text>
                        </xsl:element>
                        <xsl:element name="item" namespace="urn:isbn:1-931666-22-9">
                            <xsl:value-of select="ead:filedesc/ead:titlestmt/ead:author/text()"/>
                        </xsl:element>    
                    </xsl:element>   
                </xsl:element>   
            </xsl:element>
        </xsl:element> 
    </xsl:template>
    
    <!-- Remove &amp;#13; from archdesc corpname -->
    <xsl:template match="ead:ead/ead:archdesc/ead:did/ead:repository/ead:corpname/text()">
        <xsl:value-of select="replace(., '&amp;#13; ', '')"/>
    </xsl:template>
    
    <!-- Add attributes to archdesc unitid -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:unitid">
        <xsl:copy>
            <xsl:attribute name="label">Collection Number</xsl:attribute>
            <xsl:attribute name="encodinganalog">099$a</xsl:attribute>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Modify archdesc origination attribute -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:origination/@label[.='creator']">
        <xsl:attribute name="label">Creator</xsl:attribute>
    </xsl:template>
    
    <!-- Combine physdesc extents -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:did/ead:physdesc">
        <xsl:element name="physdesc" namespace="urn:isbn:1-931666-22-9">
            <xsl:attribute name="label">Extent</xsl:attribute>
            <xsl:attribute name="encodinganalog">300$a</xsl:attribute>
            <xsl:for-each select="ead:extent">
                <xsl:value-of select="lower-case(./text())"/>
                <xsl:if test="not(position()=last())">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
    <!-- Reorder unitdate elements; add descgrp wrapper -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:did">
        <xsl:choose>
            <xsl:when test="unitdate">
                <xsl:apply-templates select="./unitdate[@type='inclusive']"/> <!-- TODO make sure this is including unitdates with no type -->
                <xsl:apply-templates select="./unitdate[@type='bulk']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="descgrp" namespace="urn:isbn:1-931666-22-9">
            <xsl:attribute name="type">admininfo</xsl:attribute>
            <xsl:element name="head" namespace="urn:isbn:1-931666-22-9">Administrative Information</xsl:element>
            <xsl:copy-of select="../ead:accessrestrict"/>
            <xsl:copy-of select="../ead:userestrict"/>
            <xsl:copy-of select="../ead:prefercite"/>
            <xsl:copy-of select="../ead:acqinfo"/>
            <xsl:copy-of select="../ead:custodhist"/>
            <xsl:copy-of select="../ead:processinfo"/>
        </xsl:element>
    </xsl:template>
    
    <!-- Remove archdesc/accessrestrict -->
    <xsl:template match="ead:ead/ead:archdesc/ead:accessrestrict"/>
        
    <!-- Remove archdesc/userestrict -->
    <xsl:template match="ead:ead/ead:archdesc/ead:userestrict"/>
    
    <!-- Remove archdesc/prefercite -->
    <xsl:template match="ead:ead/ead:archdesc/ead:prefercite"/>
    
    <!-- Remove archdesc/acqinfo -->
    <xsl:template match="ead:ead/ead:archdesc/ead:acqinfo"/>
    
    <!-- Remove archdesc/custodhist -->
    <xsl:template match="ead:ead/ead:archdesc/ead:custodhist"/>
    
    <!-- Remove archdesc/processinfo -->
    <xsl:template match="ead:ead/ead:archdesc/ead:processinfo"/>
    
    <!-- Change bibref elements to p in bibliography -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:bibliography/ead:bibref">
        <xsl:element name="p" namespace="urn:isbn:1-931666-22-9">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- Add head elements to controlaccess -->
    <xsl:template match="/ead:ead/ead:archdesc/ead:controlaccess">
        <xsl:if test="./ead:subject or ./ead:genreform">
            <xsl:element name="controlaccess" namespace="urn:isbn:1-931666-22-9">
                <xsl:element name="head" namespace="urn:isbn:1-931666-22-9">
                    <xsl:text>Index Terms</xsl:text>
                </xsl:element>
                <xsl:if test="./ead:subject">
                    <xsl:element name="controlaccess" namespace="urn:isbn:1-931666-22-9">
                    <xsl:element name="head" namespace="urn:isbn:1-931666-22-9">
                        <xsl:text>Subjects:</xsl:text>
                    </xsl:element>
                    <xsl:for-each select="./ead:subject">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:element>
                </xsl:if>
                <xsl:if test="./ead:genreform">
                    <xsl:element name="controlaccess" namespace="urn:isbn:1-931666-22-9">
                        <xsl:element name="head" namespace="urn:isbn:1-931666-22-9">
                            <xsl:text>Genre and Form Terms:</xsl:text>
                        </xsl:element>
                        <xsl:for-each select="./ead:genreform">
                            <xsl:copy-of select="."/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <!-- Move unitid and unitdate inside unittitle -->
    <xsl:template match="//ead:*[matches(name(), 'c\d\d')]/ead:did">
        <xsl:element name="did" namespace="urn:isbn:1-931666-22-9">
            <xsl:element name="unittitle" namespace="urn:isbn:1-931666-22-9">
                <xsl:if test="./ead:unitid">
                    <xsl:value-of select="./ead:unitid/text()"/>
                    <xsl:text>: </xsl:text>
                </xsl:if>
                <xsl:value-of select="./ead:unittitle/text()"/>
                <xsl:if test="./ead:unitdate">
                    <xsl:text>, </xsl:text>
                    <xsl:copy-of select="./ead:unitdate"/>
                </xsl:if>
            </xsl:element>
            <xsl:for-each select="./ead:container">
                <xsl:apply-templates select="."/> 
            </xsl:for-each>       
        </xsl:element>
    </xsl:template>
    
    <!-- Modify container label attribute -->
    <xsl:template match="//ead:*[matches(name(), 'c\d\d')]/ead:did/ead:container/@label[.='Mixed Materials']">
        <xsl:attribute name="label">Box:Folder</xsl:attribute>
    </xsl:template>
    
    <!--Remove date element in eadheader titleproper-->
    <xsl:template match="ead/eadheader/filedesc/titlestmt/titleproper/date">
        <xsl:value-of select="./text()"/>
    </xsl:template>
    
    <!--Remove "A Guide to" in frontmatter titleproper-->
    <xsl:template match="ead/frontmatter/titlepage/titleproper/text()">
        <xsl:variable name="var" select="concat(upper-case(substring(replace(., '^A? ?Guide to (.*)$', '$1'), 1, 1)), substring(replace(., '^A? ?Guide to (.*)$', '$1'), 2))"/>
        <xsl:value-of select="$var"/>
        <xsl:if test="../date and not(ends-with($var, ' ')) and not($var = '')">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <!--Remove date element in frontmatter titleproper-->
    <xsl:template match="ead/frontmatter/titlepage/titleproper/date">
        <xsl:value-of select="./text()"/>
    </xsl:template>
    
    <!--Change langusage to "English"-->
    <xsl:template match="ead/eadheader/profiledesc/langusage/text()">
        <xsl:text>English</xsl:text>
    </xsl:template>

    <!--If descrules exists, check content-->
    <xsl:template match="ead/eadheader/profiledesc/descrules/text()">
        <xsl:choose>
            <xsl:when test=". != 'Describing Archives: A Content Standard'">
                <xsl:text>Describing Archives: A Content Standard</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--If langusage doesn't have sibling descrules-->
    <xsl:template match="ead/eadheader/profiledesc/langusage[not(../descrules)]">
        <!--Copy langusage as usual-->
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <!--Add descrules immediately after it-->
        <xsl:element name="descrules" namespace="urn:isbn:1-931666-22-9">Describing Archives: A Content Standard</xsl:element> 
    </xsl:template>
    
    <!--Add "SC" to beginning of unitid if missing-->
    <!--<xsl:template match="ead/archdesc/did/unitid/text()[not(contains(., 'SC'))]">
        <xsl:text>SC </xsl:text><xsl:value-of select="."/>
    </xsl:template>-->
    
    <!--Correct order of extents in physdesc-->
    <xsl:template match="ead/archdesc/did/physdesc">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <!--Copy extent with type=shelf-->
            <xsl:apply-templates select="./extent[@type='shelf']"/>
            <!--Copy rest of extents-->
            <xsl:apply-templates select="./extent[@type!='shelf']|./extent[not(@type)]"/>
        </xsl:copy>
    </xsl:template>
    
    <!--Revision description-->
    <xsl:template match="ead/eadheader/revisiondesc/change[last()]">
        <!--Copy change as usual-->
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <!--Add revisiondesc with current date-->
        <xsl:element name="change" namespace="urn:isbn:1-931666-22-9">
            <xsl:element name="date" namespace="urn:isbn:1-931666-22-9">
                <xsl:attribute name="normal">
                    <xsl:value-of select="format-date(current-date(),'[Y0001][M01][D01]')"/>
                </xsl:attribute>
                <xsl:value-of select="format-date(current-date(), '[MNn] [D], [Y]')"/>
            </xsl:element>
            <xsl:element name="item" namespace="urn:isbn:1-931666-22-9">Cleaned with eadclean_content.xsl</xsl:element>
        </xsl:element> 
    </xsl:template>
    
</xsl:stylesheet>