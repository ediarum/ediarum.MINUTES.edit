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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0">

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:output indent="yes"/>

    <xsl:template match="tei:title[parent::tei:titleStmt[parent::tei:fileDesc]]">
        <xsl:copy>
            <xsl:value-of select="ancestor::tei:TEI//tei:text/tei:front/tei:head[1]"></xsl:value-of>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
