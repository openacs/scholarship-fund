<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">
<!--  -->
<!-- @author Dave Bauer (dave@thedesignexperience.org) -->
<!-- @creation-date 2005-05-17 -->
<!-- @arch-tag: f6032515-745f-4e5e-933f-03be49688211 -->
<!-- @cvs-id $Id$ -->

<queryset>
  <fullquery name="get_funds">
    <querytext>
      select sf.*
      from scholarship_fundi sf,
           cr_items ci
      where
           sf.revision_id = ci.live_revision
    </querytext>
  </fullquery>
  
</queryset>