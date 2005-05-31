# 

ad_page_contract {
    
    Display one scholarship fund
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-17
    @arch-tag: 6db507f3-14d8-47da-aa1b-bdab2b155315
    @cvs-id $Id$
} {
    item_id:integer,notnull
} -properties {
    page_title
    context
} -validate {
} -errors {
}

set user_id [ad_conn user_id]
permission::require_permission \
    -object_id $item_id \
    -party_id $user_id \
    -privilege "read"

set admin_p [permission::permission_p \
                 -object_id $item_id \
                 -party_id $user_id \
                 -privilege "admin"]

db_1row get_fund "select sf.* from scholarship_fundi sf, cr_items ci where sf.revision_id=ci.live_revision and sf.item_id=:item_id" -column_array fund

set edit_url [export_vars -base "fund-add-edit" {item_id}]

set page_title "One Scholarship Fund"
set context [list $page_title]
set header_stuff ""
set focus ""

ad_return_template
