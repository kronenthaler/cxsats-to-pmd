<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" encoding="utf-8"/>

    <xsl:template match="/">
        <pmd version="checkmarx-{//@CheckmarxVersion}">
            <xsl:apply-templates select="/CxXMLResults/Query"/>
        </pmd>
    </xsl:template>

    <xsl:template match="Query">
        <xsl:variable name="violation">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="@name"/>
                <xsl:with-param name="replace" select="'_'" />
                <xsl:with-param name="by" select="' '" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ruleset">
            <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="@group"/>
                <xsl:with-param name="replace" select="'_'" />
                <xsl:with-param name="by" select="' '" />
            </xsl:call-template>
        </xsl:variable>

        <xsl:for-each select="Result">
            <file name=".{@FileName}">
                <violation begincolumn="{@Column}"
                           endcolumn="{@Column + string-length(Path/PathNode/Name) }"
                           beginline="{@Line}"
                           endline="{@Line + Path/PathNode/Length - 1}"
                           priority="{5 - @SeverityIndex}"
                           rule="{$violation}"
                           ruleset="{$ruleset}">
                    <xsl:value-of select="Path/PathNode/Name"/>
                </violation>
            </file>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="string-replace-all">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="by" />
        <xsl:choose>
            <xsl:when test="contains($text, $replace)">
                <xsl:value-of select="substring-before($text,$replace)" />
                <xsl:value-of select="$by" />
                <xsl:call-template name="string-replace-all">
                    <xsl:with-param name="text" select="substring-after($text,$replace)" />
                    <xsl:with-param name="replace" select="$replace" />
                    <xsl:with-param name="by" select="$by" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>