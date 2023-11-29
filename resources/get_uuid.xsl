<?xml version="1.0" encoding="UTF-8"?>
<!--  
Copyright 2011-2018 Berlin-Brandenburg Academy of Sciences and Humanities

This file is part of ediarum.MINUTES.edit.

ediarum.MINUTES.edit is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published 
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ediarum.MINUTES.edit is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ediarum.BASE.edit. If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:barch="http://www.bundesarchiv.de" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uuid="java:java.util.UUID" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="xs tei uuid">
    
    <xsl:output method="xml" encoding="UTF-8" indent="no"/>
    
    <xsl:template name="UUID">
        <xsl:variable name="uidJava" select="uuid:randomUUID()"/>
        <xsl:choose>
            <xsl:when test="matches($uidJava, '^\d')">
                <xsl:call-template name="UUID"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$uidJava"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- u2y_zfq_bwb -->
    <xsl:template name="shortUUID">
        <xsl:variable name="uid" select="uuid:randomUUID()"/>
        <xsl:variable name="tokenize_uid" select="tokenize($uid, '-')"/>
        <xsl:text>K</xsl:text>
        <xsl:value-of select="substring($tokenize_uid[1], 1, 3)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring($tokenize_uid[2], 1, 3)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring($tokenize_uid[3], 1, 3)"/>
    </xsl:template>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:copy>
            <xsl:copy-of select="@* except @xml:id"/>
            <xsl:attribute name="xml:id">
                <xsl:call-template name="UUID"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>