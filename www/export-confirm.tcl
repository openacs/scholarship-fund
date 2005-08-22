ad_page_contract {
	Confirmation page to export and mark exported

	@author Hamilton Chua (hamilton.chua@gmail.com)
	@creation-date 2005-08-14

}  {
	{ fund_id:integer,multiple,optional }
	{ all 0 }
	{ mark 0 }
}

set title "Export"
set package_id [ad_conn package_id]
set package_url [apm_package_url_from_id $package_id]
set user_id [ad_conn user_id]
set qstring ""
set content ""

# check permissions
permission::require_permission \
    -object_id $package_id \
    -party_id $user_id \
    -privilege "read"

# let's check first if there are unmarked items for export
if { [db_string "count_transferred" "select count(*) from scholarship_fund_grants where export_p = false"] > 0  } {
	append content "<p>Click the download link to start downloading the exported records in CSV format.</p>"
	set qstring "all=$all&mark=$mark"
	
	if { [exists_and_not_null exp_id] } {
		set exp_id_string [join $exp_id "&exp_id="]
		append qstring "&exp_id=$exp_id_string"
	}
	append content "<br /><a href=\"export-sch?$qstring\">Download CSV.</a>"
} else {
	append content "<br />Sorry, but all records have been MARKED transferred.<br /> There are no scholarship fund records for transfer."
}
append content "<br /><a href=\"$package_url/\">Go back to Scholarship Fund administration.</a>"