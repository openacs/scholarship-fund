ad_page_contract {

    Generate a CSV of the given fund_id
    
    @author Hamilton Chua (hamilton.chua@gmail.com)
    @creation-date 2005-08-14

}  {
   {fund_id:integer,multiple,optional}
   {all 0}
   {mark 0}
}

set title "Export Scholarship Funds"
set context $title

# generate list of exp_item_id's for export
if { [exists_and_not_null fund_id] } {
	for {set i 0} {$i < [llength $fund_id]} {incr i} {
    		set id_$i [lindex $fund_id $i]
    		lappend bind_id_list ":id_$i"
	}
}

# use list template to create list of scholarship funds

template::list::create \
    -name scholarship_funds \
    -multirow scholarship_funds \
    -key fund_id \
    -selected_format csv \
    -formats {
        csv { output csv }
    } -elements {
	fund_id {
		label "Fund"
	}
	account_code {
		label "Account Code"
	}
	description {
		label "Description"
	}
	name {
	    label "Name"
	}
	grant_date {
	    label "Grant Date"
	}
	grant_amount {
	    label "Grant Amount"
	}
    } 

# build the multirow

#set query "select fund_id, description, account_code, export_p from scholarship_fundx where export_p = false"
set query "select f.fund_id, person__name(g.user_id) as name, to_char(g.grant_date, 'Month dd, yyyy hh:miam') as grant_date, g.grant_amount,
    f.account_code, f.description
    from scholarship_fund_grants g,
    scholarship_fundi f
    where g.fund_id=f.fund_id
    group by person__name(g.user_id), g.grant_date, g.grant_amount, f.fund_id, f.account_code, f.description
    order by g.grant_date"
# Save for Later in case we want 
# to bring back selective exports

#if { $all == 0 } {		
#	set items_for_export [join $bind_id_list ","]
#	append query " and exp_id in ( $items_for_export )"
	# mark id's as exported only if $mark ==1
#	if { $mark == 1 } {
#		foreach id $exp_id {
#			expenses::mark_exported -id $id
#		}
#	}
#} else {
#}


db_multirow scholarship_funds get_sch_funds $query { }

if { $mark == 1 } {
	db_dml "mark_exported" "update scholarship_fund set export_p = 't'"
}

# change headers to output csv
set outputheaders [ns_conn outputheaders]
ns_set cput $outputheaders "Content-Disposition" "attachment; filename=scholarship_fund.csv"
template::list::write_output -name scholarship_funds
