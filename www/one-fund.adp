<master>
  <property name="title">@page_title@</property>
  <property name="header_stuff">@header_stuff@</property>
  <property name="context">@context@</property>
  <property name="focus">@focus@</property>

<formtemplate id="one"></formtemplate>
<if @admin_p@><div><a href="@edit_url@" class="button">Edit Fund</a></div></if>  

<p />

<listtemplate name="grants"></listtemplate>