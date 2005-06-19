# packages/scholarship-fund/www/fund-delete.tcl

ad_page_contract {
    
    
    
    @author Roel Canicula (roelmc@pldtdsl.net)
    @creation-date 2005-06-13
    @arch-tag: ef111316-9d68-4e41-ba23-e0cef846f142
    @cvs-id $Id$
} {
    item_id:integer
    {confirmed_p 0}
} -properties {
} -validate {
} -errors {
}

if { $confirmed_p } {
    db_exec_plsql delete_fund {
	select content_item__delete(:item_id)
    }

    ad_returnredirect index
    ad_script_abort
}

set context [list "Delete Fund"]
set user_id [ad_conn user_id]

permission::require_permission \
    -party_id $user_id \
    -object_id $item_id \
    -privilege "write"

db_1row get_fund "select sf.title, sf.description, sf.account_code from scholarship_fundi sf, cr_items ci where sf.revision_id=ci.live_revision and sf.item_id=:item_id"

set confirm_url [export_vars -base fund-delete { item_id {confirmed_p 1} }]