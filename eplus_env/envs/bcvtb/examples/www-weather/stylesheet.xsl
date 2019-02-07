<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
 <xsl:for-each select="dwml/data/parameters/temperature">
<xsl:if test="@type='minimum'">
<xsl:text>
</xsl:text>
  <minimumTemperature><xsl:value-of select="value"/></minimumTemperature>
</xsl:if>
<xsl:if test="@type='maximum'">
<xsl:text>
</xsl:text>
  <maximumTemperature><xsl:value-of select="value"/></maximumTemperature>
</xsl:if>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
