<!-- 
	jGrouseDoc template file. Creates ant file that renders all documentation
	@Copyright (c) 2007 by Denis Riabtchik. All rights reserved. See license.txt and http://jgrouse.com for details@
	$Id: antgen.xslt 331 2008-01-08 02:11:41Z denis.riabtchik $
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	<xsl:output method="XML"/>
	<xsl:param name="projectName"/>
	<xsl:param name="projectDesc"/>
	<xsl:param name="jGrouseHome"/>
	<xsl:param name="projectFile"/>
	<xsl:param name="outDir"/>
	<xsl:param name="version"/>	
	<xsl:param name="useFullNames">true</xsl:param>
    <xsl:param name="css"><xsl:value-of select="$jGrouseHome"/>/skins/noframes/css/jgdoc.css</xsl:param>
    <xsl:param name='aux_css'>not_specified</xsl:param>
    <xsl:param name="skinDir">not_specified</xsl:param>
	
    <xsl:variable name="commonSkin"><xsl:value-of select="$jGrouseHome"/>/skins/common</xsl:variable>	
	
	<xsl:template name="dotdot">
		<xsl:param name="arg"/>
		<xsl:param name="sep"/>
		<xsl:param name="firstPart" select="substring-before($arg, $sep)"/>
		<xsl:param name="lastPart" select="substring-after($arg, $sep)"/>
		<xsl:if test="string-length($firstPart) != 0">../</xsl:if>
		<xsl:if test="string-length($lastPart) != 0"><xsl:call-template name="dotdot">
		<xsl:with-param name="arg" select="$lastPart"/>
		<xsl:with-param name="sep" select="$sep"/>
		</xsl:call-template></xsl:if>
	</xsl:template>
	
	
	
	<xsl:template match="/">
        <xsl:variable name="_projectName">
           <xsl:choose>
               <xsl:when test="count(/jgdoc/project/comment/name) != 0">
                   <xsl:value-of select="normalize-space(/jgdoc/project/comment/name)"/>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:value-of select="$projectName"/>
               </xsl:otherwise>
           </xsl:choose>
       </xsl:variable>
       <xsl:variable name="_version">
           <xsl:choose>
               <xsl:when test="count(/jgdoc/project/comment/version/tagContent/content) != 0">
                   <xsl:value-of select="normalize-space(/jgdoc/project/comment/version/tagContent/content)"/>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:value-of select="$version"/>
               </xsl:otherwise>
           </xsl:choose>
       </xsl:variable>
       <xsl:variable name="_projectDesc">
           <xsl:choose>
               <xsl:when test="count(/jgdoc/project/comment/description/tagContent/content) != 0">
                   <xsl:value-of select="normalize-space(/jgdoc/project/comment/description/tagContent/content)"/>
               </xsl:when>
               <xsl:otherwise>
                   <xsl:value-of select="$projectDesc"/>
               </xsl:otherwise>
           </xsl:choose>
       </xsl:variable>	
		<xsl:comment>Documentation build file for <xsl:value-of select="projectName"/>. Generated by jGrouseDoc</xsl:comment>
		<xsl:element name="project">
			<xsl:attribute name="name"><xsl:value-of select="$_projectName"/></xsl:attribute>
			<xsl:attribute name="default">applyJGrouseDoc</xsl:attribute>
			<xsl:element name="target">
				<xsl:attribute name="name">applyJGrouseDoc</xsl:attribute>
				<!-- copy CSS file -->
                <xsl:element name="copy">
                    <xsl:attribute name="todir"><xsl:value-of select="$outDir"/></xsl:attribute>
                    <xsl:attribute name="overwrite">yes</xsl:attribute>
                    <xsl:element name="fileset">
                        <xsl:attribute name="dir"><xsl:value-of select="$commonSkin"/>/css</xsl:attribute>
                    </xsl:element>
                </xsl:element>
				<xsl:element name="copy">
				    <xsl:attribute name="todir"><xsl:value-of select="$outDir"/></xsl:attribute>
                    <xsl:attribute name="overwrite">yes</xsl:attribute>
				    <xsl:element name="fileset">
				        <xsl:attribute name="dir"><xsl:value-of select="$skinDir"/>/css</xsl:attribute>
				    </xsl:element>
				</xsl:element>
				<!-- 
				<xsl:element name="copy">
					<xsl:attribute name="file"><xsl:value-of select="$css"/></xsl:attribute>
					<xsl:attribute name="tofile"><xsl:value-of select='$outDir'/>/jgdoc.css</xsl:attribute>
                    <xsl:attribute name="overwrite">yes</xsl:attribute>
				</xsl:element>
				-->
                <xsl:element name="copy">
                    <xsl:attribute name="todir"><xsl:value-of select="$outDir"/></xsl:attribute>
                    <xsl:element name="fileset">
                        <xsl:attribute name="dir"><xsl:value-of select="$commonSkin"/>/img</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="copy">
                    <xsl:attribute name="todir"><xsl:value-of select="$outDir"/></xsl:attribute>
                    <xsl:element name="fileset">
                        <xsl:attribute name="dir"><xsl:value-of select="$skinDir"/>/img</xsl:attribute>
                    </xsl:element>
                </xsl:element>
				
				<!-- copy JS file -->
                <xsl:element name="copy">
                    <xsl:attribute name="todir"><xsl:value-of select='$outDir'/></xsl:attribute>
                    <xsl:element name="fileset">
                        <xsl:attribute name="dir"><xsl:value-of select="$skinDir"/>/js</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                
				<!-- create main file -->
				<xsl:element name="xslt">
					<xsl:attribute name="style"><xsl:value-of select="$skinDir"/>/xslt/startup.xslt</xsl:attribute>
					<xsl:attribute name="in"><xsl:value-of select='$outDir'/>/<xsl:value-of select="$projectFile"/></xsl:attribute>
					<xsl:attribute name="out"><xsl:value-of select='$outDir'/>/index.html</xsl:attribute>
					<xsl:element name="param">
						<xsl:attribute name="name">projectName</xsl:attribute>
						<xsl:attribute name="expression"><xsl:value-of select="$_projectName"/></xsl:attribute>
					</xsl:element>
                    <xsl:element name="param">
                        <xsl:attribute name="name">projectDesc</xsl:attribute>
                        <xsl:attribute name="expression"><xsl:value-of select="$_projectDesc"/></xsl:attribute>
                    </xsl:element>
					<xsl:element name="param">
						<xsl:attribute name="name">version</xsl:attribute>
						<xsl:attribute name="expression"><xsl:value-of select="$_version"/></xsl:attribute>
					</xsl:element>
                    <xsl:if test="$aux_css != 'not_specified'">
                        <xsl:element name="param">
                            <xsl:attribute name="name">aux_css</xsl:attribute>
                            <xsl:attribute name="expression"><xsl:value-of select="$aux_css"/></xsl:attribute>
                        </xsl:element>
                    </xsl:if>
				</xsl:element>
				<!-- =========== javascript index ================= -->
				<xsl:element name="xslt">
                    <xsl:attribute name="style"><xsl:value-of select="$skinDir"/>/xslt/jsindex.xslt</xsl:attribute>
                    <xsl:attribute name="in"><xsl:value-of select='$outDir'/>/<xsl:value-of select="$projectFile"/></xsl:attribute>
                    <xsl:attribute name="out"><xsl:value-of select='$outDir'/>/jsindex.js</xsl:attribute>
                    <xsl:element name="param">
                        <xsl:attribute name="name">projectName</xsl:attribute>
                        <xsl:attribute name="expression"><xsl:value-of select="$_projectName"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="param">
                        <xsl:attribute name="name">projectDesc</xsl:attribute>
                        <xsl:attribute name="expression"><xsl:value-of select="$_projectDesc"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="param">
                        <xsl:attribute name="name">version</xsl:attribute>
                        <xsl:attribute name="expression"><xsl:value-of select="$_version"/></xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <!-- ============ logical stuff ================= -->
                <xsl:element name="fastxslt">
                    <xsl:attribute name="template"><xsl:value-of select="$skinDir"/>/xslt/detail.xslt</xsl:attribute>
                    <xsl:attribute name="source"><xsl:value-of select='$outDir'/>/<xsl:value-of select="$projectFile"/></xsl:attribute>
                    <xsl:element name="param">
                        <xsl:attribute name="key">version</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="$_version"/></xsl:attribute>
                    </xsl:element>
                    <xsl:if test="$aux_css != 'not_specified'">
                        <xsl:element name="param">
                            <xsl:attribute name="key">aux_css</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="$aux_css"/></xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="param">
                        <xsl:attribute name="key">projectName</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="$_projectName"/></xsl:attribute>
                    </xsl:element>
                    <xsl:element name="param">
                        <xsl:attribute name="key">projectDesc</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="$_projectDesc"/></xsl:attribute>
                    </xsl:element>
                        
                    <xsl:for-each select="/jgdoc/items/*[@elementType='logical_container']">
                        <xsl:element name="output">
                            <xsl:attribute name="file"><xsl:value-of select='$outDir'/>/logical/<xsl:value-of select="@path"/>.html</xsl:attribute>
                            <xsl:element name="param">
                                <xsl:attribute name="key">objectName</xsl:attribute>
                                <xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
                            </xsl:element>
	                        <xsl:element name="param">
	                            <xsl:attribute name="key">rootPath</xsl:attribute>
	                            <xsl:attribute name="value"></xsl:attribute>
	                        </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="key">navSection</xsl:attribute>
                                <xsl:attribute name="value">logical</xsl:attribute>
                            </xsl:element>	                                              
	                        <xsl:element name="param">
	                            <xsl:attribute name="key">trueRootPath</xsl:attribute>
	                            <xsl:attribute name="value">../<xsl:call-template name="dotdot">
	                                <xsl:with-param name="arg" select="comment/name" />
	                                <xsl:with-param name="sep" select="'.'"/>
	                            </xsl:call-template></xsl:attribute>
	                        </xsl:element>                                                  
	                   </xsl:element>
                    </xsl:for-each>
                    
                    <xsl:for-each select="/jgdoc/items/file">
                        <xsl:element name="output">
                            <xsl:attribute name="file"><xsl:value-of select='$outDir'/>/physical/<xsl:value-of select="@path"/>.html</xsl:attribute>
                            <xsl:element name="param">
                                <xsl:attribute name="key">objectName</xsl:attribute>
                                <xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="key">rootPath</xsl:attribute>
                                <xsl:attribute name="value"></xsl:attribute>
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="key">navSection</xsl:attribute>
                                <xsl:attribute name="value">file</xsl:attribute>
                            </xsl:element>                                                  
                            <xsl:element name="param">
                                <xsl:attribute name="key">trueRootPath</xsl:attribute>
                                <xsl:attribute name="value">../<xsl:call-template name="dotdot">
                                    <xsl:with-param name="arg" select="comment/name" />
                                    <xsl:with-param name="sep" select="'/'"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>                                                  
                       </xsl:element>
                    </xsl:for-each>    
                    <xsl:for-each select="/jgdoc/items/module">
                        <xsl:element name="output">
                            <xsl:attribute name="file"><xsl:value-of select='$outDir'/>/physical/<xsl:value-of select="@path"/>.html</xsl:attribute>
                            <xsl:element name="param">
                                <xsl:attribute name="key">objectName</xsl:attribute>
                                <xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
                            </xsl:element>
                            <xsl:element name="param">
                                <xsl:attribute name="key">rootPath</xsl:attribute>
                                <xsl:attribute name="value"></xsl:attribute>
                            </xsl:element>          
                            <xsl:element name="param">
                                <xsl:attribute name="key">navSection</xsl:attribute>
                                <xsl:attribute name="value">module</xsl:attribute>
                            </xsl:element>                                        
                            <xsl:element name="param">
                                <xsl:attribute name="key">trueRootPath</xsl:attribute>
                                <xsl:attribute name="value">../<xsl:call-template name="dotdot">
                                    <xsl:with-param name="arg" select="comment/name" />
                                    <xsl:with-param name="sep" select="'.'"/>
                                    </xsl:call-template>
                                </xsl:attribute>
                            </xsl:element>                                                  
                       </xsl:element>
                    </xsl:for-each>                        
                </xsl:element>
                
                
                <!-- 
                <xsl:for-each select="/jgdoc/items/file">
                    <xsl:element name="xslt">
                        <xsl:attribute name="style"><xsl:value-of select="$skinDir"/>/xslt/detail.xslt</xsl:attribute>
                        <xsl:attribute name="in"><xsl:value-of select='$outDir'/>/<xsl:value-of select="$projectFile"/></xsl:attribute>
                        <xsl:attribute name="out"><xsl:value-of select='$outDir'/>/physical/<xsl:value-of select="@path"/>.html</xsl:attribute>
                        
                        <xsl:element name="param">
                            <xsl:attribute name="name">objectName</xsl:attribute>
                            <xsl:attribute name="expression"><xsl:value-of select="@id"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="param">
                            <xsl:attribute name="name">rootPath</xsl:attribute>
                            <xsl:attribute name="expression"></xsl:attribute>
                        </xsl:element>                      
                        <xsl:element name="param">
                            <xsl:attribute name="name">trueRootPath</xsl:attribute>
                            <xsl:attribute name="expression">../<xsl:call-template name="dotdot">
                                <xsl:with-param name="arg" select="comment/name" />
                                <xsl:with-param name="sep" select="'/'"/>
                            </xsl:call-template></xsl:attribute>
                        </xsl:element>                      
                        <xsl:element name="param">
                            <xsl:attribute name="name">version</xsl:attribute>
                            <xsl:attribute name="expression"><xsl:value-of select="$_version"/></xsl:attribute>
                        </xsl:element>
                        <xsl:if test="$aux_css != 'not_specified'">
                            <xsl:element name="param">
                                <xsl:attribute name="name">aux_css</xsl:attribute>
                                <xsl:attribute name="expression"><xsl:value-of select="$aux_css"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:element name="param">
                            <xsl:attribute name="name">projectName</xsl:attribute>
                            <xsl:attribute name="expression"><xsl:value-of select="$_projectName"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="param">
                            <xsl:attribute name="name">projectDesc</xsl:attribute>
                            <xsl:attribute name="expression"><xsl:value-of select="$_projectDesc"/></xsl:attribute>
                        </xsl:element>                        
                         <xsl:element name="param">
                            <xsl:attribute name="name">navSection</xsl:attribute>
                            <xsl:attribute name="expression">file</xsl:attribute>
                        </xsl:element>  
                    </xsl:element>
                </xsl:for-each>                
                 
                <xsl:for-each select="/jgdoc/items/module">
                    <xsl:element name="xslt">
                        <xsl:attribute name="style"><xsl:value-of select="$skinDir"/>/xslt/detail.xslt</xsl:attribute>
                        <xsl:attribute name="in"><xsl:value-of select='$outDir'/>/<xsl:value-of select="$projectFile"/></xsl:attribute>
                        <xsl:attribute name="out"><xsl:value-of select='$outDir'/>/physical/<xsl:value-of select="@path"/>.html</xsl:attribute>
                        
                        <xsl:element name="param">
                            <xsl:attribute name="name">objectName</xsl:attribute>
                            <xsl:attribute name="expression"><xsl:value-of select="@id"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="param">
                            <xsl:attribute name="name">rootPath</xsl:attribute>
                            <xsl:attribute name="expression"></xsl:attribute>
                        </xsl:element>                      
                        <xsl:element name="param">
                            <xsl:attribute name="name">trueRootPath</xsl:attribute>
                            <xsl:attribute name="expression">../<xsl:call-template name="dotdot">
                                <xsl:with-param name="arg" select="comment/name" />
                                <xsl:with-param name="sep" select="'.'"/>
                            </xsl:call-template></xsl:attribute>
                        </xsl:element>                      
                        <xsl:element name="param">
                            <xsl:attribute name="name">version</xsl:attribute>
                            <xsl:attribute name="expression"><xsl:value-of select="$_version"/></xsl:attribute>
                        </xsl:element>
                        <xsl:if test="$aux_css != 'not_specified'">
                            <xsl:element name="param">
                                <xsl:attribute name="name">aux_css</xsl:attribute>
                                <xsl:attribute name="expression"><xsl:value-of select="$aux_css"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                        <xsl:element name="param">
                            <xsl:attribute name="name">projectName</xsl:attribute>
                            <xsl:attribute name="expression"><xsl:value-of select="$_projectName"/></xsl:attribute>
                        </xsl:element>
                        <xsl:element name="param">
                            <xsl:attribute name="name">projectDesc</xsl:attribute>
                            <xsl:attribute name="expression"><xsl:value-of select="$_projectDesc"/></xsl:attribute>
                        </xsl:element>                        
                         <xsl:element name="param">
                            <xsl:attribute name="name">navSection</xsl:attribute>
                            <xsl:attribute name="expression">module</xsl:attribute>
                        </xsl:element>  
                    </xsl:element>
                </xsl:for-each>                   
                 -->
                
			</xsl:element>
		</xsl:element>
		
	</xsl:template>
</xsl:stylesheet>