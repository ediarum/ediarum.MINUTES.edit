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
<!DOCTYPE stylesheet [
<!ENTITY nbsp  "&#160;" >
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:telota="http://www.telota.de"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:strip-space elements="*"/>
    
    <xsl:output method="html"/>
    <xsl:variable name="heute" select="fn:current-date()"/>
    <xsl:variable name="uhrzeit" select="fn:current-time()"/>
    <!--<xsl:template match="root">
        <html>
            <head>
                <meta name="author" content="Nadine Arndt"/>
                <meta name="description">
                    <xsl:attribute name="content">
                        PDF-Vorschau vom <xsl:value-of select="format-date($heute,'[D01].[M01].[Y0001]')"/>, <xsl:value-of select="format-time($uhrzeit,'[H01]:[m01]')"/>
                    </xsl:attribute>
                </meta>
                <title>Tranchenbesprechung</title>
            </head>
            <body xml:lang="de">
                <!-\-<div>
                    <ul class="toc">
                        <xsl:for-each select="tei:TEI">
                            <li>
                                <a href="#{@xml:id}" class="toc_link">
                                    <xsl:value-of select="./tei:teiHeader//tei:title"/></a>
                                <p>
                                    <xsl:for-each select=".//tei:div[@type='agenda_item']">
                                        <xsl:value-of select="./tei:head" separator=", "/>
                                    </xsl:for-each>
                                </p>
                            </li>
                        </xsl:for-each>
                    </ul>
                </div>-\->
                <xsl:for-each select="tei:TEI">
                    <p class="heading"><xsl:value-of select="./tei:teiHeader//tei:title"/></p>
                    <div class="minute" id="{@xml:id}">
                        <xsl:apply-templates select="."/>
                    </div>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>-->
    
    <!-- Für Transformation einer Einzeldatei notwendig -->
    <xsl:template match="tei:TEI">
<!--        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>-->
        <html>
            <head>
                <meta name="author" content="Nadine Arndt"/>
                <meta name="description">
                    <xsl:attribute name="content">
                        <xsl:text>PDF-Vorschau vom </xsl:text><xsl:value-of select="format-date($heute,'[D01].[M01].[Y0001]')"/>, <xsl:value-of select="format-time($uhrzeit,'[H01]:[m01]')"/>
                    </xsl:attribute>
                </meta>
                <title><xsl:value-of select="./tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></title>
            </head>
            <body>
                <div>
                    <xsl:attribute name="class"><xsl:value-of select="//tei:text/@type"/></xsl:attribute>
                    <p class="heading"><xsl:value-of select="./tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></p>
                    <xsl:apply-templates select="./tei:text"/>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- # Dokumentenkopf -->
    
    <!-- ## Titel des Protokolls -->
    <xsl:template match="tei:title">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <h1><xsl:apply-templates/></h1>
    </xsl:template>
    
    <!-- ## Teilnehmer -->
    <xsl:template match="tei:div[@type='list_participants']">
        <xsl:variable name="counter_person" select="count(./tei:listPerson/tei:person)"/>
        <xsl:variable name="counter_recorder" select="count(./tei:listPerson/tei:person[@role='recorder'])"/>
        <br></br>
        <div class="doc_head">
            <p>Teilnehmer:  
                <xsl:for-each select="./tei:listPerson/tei:person">
                    <xsl:choose>
                        <xsl:when test="@role='recorder'">
                            <!-- nur einmal "Protokoll: " auswerfen, wenn mehr als ein Protokollant -->
                            <xsl:choose>
                                <xsl:when test="$counter_recorder&gt;1">
                                    Protokoll: <xsl:for-each select=".">
                                        <xsl:apply-templates select="./tei:persName/fn:normalize-space()"/>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    Protokoll: <xsl:apply-templates select="./tei:persName/fn:normalize-space()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./tei:persName/fn:normalize-space()" separator=", "/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="./tei:note">
                            (<xsl:apply-templates select="./tei:note/fn:normalize-space()"/>)
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="position()!=last()">, </xsl:when>
                        <xsl:otherwise>.</xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </p>
            <br></br>
            <!-- ###Start, Ende, Ort wird bei aktuellen Protokollen aus div @type="creation" ausgelesen, bei älteren aus tei:creation### -->
            <xsl:choose>
                <xsl:when test="following-sibling::tei:div[@type='creation']">
                    <xsl:variable name="time_start" select="tokenize(following-sibling::tei:div[@type='creation']/tei:dateline[@n='type:start']/tei:time[@type='start']/@when, ':')"/>
                    <xsl:variable name="time_end" select="tokenize(following-sibling::tei:div[@type='creation']/tei:dateline[@n='type:end']/tei:time[@type='end']/@when, ':')"/>
                    <table class="creation">
                        <tr class="row"> 
                            <td class="start">Beginn: <xsl:value-of select="$time_start[1]"/>.<xsl:value-of select="$time_start[2]"/> Uhr</td> 
                            <!-- @tsyle bei @class=end muss hier angegeben werden, da die Rechtsbündigkeit über das CSS nicht richtig ausgeführt wird -->
                            <td class="end" style="text-align:right">Ende: <xsl:value-of select="$time_end[1]"/>.<xsl:value-of select="$time_end[2]"/> Uhr</td> 
                        </tr>
                        <tr class="row">
                            <td colspan="2">Ort: <xsl:value-of select="following-sibling::tei:div[@type='creation']/tei:dateline[@n='type:place']/tei:placeName"/></td>
                        </tr>
                    </table>
                </xsl:when>
                <xsl:when test="parent::tei:front/parent::tei:text/preceding-sibling::tei:teiHeader/tei:profileDesc/tei:creation">
                    <xsl:variable name="time_start" select="tokenize(parent::tei:front/parent::tei:text/preceding-sibling::tei:teiHeader/tei:profileDesc/tei:creation/tei:date/tei:time[@type='start']/@when, ':')"/>
                    <xsl:variable name="time_end" select="tokenize(parent::tei:front/parent::tei:text/preceding-sibling::tei:teiHeader/tei:profileDesc/tei:creation/tei:date/tei:time[@type='end']/@when, ':')"/>
                    <table class="creation">
                        <tr class="row"> 
                            <td class="start">Beginn: <xsl:value-of select="$time_start[1]"/>.<xsl:value-of select="$time_start[2]"/> Uhr</td> 
                            <!-- @tsyle bei @class=end muss hier angegeben werden, da die Rechtsbündigkeit über das CSS nicht richtig ausgeführt wird -->
                            <td class="end" style="text-align:right">Ende: <xsl:value-of select="$time_end[1]"/>.<xsl:value-of select="$time_end[2]"/> Uhr</td> 
                        </tr>
                        <tr class="row">
                            <td colspan="2">Ort: <xsl:value-of select="parent::tei:front/parent::tei:text/preceding-sibling::tei:teiHeader/tei:profileDesc/tei:creation/tei:placeName"/></td>
                        </tr>
                    </table>                    
                </xsl:when>
            </xsl:choose>
         </div>
    </xsl:template>
    
    <!-- ### keine Verarbeitung notwendig -->
    <xsl:template match="tei:respStmt"/>
    <xsl:template match="tei:editor"/>
    <xsl:template match="tei:publicationStmt"/>
    <xsl:template match="tei:sourceDesc"/>
    <xsl:template match="tei:creation"/>
    <xsl:template match="tei:editionStmt"/>
    <xsl:template match="tei:publicationStmt"/>
    <xsl:template match="tei:notesStmt"/>
    <xsl:template match="tei:revisionDesc"/>
    
    
    <!-- ### Agenda### -->
    
    <xsl:template match="tei:list[@type='agenda']">
        <br></br>
        <div class="agenda"><p>
            <xsl:if test="@subtype='ordinary'">Tagesordnung</xsl:if>
            <xsl:if test="@subtype='extraordinary'">Außerhalb der Tagesordnung</xsl:if>:</p>
            
            <table class="agenda">
                <xsl:for-each select="tei:item">
                    <tr>
                        <!--<td class="agenda_item_label">
                            <xsl:value-of select="tei:ref/tei:label"/>                        
                        </td>-->
                        <td class="agenda_item">
                            <xsl:choose>
                                <xsl:when test="tei:list[@subtype='sub_item']">
                                    <!-- Problem, wenn kommentiert wurde -->
                                    <!--<xsl:if test="tei:ref/text()">
                                        <xsl:apply-templates select="tei:ref"/>
                                    </xsl:if>-->
                                    <xsl:apply-templates select="tei:ref"/>
                                    <xsl:for-each select="tei:list[@subtype='sub_item']/tei:item">
                                        <p>
                                            <xsl:apply-templates select="tei:ref"/>
                                            
                                            <xsl:if test="tei:bibl">
                                                <xsl:for-each select="tei:bibl">
                                                    <br></br><xsl:value-of select="."/>
                                                </xsl:for-each>
                                                
                                            </xsl:if>  
                                        </p>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="tei:ref"/>
                                </xsl:otherwise>
                            </xsl:choose>
                                <xsl:if test="tei:bibl">
                                    <xsl:for-each select="tei:bibl">
                                        <br></br><xsl:value-of select="."/>
                                    </xsl:for-each>
                                </xsl:if>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
            <xsl:choose>
                <xsl:when test="following-sibling::tei:list[@subtype='extraordinary']">
                    <br></br>
                </xsl:when>
                <xsl:otherwise>
                    <br></br><br></br>
                </xsl:otherwise>
            </xsl:choose>
                <br></br>    
        </div>
    </xsl:template>
    
    
    
    <!-- ### TOP -->
    <xsl:template match="tei:div[@type='agenda_item' and not(@subtype='extraordinary_added')]">
        <br></br>
        <div class="top" id="{@xml:id}">
            <xsl:choose>
                <!-- ### U-TOP mit eigenem Abschnitt### -->
                <xsl:when test="descendant::tei:div[@type='agenda_sub_item']">
                    
                    <!-- if-Abfrage genauer anschauen, wegen 106/6 & der Erstellung von zwei h4 bei 
                            Bsp. IST    3. 
                                        Überschrift
                            Bsp. Soll   3. Überschrift
                        -->
                        <xsl:if test="./tei:head[1]/text()">
                            <h2>
                                <xsl:choose>
                                    <xsl:when test="./tei:head[1][@type='added' and @resp='editorial']">
                                        [<xsl:apply-templates select="./tei:head/node()"/>]
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="./tei:head[1]/node()"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </h2></xsl:if>
                        <xsl:if test="./tei:head[2]/tei:list[@type='agenda_sub_item']">
                            <h3><ul class="list">
                                <xsl:for-each select="./tei:head[2]/tei:list[@type='agenda_sub_item']/tei:item">
                                    <li>
                                        <xsl:value-of select="."/>
                                    </li>
                                </xsl:for-each>
                            </ul></h3>
                        </xsl:if>
                    
                    <xsl:if test="tei:note[@type='more_info']">
                        <xsl:value-of select="tei:note[@type='more_info']"/>
                    </xsl:if>
                    <xsl:for-each select="descendant::tei:div[@type='agenda_sub_item']">
                        <xsl:choose>
                            <xsl:when test="./tei:note[@type='ressort']">
                                <h2>
                                    <xsl:call-template name="head"/>
                                </h2>
                                <p class="ressort"><xsl:value-of select="./tei:note[@type='ressort']/node()" separator=", "/></p>
                            </xsl:when>
                            <xsl:otherwise>
                                <h2>
                                    <xsl:call-template name="head"/>
                                </h2>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="./tei:dateline">
                                <xsl:variable name="tokenTime" select="tokenize(./tei:dateline/tei:time/@when, ':')"/>
                                <xsl:variable name="countTime" select="count(./tei:dateline//tei:time)"/>
                                <p class="time">(<xsl:choose>
                                    <!-- generaler umsetzen -->
                                    <xsl:when test="$countTime!=1">
                                        <xsl:value-of select="tokenize(descendant::tei:div[@type='agenda_sub_item']/tei:dateline/tei:time[1]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(descendant::tei:div[@type='agenda_sub_item']/tei:dateline/tei:time[1]/@when, ':')[2]"/> Uhr <xsl:value-of select="descendant::tei:div[@type='agenda_sub_item']/tei:dateline"/> <xsl:value-of select="tokenize(descendant::tei:div[@type='agenda_sub_item']/tei:dateline/tei:time[2]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(descendant::tei:div[@type='agenda_sub_item']/tei:dateline/tei:time[2]/@when, ':')[2]"/>
                                    </xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$tokenTime[1]"/>.<xsl:value-of select="$tokenTime[2]"/> 
                                    </xsl:otherwise>
                                </xsl:choose> Uhr)</p>
                            </xsl:when>
                        </xsl:choose>
                        <!-- get TOP-Text -->
                        <xsl:apply-templates/>
                    </xsl:for-each>
                </xsl:when>
                
                <!-- ### U-TOP als Liste (vorangestellt) -->
                <xsl:when test="descendant::tei:list[@type='agenda_sub_item']">
                    <h2><xsl:value-of select="tei:head[1]"/></h2>
                    <xsl:for-each select="descendant::tei:list[@type='agenda_sub_item']/tei:item">
                        <xsl:choose>
                            <xsl:when test="./tei:note[@type='ressort']">
                                <h3>
                                    <xsl:apply-templates select="."/>
                                </h3>
                                <p class="ressort"><xsl:value-of select="./tei:note[@type='ressort']/node()" separator=", "/></p>
                            </xsl:when>
                            <xsl:otherwise>
                                <h3>
                                    <xsl:apply-templates select="."/>
                                </h3>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="./tei:dateline">
                                <xsl:variable name="tokenTime" select="tokenize(./tei:dateline/tei:time/@when, ':')"/>
                                <xsl:variable name="countTime" select="count(./tei:dateline//tei:time)"/>
                                <p class="time">(<xsl:choose>
                                    <!-- generaler umsetzen -->
                                    <xsl:when test="$countTime!=1">
                                        <xsl:value-of select="tokenize(descendant::tei:div[@type='agenda_sub_item']/tei:dateline/tei:time[1]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(descendant::tei:div[@type='agenda_sub_item']/tei:dateline/tei:time[1]/@when, ':')[2]"/> Uhr <xsl:value-of select="descendant::tei:div[@type='agenda_sub_item']/tei:dateline"/> <xsl:value-of select="tokenize(descendant::tei:div[@type='agenda_sub_item']/tei:dateline/tei:time[2]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(descendant::tei:div[@type='agenda_sub_item']/tei:dateline/tei:time[2]/@when, ':')[2]"/>
                                    </xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$tokenTime[1]"/>.<xsl:value-of select="$tokenTime[2]"/> 
                                    </xsl:otherwise>
                                </xsl:choose> Uhr)</p>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <!-- get TOP-Text -->
                    <xsl:apply-templates/>
                </xsl:when>
                
                <!-- ### TOP mit subtype="combined" -->
                <xsl:when test=".[@subtype='combined']">
                    <xsl:for-each select="./tei:head">
                        <h2>
                            <xsl:value-of select="."/>
                        </h2> 
                    </xsl:for-each>
                    <xsl:if test="./tei:note[@type='ressort']">
                        <p class="ressort"><xsl:value-of select="./tei:note[@type='ressort']/node()" separator=", "/></p>    
                    </xsl:if>
                    <xsl:if test="./tei:dateline">
                        <xsl:variable name="tokenTime" select="tokenize(./tei:dateline/tei:time/@when, ':')"/>
                        <xsl:variable name="countTime" select="count(./tei:dateline/tei:time)"/>
                        <p class="time">(<xsl:choose>
                            <!-- generaler umsetzen -->
                            <xsl:when test="$countTime!=1">
                                <xsl:value-of select="tokenize(./tei:dateline/tei:time[1]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(./tei:dateline/tei:time[1]/@when, ':')[2]"/> Uhr <xsl:value-of select="./tei:dateline"/> <xsl:value-of select="tokenize(./tei:dateline/tei:time[2]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(./tei:dateline/tei:time[2]/@when, ':')[2]"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="$tokenTime[1]"/>.<xsl:value-of select="$tokenTime[2]"/></xsl:otherwise>
                        </xsl:choose> Uhr)</p>
                    </xsl:if>
                    <!-- get TOP-Text -->
                    <xsl:apply-templates/>
                </xsl:when>
                
                <!-- ### Standard-TOP -->
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="./tei:note[@type='ressort']">
                            <h2>
                                <xsl:call-template name="head"/>
                            </h2>
                            <p class="ressort"><xsl:value-of select="./tei:note[@type='ressort']/node()" separator=", "/></p>
                        </xsl:when>
                        <xsl:otherwise>
                            <h2>
                                <xsl:call-template name="head"/>
                            </h2>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:if test="./tei:dateline">
                        <xsl:variable name="tokenTime" select="tokenize(./tei:dateline/tei:time/@when, ':')"/>
                        <xsl:variable name="countTime" select="count(./tei:dateline/tei:time)"/>
                        <p class="time">(<xsl:choose>
                            <!-- generaler umsetzen -->
                            <xsl:when test="$countTime!=1">
                                <xsl:value-of select="tokenize(./tei:dateline/tei:time[1]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(./tei:dateline/tei:time[1]/@when, ':')[2]"/> Uhr <xsl:value-of select="./tei:dateline"/> <xsl:value-of select="tokenize(./tei:dateline/tei:time[2]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(./tei:dateline/tei:time[2]/@when, ':')[2]"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="$tokenTime[1]"/>.<xsl:value-of select="$tokenTime[2]"/></xsl:otherwise>
                        </xsl:choose> Uhr)</p>
                    </xsl:if>
                    <!-- get TOP-Text -->
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <!-- Überschriften -->
    <xsl:template name="head">
        <xsl:choose>
            <xsl:when test="./tei:head[@type='added' and @resp='editorial']">
                <xsl:text>[</xsl:text><xsl:apply-templates select="./tei:head[@type='added' and @resp='editorial']/node()"/><xsl:text>]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="./tei:head/node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- ergänzter TOP -->
    <xsl:template match="tei:div[@type='agenda_item' and @subtype='extraordinary_added']">
        <br></br>
        <div class="top_added" id="{@xml:id}">
                <!-- ### Standard-TOP -->
                    <xsl:choose>
                        <xsl:when test="./tei:note[@type='ressort']">
                            <h2 class="added"><xsl:apply-templates select="./tei:head/node()"/></h2>
                            <p class="ressort"><xsl:value-of select="./tei:note[@type='ressort']/node()" separator=", "/></p>
                        </xsl:when>
                        <xsl:otherwise>
                            <h2 class="added"><xsl:apply-templates select="./tei:head/node()"/></h2>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                    <xsl:if test="./tei:dateline">
                        <xsl:variable name="tokenTime" select="tokenize(./tei:dateline/tei:time/@when, ':')"/>
                        <xsl:variable name="countTime" select="count(./tei:dateline/tei:time)"/>
                        <p class="time">(<xsl:choose>
                            <!-- generaler umsetzen -->
                            <xsl:when test="$countTime!=1">
                                <xsl:value-of select="tokenize(./tei:dateline/tei:time[1]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(./tei:dateline/tei:time[1]/@when, ':')[2]"/> Uhr <xsl:value-of select="./tei:dateline"/> <xsl:value-of select="tokenize(./tei:dateline/tei:time[2]/@when, ':')[1]"/>:<xsl:value-of select="tokenize(./tei:dateline/tei:time[2]/@when, ':')[2]"/>
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="$tokenTime[1]"/>.<xsl:value-of select="$tokenTime[2]"/></xsl:otherwise>
                        </xsl:choose> Uhr)</p>
                    </xsl:if>
                    <!-- get TOP-Text -->
                    <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    
    <xsl:template match="tei:note[@type='more_info']">
        <p class="more_info"><xsl:apply-templates/></p>
    </xsl:template>
    
    <!-- ### keine Verarbeitung notwendig -->
    <xsl:template match="tei:head[parent::tei:div]"/>
    <xsl:template match="tei:dateline"/>
    <xsl:template match="tei:note[@type='ressort']"/>
    <xsl:template match="tei:text//tei:num"/>
    <xsl:template match="tei:anchor"/>
    <xsl:template match="tei:index"/>
    
    
    <!-- ###weitere Textstrukturen### -->
    <xsl:template match="tei:p">
        <xsl:choose>
            <!-- editorische ergänzte Absätze -->
            <xsl:when test="parent::tei:note[@type='editorial_addition']">
                <p><xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text></p>
            </xsl:when>
            <xsl:when test="parent::tei:item">
                <xsl:text> </xsl:text><xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p><xsl:apply-templates/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <br></br>
    </xsl:template>
    <xsl:template match="tei:lb[@type='editorial']">
        <br></br>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <!-- @rendition
        sort = nummeriert -> <label><num>1)</num></label>
        hyphen = Spiegelstrich
        bulleted = Aufzählpunkte
        none = keine Zeichen
        -->
        <ul class="list">
            <xsl:for-each select="tei:item">
                <xsl:if test="parent::tei:list[@rendition='sort']">
                    <li><xsl:attribute name="content"><xsl:value-of select="tei:label"/></xsl:attribute>
                        <xsl:apply-templates select="node()"/>
                    </li>
                </xsl:if>
                <xsl:if test="parent::tei:list[@rendition='hyphen']">
                    <li>
                        <xsl:attribute name="content">&#x2013;</xsl:attribute>
                        <xsl:apply-templates/></li><!-- style="list-style-type:'— '" oder – -->
                </xsl:if>
                <xsl:if test="parent::tei:list[@rendition='bulleted']">
                    <li>
                        <xsl:attribute name="content">&#x2022;</xsl:attribute>
                        <xsl:apply-templates/>
                    </li>
                </xsl:if>
                <xsl:if test="parent::tei:list[@rendition='none']">
                    <li class="none">
                        <xsl:apply-templates/>
                    </li>
                </xsl:if>                
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:table">
        <table class="table"><xsl:apply-templates/></table>
    </xsl:template>
    
    <xsl:template match="tei:row">
        <tr><xsl:apply-templates/></tr>
    </xsl:template>
    
    <xsl:template match="tei:cell">
        <td valign="top"><xsl:apply-templates/></td>
    </xsl:template>
    
    <xsl:template match="tei:ref[ancestor::tei:list[@type='agenda']]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:label">
        <xsl:apply-templates/><xsl:text> </xsl:text>
    </xsl:template>
    
    
    <!-- Umlaufverfahren = Sonderfall einer Liste -->
    <!-- @NA: Klammern schöner einsetzen -->
    
    <xsl:template match="tei:div[@type='circulation_procedure']">
        <xsl:variable name="counter_ref" select="count(./tei:list/tei:item)"/>
        <div class="circulation_procedure">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    
    
    <xsl:template match="tei:div[@type='circulation_procedure']/tei:list">
        <xsl:variable name="counter_ref" select="count(./tei:list/tei:item)"/>
        <!--<xsl:if test="tei:p">[<xsl:apply-templates select="tei:p"></xsl:apply-templates></xsl:if>-->
        <ul class="list">
            <xsl:for-each select="tei:item">
                <li>
                    <xsl:attribute name="content">&#x2013;</xsl:attribute>
                    <xsl:for-each select="./tei:ref">
                        <xsl:apply-templates select="."/><br></br>
                    </xsl:for-each>
                    
                    <xsl:if test="./tei:bibl[@type='template']"><xsl:apply-templates select="./tei:bibl[@type='template']"/></xsl:if>
                    <xsl:if test="./tei:bibl[@type='fact_sheet']"><br></br><xsl:apply-templates select="./tei:bibl[@type='fact_sheet']"/></xsl:if>
                    <xsl:if test="./tei:bibl[@type='template']"><xsl:text> – </xsl:text><xsl:apply-templates select="./tei:bibl[@type='template']"/></xsl:if>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='attachement']">
        <div class="attachement">[<xsl:apply-templates/>]</div>
    </xsl:template>
    
    <!-- ### editorische Ergänzung: Wörter, Zeichen -->
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
    </xsl:template>
    
    <!-- ### Kommentare > Fußnoten -->
    <xsl:template match="tei:note[@type='comment']">
        <span class="footnote">
            <b><xsl:choose>
                <xsl:when test="@ana">
                        <xsl:if test="@ana='status:draft'">Entwurf<xsl:text> </xsl:text></xsl:if>
                        <xsl:if test="@ana='status:progress'">in Bearbeitung<xsl:text> </xsl:text></xsl:if>
                        <xsl:if test="@ana='status:discussion'">besprechungsreif<xsl:text> </xsl:text></xsl:if>
                        <xsl:if test="@ana='status:final'">final<xsl:text> </xsl:text></xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="parent::tei:p[@ana]">
                            <xsl:if test="parent::tei:p/@ana='status:draft'">Entwurf<xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="parent::tei:p/@ana='status:progress'">in Bearbeitung<xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="parent::tei:p/@ana='status:discussion'">besprechungsreif<xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="parent::tei:p/@ana='status:final'">final<xsl:text> </xsl:text></xsl:if>
                        </xsl:when>
                        <xsl:when test="parent::tei:item[@ana]">
                            <xsl:if test="parent::tei:item/@ana='status:draft'">Entwurf<xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="parent::tei:item/@ana='status:progress'">in Bearbeitung<xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="parent::tei:item/@ana='status:discussion'">besprechungsreif<xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="parent::tei:item/@ana='status:final'">final<xsl:text> </xsl:text></xsl:if>
                        </xsl:when>
                        <xsl:when test="ancestor::tei:list[@ana]">
                            <xsl:if test="ancestor::tei:list/@ana='status:draft'">Entwurf<xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="ancestor::tei:list/@ana='status:progress'">in Bearbeitung<xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="ancestor::tei:list/@ana='status:discussion'">besprechungsreif<xsl:text> </xsl:text></xsl:if>
                            <xsl:if test="ancestor::tei:list/@ana='status:final'">final<xsl:text> </xsl:text></xsl:if>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="ancestor::tei:div[@type='agenda_sub_item'][@ana]">
                                    <xsl:if test="ancestor::tei:div[@type='agenda_sub_item']/@ana='status:draft'">Entwurf<xsl:text> </xsl:text></xsl:if>
                                    <xsl:if test="ancestor::tei:div[@type='agenda_sub_item']/@ana='status:progress'">in Bearbeitung<xsl:text> </xsl:text></xsl:if>
                                    <xsl:if test="ancestor::tei:div[@type='agenda_sub_item']/@ana='status:discussion'">besprechungsreif<xsl:text> </xsl:text></xsl:if>
                                    <xsl:if test="ancestor::tei:div[@type='agenda_sub_item']/@ana='status:final'">final<xsl:text> </xsl:text></xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="ancestor::tei:div[@type='agenda_item']/@ana='status:draft'">Entwurf<xsl:text> </xsl:text></xsl:if>
                                    <xsl:if test="ancestor::tei:div[@type='agenda_item']/@ana='status:progress'">in Bearbeitung<xsl:text> </xsl:text></xsl:if>
                                    <xsl:if test="ancestor::tei:div[@type='agenda_item']/@ana='status:discussion'">besprechungsreif<xsl:text> </xsl:text></xsl:if>
                                    <xsl:if test="ancestor::tei:div[@type='agenda_item']/@ana='status:final'">final<xsl:text> </xsl:text></xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose></b>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Entitäten -->
    <xsl:template match="tei:persName">
        <xsl:choose>
            <xsl:when test="@role='speaker'">
                <i><xsl:apply-templates/></i>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:rs[@type='person']">
        <xsl:choose>
            <xsl:when test="@role='speaker'">
                <i><xsl:apply-templates/></i>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- geschütztes Leerzeichen
    <g ref="non-breaking-space"/>
    -->
    <xsl:template match="tei:g[@ref='non-breaking-space']">
        <span class="non-breaking-space">&nbsp;</span>
    </xsl:template>
    
</xsl:stylesheet>