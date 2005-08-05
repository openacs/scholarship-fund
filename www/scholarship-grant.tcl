# packages/scholarship-fund/www/scholarship-grant.tcl

ad_page_contract {
    
    Grant scholarship to user
    
    @author Roel Canicula (roelmc@pldtdsl.net)
    @creation-date 2005-08-03
    @arch-tag: b6e25b4c-1f20-4710-b9ce-bd11658bba7d
    @cvs-id $Id$
} {
    fund_id:integer,notnull

    {user ""}
    {user_id 0}

} -properties {
} -validate {
} -errors {
}

if { ! [empty_string_p $user] } {
    # Search found users, show a more detailed list
    template::list::create \
	-name users \
	-multirow users \
	-key user_id \
	-page_size 50 \
	-page_flush_p 1 \
	-no_data "No users found" \
	-page_query [subst {
	    select u.user_id, u.first_names, u.last_name, u.email, a.phone, a.line1, a.line2
	    from dotlrn_users u
	    left join (select *
		       from ec_addresses
		       where address_id
		       in (select max(address_id)
			   from ec_addresses
			   group by user_id)) a
	    on (u.user_id = a.user_id)
	    where u.user_id != :user_id
	    and u.user_id != :user_id
	    and (case when :user is null
		 then true
		 else (lower(first_names) like lower(:user)||'%' or
		       lower(last_name) like lower(:user)||'%' or
		       lower(email) like lower(:user)||'%' or
		       lower(phone) like '%'||lower(:user)||'%') end)
	}] -elements {
	    _user_id {
		label "User ID"
	    }
	    email {
		label "Email Address"
	    }
	    first_names {
		label "First Name"
	    }
	    last_name {
		label "Last Name"
	    }
	    phone {
		label "Phone Number"
	    }
	    address {
		label "Address"
		display_template {
		    @users.line1@
		    <if @users.line2@ not nil>
		    <br />@users.line2@
		    </if>
		}
	    }
	    action {
		display_template {
		    <a href="@users.add_user_url;noquote@" class="button">Choose User</a>
		}
	    }
	} -filters {
	    user_id {}
	    user {}
	    fund_id {}
	}
    
    db_multirow -extend { add_user_url } users users [subst {
	select u.user_id as _user_id, u.first_names, u.last_name, u.email, a.phone, a.line1, a.line2
	from dotlrn_users u
	left join (select *
		   from ec_addresses
		   where address_id
		   in (select max(address_id)
		       from ec_addresses
		       group by user_id)) a
	on (u.user_id = a.user_id)
	where u.user_id != :user_id
	and (case when :user is null
	     then true
	     else (lower(first_names) like lower(:user)||'%' or
		   lower(last_name) like lower(:user)||'%' or
		   lower(email) like lower(:user)||'%' or
		   lower(phone) like '%'||lower(:user)||'%') end)
	[template::list::page_where_clause -and -name users -key u.user_id]
    }] {
	set add_user_url [export_vars -base scholarship-grant { fund_id {user_id $_user_id} { user "" } new_user_p }]
    }
}

ad_form -name grant -form {
    {-section "Grant"}
}

if { $user_id } {

    acs_user::get -user_id $user_id -array user_info
    set search_url [export_vars -base scholarship-grant { fund_id {user_id 0} {user ""} }]
    ad_form -extend -name grant -export { fund_id user user_id } -form {
	{_participant:text(inform) {label "User"} {value "$user_info(first_names) $user_info(last_name) ($user_info(email))"}
	    {after_html {<a href="$search_url" class="button">Search Again</a>}}
	}
    }
    
} else {

    ad_form -extend -name grant -export { fund_id } -form {
	{user:text,optional {label "Search User"} {html {onchange "if (this.value != '') { this.form.__refreshing_p.value = 1; } else { this.form.__refreshing_p.value = 0 ; }" size 30}}
	    {help_text "Enter a string to search names and email addresses."}
	}
    }

}

ad_form -extend -name grant -validate {
    {grant_amount
	{ $grant_amount > 0 }
	"Invalid grant amount"
    }
} -form {
    {grant_amount:text {label "Amount to Grant"}
	{html {size 10}}
    }
} -on_submit {
    db_transaction {
	
	set gift_certificate_id [db_nextval ec_gift_cert_id_sequence]
	set random_string [ec_generate_random_string 10]
	set claim_check "scholarship-$random_string-$gift_certificate_id"
	set peeraddr [ns_conn peeraddr]
	set gc_months [ad_parameter -package_id [ec_id] GiftCertificateMonths ecommerce]
	
	set viewing_user_id [ad_conn user_id]

	db_dml insert_new_gc_into_db [subst {
	    insert into ec_gift_certificates
	    (gift_certificate_id, gift_certificate_state, amount, issue_date, purchased_by, expires, last_modified, last_modifying_user, modified_ip_address, user_id)
	    values
	    (:gift_certificate_id, 'authorized', :grant_amount, current_timestamp, :viewing_user_id, current_timestamp + '$gc_months months'::interval, current_timestamp, :viewing_user_id, :peeraddr, :user_id)
	}]
	
	db_dml insert_scholarship_grant {
	    insert into scholarship_fund_grants
	    (fund_id, user_id, gift_certificate_id, grant_amount)
	    values
	    (:fund_id, :user_id, :gift_certificate_id, :grant_amount)
	}

# 	db_dml update_scholarship_fund {
# 	    update scholarship_fund
# 	    set amount = amount - :grant_amount
# 	    where fund_id = :fund_id
# 	}
    }

    ad_returnredirect index
    ad_script_abort
}