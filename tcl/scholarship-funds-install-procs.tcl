# 

ad_library {
    
    Installation procedures for scholarship-funds
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-17
    @arch-tag: 766d5355-5c3f-4d02-9703-18ac04c5d21f
    @cvs-id $Id$
}

namespace eval sf::install {}

ad_proc -public sf::install::package_install {
} {

    Setup package
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-17
    
    @return 
    
    @error 
} {
    content::type::new \
        -content_type scholarship_fund \
        -pretty_name "Scholarship Fund" \
        -pretty_plural "Scholarship Funds" \
        -id_column "fund_id" \
	-table_name "scholarship_fund" \
	-supertype "content_revision" \
	-name_method "scholarship_fund__name"

    content::type::attribute::new \
        -content_type scholarship_fund \
        -attribute_name "account_code" \
        -datatype text \
        -pretty_name "Account Code" \
        -pretty_plural "Account Codes" \
        -column_spec "varchar(200)"
    
    content::type::attribute::new \
        -content_type scholarship_fund \
        -attribute_name "amount" \
        -datatype text \
        -pretty_name "Amount in Fund" \
        -pretty_plural "Amount in Fund" \
        -column_spec "float"

     db_dml "alter_foreign_key" "alter table scholarship_fund_grants add constraint fund_id_fk foreign key (fund_id) references scholarship_fund (fund_id) on delete cascade"
}

ad_proc -private sf::install::after_instantiate {
    -package_id
} {
     Setup package instance
    
    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-05-17
    
    @param package_id

    @return 
    
    @error 
} {
    ns_log Warning "about to all folder new"
    set folder_id [content::folder::new \
                       -name "scholarship_fund_${package_id}" \
                       -parent_id -100 \
                       -package_id $package_id \
                       -label "Scholarship Funds ${package_id}"]
    ns_log Warning "folder_id is $folder_id"

    content::folder::register_content_type \
        -folder_id $folder_id \
        -content_type scholarship_fund
    
    ns_log Warning "registered the content type"
}

ad_proc -private sf::install::after_upgrade {
    -from_version_name:required
    -to_version_name:required
} {
    After upgrade callback
    
    @author Roel Canicula (roelmc@pldtdsl.net)
    @creation-date 2005-08-04
    
    @param from_version_name

    @param to_version_name

    @return 
    
    @error 
} {
    apm_upgrade_logic \
	-from_version_name $from_version_name \
	-to_version_name $to_version_name \
	-spec {
	    0.4d 0.5d {
		content::type::attribute::new \
		    -content_type scholarship_fund \
		    -attribute_name "amount" \
		    -datatype text \
		    -pretty_name "Amount in Fund" \
		    -pretty_plural "Amount in Fund" \
		    -column_spec "float"
	    }
	}
}
