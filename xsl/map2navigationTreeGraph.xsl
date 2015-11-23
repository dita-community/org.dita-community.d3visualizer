<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:df="http://dita2indesign.org/dita/functions"  
  xmlns:index-terms="http://dita4publishers.org/index-terms"
  xmlns:enum="http://dita4publishers.org/enumerables"
  xmlns:glossdata="http://dita4publishers.org/glossdata"
  xmlns:relpath="http://dita2indesign/functions/relpath"  
  xmlns:d3="http://dita4publishers.sf.net/functions/d3"
  exclude-result-prefixes="xs xd df relpath index-terms d3"
  version="2.0">
  
  <xsl:template match="/" mode="generate-navigation-tree-graph">
    
    <xsl:text>
/**
  * DITA map navigation tree graph. 
  **/
    </xsl:text>
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template mode="generate-navigation-tree-graph" match="*[df:class(., 'map/map')]">
    <xsl:variable name="mapTitle" select="df:getMapTitle(.)"/>
    <xsl:variable name="rootNodeId" as="xs:string" select="d3:getNodeId(.)"/>

    <xsl:message> + [INFO] Generating navigation tree graph...</xsl:message>

    <xsl:variable name="jsonFileURI" as="xs:string"
      select="relpath:newFile($outdir, 'data.json')"
    />    
    
    <xsl:message> + [INFO] Generating JSON data file "<xsl:value-of select="$jsonFileURI"/>"...</xsl:message>
    <xsl:result-document href="{$jsonFileURI}">
        <xsl:text>{
     "name": "</xsl:text><xsl:value-of select="$mapTitle"/><xsl:text>",&#x0a;</xsl:text>
     <xsl:text>"children": [&#x0a;</xsl:text>
        <xsl:apply-templates mode="generate-nodes"/>
        <xsl:text>
        ]
    }</xsl:text>
    </xsl:result-document>
    
    <xsl:message> + [INFO] Navigation tree graph generated.</xsl:message>
    
    
  </xsl:template>
  
  <xsl:template mode="generate-navigation-tree-graph" 
    match="text()">
    <!-- Suppress all text by default. -->
  </xsl:template>
</xsl:stylesheet>