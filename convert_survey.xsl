<xsl:stylesheet 
    version="1.0"
    xmlns:i18n="http://xml.zope.org/namespaces/i18n"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output encoding="UTF-8" method="xml" indent="yes" />
  
  <xsl:template match="questionnaire">
    <xsl:element name="survey">

      <xsl:element name="data">
        <xsl:for-each select="//item">
          <xsl:element name="var">
            <xsl:attribute name="name"><xsl:value-of select="./@id" /></xsl:attribute>
            <xsl:value-of select="./@default" />
          </xsl:element>
        </xsl:for-each>
      </xsl:element>

      <xsl:element name="model">
        <xsl:for-each select="//item">
          <xsl:if test="./@relevant != '' or ./@readonly != '' or ./@required != '' or ./@constraint != '' or ./@calculate != '' or ./@datatype != ''">
            <xsl:element name="properties">
              <xsl:attribute name="id">props_<xsl:value-of select="./@id" /></xsl:attribute>
              <xsl:element name="bind">
                <xsl:value-of select="./@id" />
              </xsl:element>
              <xsl:if test="./@relevant != ''">
                <xsl:element name="relevant">
                  <xsl:value-of select="./@relevant" />
                </xsl:element>
              </xsl:if>
              <xsl:if test="./@required != ''">
                <xsl:element name="required">
                  <xsl:value-of select="./@required" />
                </xsl:element>
              </xsl:if>
              <xsl:if test="./@readonly != ''">
                <xsl:element name="readonly">
                  <xsl:value-of select="./@readonly" />
                </xsl:element>
              </xsl:if>
              <xsl:if test="./@calculate != ''">
                <xsl:element name="calculate">
                  <xsl:value-of select="./@calculate" />
                </xsl:element>
              </xsl:if>
              <xsl:if test="./@constraint != ''">
                <xsl:element name="constraint">
                  <xsl:value-of select="./@constraint" />
                </xsl:element>
              </xsl:if>
              <xsl:if test="./@datatype != ''">
                <xsl:element name="datatype">
                  <xsl:value-of select="./@datatype" />
                </xsl:element>
              </xsl:if>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
      </xsl:element>

      <xsl:element name="layout">

        <xsl:for-each select="//section">
          <xsl:apply-templates select="itemgroup" />
        </xsl:for-each>

      </xsl:element>

    </xsl:element>

  </xsl:template>


  <xsl:template match="itemgroup">

    <xsl:element name="group">
      <xsl:copy-of select="@id" />
      <xsl:if test="@layout">
        <xsl:copy-of select="@layout" />
      </xsl:if>
      <xsl:if test="not(@layout)">
        <xsl:attribute name="layout">flow</xsl:attribute>
      </xsl:if>
      <xsl:if test="@label != ''">
        <xsl:element name="label">
          <xsl:value-of select="@label" />
        </xsl:element>
      </xsl:if>
      <xsl:if test="@hint != ''">
        <xsl:element name="hint">
          <xsl:value-of select="@hint" />
        </xsl:element>
      </xsl:if>
      <xsl:apply-templates select="itemgroup" />
      <xsl:apply-templates select="item" />
    </xsl:element>

  </xsl:template>

  <xsl:template match="item">
    <xsl:choose>
      <xsl:when test="./@type = 'Select' and not(./@wisapi)">
        <xsl:element name="select">
          <xsl:call-template name="widget-attrs" />
          <xsl:call-template name="widget" />
          <xsl:for-each select="./option">
            <xsl:element name="option">
              <xsl:copy-of select="@value" />
              <xsl:element name="label">
                <xsl:attribute name="i18n:trans"></xsl:attribute>
                <xsl:value-of select="./@label" />
              </xsl:element>
              <xsl:if test="./@hint != ''">
                <xsl:element name="hint">
                  <xsl:attribute name="i18n:trans"></xsl:attribute>
                  <xsl:value-of select="./@hint" />
                </xsl:element>
              </xsl:if>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:when test="./@type = 'Select' and ./@wisapi">
        <xsl:element name="control">
          <xsl:call-template name="widget-attrs" />
          <xsl:call-template name="widget" />
        </xsl:element>
      </xsl:when>
      <xsl:when test="./@type = 'Hidden'">
        <xsl:element name="hidden">
          <xsl:call-template name="widget-attrs" />
        </xsl:element>
      </xsl:when>
      <xsl:when test="./@type = 'TextArea'">
        <xsl:element name="textarea">
          <xsl:call-template name="widget-attrs" />
          <xsl:element name="property">
            <xsl:attribute name="name">rows</xsl:attribute>
            <xsl:value-of select="./@rows" />
          </xsl:element>
          <xsl:element name="property">
            <xsl:attribute name="name">cols</xsl:attribute>
            <xsl:value-of select="./@cols" />
          </xsl:element>
          <xsl:call-template name="widget" />
        </xsl:element>
      </xsl:when>
      <xsl:when test="./@type = 'Matrix'">
      </xsl:when>
      <xsl:when test="./@type = 'MatrixItem'">
      </xsl:when>
      <xsl:when test="./@type = 'Output'">
        <xsl:element name="text">
          <xsl:attribute name="id">
            <xsl:value-of select="./@id" />
          </xsl:attribute>
          <xsl:value-of select="./@label" />
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="input">
          <xsl:call-template name="widget-attrs" />
          <xsl:call-template name="widget" />
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <!-- base template for most widgets -->
  <xsl:template name="widget-attrs">
    <xsl:copy-of select="./@id" />
    <xsl:attribute name="bind">
      <xsl:value-of select="./@id" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="widget">
    <xsl:for-each select="./property">
      <xsl:element name="property">
        <xsl:attribute name="name">
          <xsl:value-of select="./@name" />
        </xsl:attribute>
        <xsl:value-of select="./@value" />
      </xsl:element>
    </xsl:for-each>
    <xsl:element name="label">
      <xsl:attribute name="i18n:trans"></xsl:attribute>
      <xsl:value-of select="./@label" />
    </xsl:element>
    <xsl:if test="./@hint != ''">
      <xsl:element name="hint">
        <xsl:attribute name="i18n:trans"></xsl:attribute>
        <xsl:value-of select="./@hint" />
      </xsl:element>
    </xsl:if>
    <xsl:if test="./@alert != ''">
      <xsl:element name="alert">
        <xsl:attribute name="i18n:trans"></xsl:attribute>
        <xsl:value-of select="./@alert" />
      </xsl:element>
    </xsl:if>
    
  </xsl:template>
</xsl:stylesheet>
