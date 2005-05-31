# 

ad_page_contract {
    
    Add or Edit a fund
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-17
    @arch-tag: b776ec1a-53c8-4c4b-8760-eb605e75b874
    @cvs-id $Id$
} {
    item_id:integer,optional
} -properties {
    page_title
    context
} -validate {
} -errors {
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]

if {![ad_form_new_p -key item_id] && [exists_and_not_null item_id]} {
    permission::require_permission \
        -party_id $user_id \
        -object_id $item_id \
        -privilege "write"
} else {
    permission::require_permission \
        -party_id $user_id \
        -object_id $package_id \
        -privilege "create"
}

set folder_id [content::folder::get_folder_from_package -package_id $package_id]

ad_form -name fund-add-edit \
    -form {
        item_id:key
        title:text
        description:text(textarea)
        account_code:text
    } -edit_request {
        # get existing fund info
	db_1row get_fund "select sf.title, sf.description, sf.account_code from scholarship_fundi sf, cr_items ci where sf.revision_id=ci.live_revision and sf.item_id=:item_id"
    } -new_data {
        #add fund
        content::item::new \
            -name "scholarship_fund_${item_id}" \
            -item_id $item_id \
            -parent_id $folder_id \
            -title $title \
            -description $description \
            -content_type scholarship_fund \
            -is_live t \
            -attributes [list [list account_code $account_code]]
            
    } -edit_data {
        #update fund
        content::revision::new \
            -item_id $item_id \
            -title $title \
            -description $description \
            -attributes [list [list account_code $account_code]] \
            -is_live t
        
    } -after_submit {
        set return_url [export_vars -base one-fund {item_id}]
        ad_returnredirect $return_url
    }
        
       
set page_title "Add/Edit Fund"
set context [list $page_title]
set header_stuff ""
set focus ""

ad_return_template