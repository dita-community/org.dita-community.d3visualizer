<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:d3="http://dita4publishers.sf.net/functions/d3"
  exclude-result-prefixes="xs xd"
  version="2.0">
  
  <xsl:function name="d3:makeProperty" as="xs:string">
    <xsl:param name="propName" as="xs:string"/>
    <xsl:param name="value"/>
    <xsl:sequence 
      select="
      if ($value != '')
         then concat($propName, '=', d3:quoteString(string-join($value, '')), ',')
         else ''"/>
    
  </xsl:function>
  
  <xsl:function name="d3:getNodeId" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:sequence 
      select="d3:quoteString(
      concat('node_', 
             local-name($context), 
             '_', 
             generate-id($context)))"
    /> 
    
  </xsl:function>

  <xsl:function name="d3:quoteString" as="xs:string">
    <xsl:param name="inString" as="xs:string?"/>
    <xsl:variable name="escapedQuote" select='concat("\\", """")' as="xs:string"/>
    <xsl:variable name="result1" as="xs:string"
      select='
      if ($inString) 
         then concat("""", replace($inString, """", $escapedQuote), """") 
         else ""'
    />
    <xsl:variable name="result2" as="xs:string"
      select="replace($result1, '&lt;', '&amp;lt;')"
    />
    <xsl:variable name="result3" as="xs:string"
      select="replace($result2, '&gt;', '&amp;gt;')"
    />
    <xsl:sequence select="normalize-space($result3)"/>
  </xsl:function>
    
  <xsl:function name="d3:makeNodeDecl" as="xs:string*">
    <xsl:param name="nodeId" as="xs:string"/>
    <xsl:param name="label"/>
    <xsl:param name="properties" as="xs:string*"/>
 
 
<xsl:if test="false()">    
  <xsl:message> + [DEBUG] makeNodeDecl(): label="<xsl:sequence select="$label"/>"</xsl:message>
</xsl:if>    
    <!-- properties parameter must be either an empty sequence or
         have an even number of items.
    -->
    <xsl:if test="count($properties) gt 0 and count($properties) mod 2 != 0">
      <xsl:message terminate="yes"> - [ERROR] d3:makeNodeDecl(): Got an odd number of values in the 'properties' parameter.
      The value must be a sequence of name/value pair, e.g., ('color', 'blue', 'label', 'The label')</xsl:message>
    </xsl:if>
    
    <xsl:sequence select="d3:quoteString($nodeId)"/> 
    <xsl:text>[
    </xsl:text>
    <xsl:sequence select="d3:makeProperties(('label', $label, $properties))"/>
    <xsl:text>
      ]
    </xsl:text>
    
  </xsl:function>
  
  <xsl:function name="d3:makeProperties">
    <xsl:param name="properties" as="xs:string*"/>

    <xsl:if test="count($properties) gt 0 and count($properties) mod 2 != 0">
      <xsl:message terminate="yes"> - [ERROR] d3:makeProperties(): Got an odd number of values in the 'properties' parameter.
        The value must be a sequence of name/value pair, e.g., ('color', 'blue', 'label', 'The label')</xsl:message>
    </xsl:if>

    <xsl:for-each select="$properties">
      <xsl:variable name="pos" select="position()" as="xs:integer"/>
      <xsl:if test="position() mod 2 != 0">
        <xsl:sequence 
          select="d3:makeProperty($properties[$pos], 
          $properties[$pos + 1])"/>
        <xsl:text>&#x0a;</xsl:text>
      </xsl:if>
    </xsl:for-each>    
    
  </xsl:function>
  
</xsl:stylesheet>