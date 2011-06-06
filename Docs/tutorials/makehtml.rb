#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'erb'
require 'rdiscount'

@nav=<<EOS
<ul class="navigation">
  <li><a href="../documentation.html">Main documentation</a></li>
  <li><a href="luatutorials.html">urMus tutorials overview</a></li>
</ul>
EOS

template=ERB.new <<EOS
<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title><%= @title %></title>
    <script src="highlight/highlight.pack.js"></script>
    <script>
      hljs.tabReplace = '    ';
      hljs.initHighlightingOnLoad();
    </script>
    <link rel="stylesheet" href="highlight/styles/github.css">
	<link rel="stylesheet" href="styles.css" type="text/css" media="screen" charset="utf-8">
	<!-- Date: 2010-03-16 -->
</head>
<body>
<body bgcolor=#ffffff text=#000000>
<center>
<font size="4" face="Trebuchet MS">ur<span
style='color:#548DD4'>Mus</span></font><font size="4" face="Verdana"> - Audio and Media Interactions and Interfaces on Mobile Phones</font><br>
<hr>
<br>
<img src="../images/urMusLogo.png" alt="urMus"><br>
<br>
<font size="4" face="Verdana"> urMus Tutorials </font>
<br>
<hr width="350">
  <%= @nav %>
</center>
  <%= @body %>
<center>
  <%= @nav %>
</center>
</body>
</html>
EOS

Dir.glob("*.md").each {|f_name|
  f = File.read(f_name)
  @body = RDiscount.new(f).to_html
  @title = f.split("\n")[0] + " &laquo; urMus API"
  
  f_md_name = File.basename(f_name,'.*') + ".html"
  File.open(f_md_name,'w') {|w| w.write(template.result) }
}
