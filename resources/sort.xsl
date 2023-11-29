<!--  
Copyright 2011-2018 Berlin-Brandenburg Academy of Sciences and Humanities

This file is part of ediarum.BASE.edit (https://github.com/ediarum/ediarum.BASE.edit/tree/master/resources).

ediarum.BASE.edit is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published 
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ediarum.BASE.edit is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ediarum.BASE.edit. If not, see <http://www.gnu.org/licenses/>.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0">

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:output indent="yes"/>

    <xsl:template match="tei:body/tei:listPerson">
        <xsl:copy>
            <xsl:apply-templates select="./tei:person">
                <xsl:sort
                    select=".//tei:persName[@type = 'reg']/(tei:surname | tei:name)/normalize-space()"
                    lang="de"/>
                <xsl:sort select=".//tei:persName[@type = 'reg']/tei:forename/normalize-space()"
                    lang="de"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:body/tei:listPlace">
        <xsl:copy>
            <xsl:apply-templates select="./tei:place">
                <xsl:sort select="tei:placeName[@type = 'reg']/normalize-space()" lang="de"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:body/tei:listOrg">
        <xsl:copy>
            <xsl:apply-templates select="./tei:org">
                <xsl:sort select="tei:orgName[@type = 'reg']/normalize-space()" lang="de"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:body/tei:listBibl">
            <xsl:copy>
            <xsl:copy-of select="@*"/>
                <xsl:apply-templates select="child::tei:listBibl">
                    <xsl:sort select="tei:head" lang="de"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="child::tei:bibl">
                    <xsl:sort select="tei:title[not(@type)]" lang="de"/>
                    <xsl:sort select="tei:idno[@type='inventory_shelfmark']" lang="de"/>
                </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    
    
    
    
    
    <!--<xsl:template match="tei:body/tei:listBibl/tei:listBibl">
        <xsl:copy>
            <xsl:apply-templates select="tei:bibl">
                <xsl:sort select="tei:bibl" lang="de"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>-->

    <xsl:template match="tei:body/tei:list">
        <xsl:copy>
            <xsl:apply-templates select="./tei:item">
                <xsl:sort select="tei:label[@type = 'reg']/normalize-space()" lang="de"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
