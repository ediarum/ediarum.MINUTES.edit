<?xml version="1.0" encoding="UTF-8"?>
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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- persName -->
    
    <xsl:template match="tei:persName[not(@cert)]">
        <persName xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="cert">low</xsl:attribute>
            <xsl:attribute name="key"><xsl:value-of select="@key"/></xsl:attribute>
            <xsl:value-of select="./text()"/>            
        </persName>
    </xsl:template>
    
    <xsl:template match="tei:persName[@cert='low']">
        <persName xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="key"><xsl:value-of select="@key"/></xsl:attribute>
            <xsl:value-of select="./text()"/>            
        </persName>
    </xsl:template>
    
    <!-- placeName -->
    
    <xsl:template match="tei:placeName[not(@cert)]">
        <placeName xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="cert">low</xsl:attribute>
            <xsl:attribute name="key"><xsl:value-of select="@key"/></xsl:attribute>
            <xsl:value-of select="./text()"/>            
        </placeName>
    </xsl:template>
    
    <xsl:template match="tei:placeName[@cert='low']">
        <placeName xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="key"><xsl:value-of select="@key"/></xsl:attribute>
            <xsl:value-of select="./text()"/>            
        </placeName>
    </xsl:template>
    
</xsl:stylesheet>