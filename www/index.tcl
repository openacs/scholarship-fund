# 

ad_page_contract {
    
    List scholarship Funds
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-17
    @arch-tag: d8a5f3d7-6fa9-441b-a082-3c8db5eb6c67
    @cvs-id $Id$
} {
    
} -properties {
    page_title
    context
} -validate {
} -errors {
}

set user_id [ad_conn user_id]
set package_id [ad_conn user_id]

permission::require_permission \
    -object_id $package_id \
    -party_id $user_id \
    -privilege "read"

set admin_p [permission::permission_p \
                     -object_id $package_id \
                 -party_id $user_id \
                 -privilege "admin"]

set actions [list "Add Fund" fund-add-edit "Add a new scholarship fund"]
db_multirow -extend { one_url edit_url delete_url } funds get_funds "" {
    set one_url [export_vars -base one-fund {item_id}]
    set edit_url [export_vars -base fund-add-edit {item_id}]
    set delete_url [export_vars -base fund-delete {item_id}]
}

template::list::create \
    -name funds \
    -multirow funds \
    -actions $actions \
    -elements {
        title { label "Title"  link_url_col one_url }
        description { label "Description" }
	actions {
	    label "Actions"
	    display_template {
	    <div align=center>
       	    <a href="@funds.edit_url@"
	    title="Edit Fund"><img border="0" src="/resources/Edit16.gif"></a>
       	    <a href="@funds.delete_url@"
	    title="Delete Fund"><img border="0" src="/resources/Delete16.gif"></a>
	    }
	}
    }

set page_title "Scholarship Funds"
set context [list $page_title]
set focus ""
set header_stuff ""

ad_return_template