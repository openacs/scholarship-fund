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

ad_form -name one -mode display -export { item_id } -has_edit 1 -form {
    {title:text {label "Fund Title"}}
    {description:text(textarea) {label "Description"}}
    {account_code:text {label "Account Code"}}
    {amount:text {label "Amount"}}
} -on_request {
    db_1row get_fund "select sf.title, sf.description, sf.account_code, sf.amount from scholarship_fundi sf, cr_items ci where sf.revision_id=ci.live_revision and sf.item_id=:item_id"
}

template::list::create \
    -name grants \
    -multirow grants \
    -no_data "No grants from this fund" \
    -actions [list Grant scholarship-grant?fund_id=$fund(fund_id) Grant] \
    -elements {
	person__name {
	    label "User"
	}
	grant_date {
	    label "Date Granted"
	}
	grant_amount {
	    label "Amount"
	}
    }

db_multirow grants grants {
    select person__name(user_id), to_char(grant_date, 'Month dd, yyyy hh:miam') as grant_date, grant_amount
    from scholarship_fund_grants
    where fund_id in (select fund_id
		      from scholarship_fundi
		      where item_id = :item_id)
    group by person__name, grant_date, grant_amount
    order by scholarship_fund_grants.grant_date
}

set page_title "One Scholarship Fund"
set context [list $page_title]
set header_stuff ""
set focus ""

ad_return_template
