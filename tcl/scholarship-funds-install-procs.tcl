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
    set folder_id [content::folder::new \
                       -name "scholarship_fund_${package_id}" \
                       -parent_id -100 \
                       -package_id $package_id \
                       -label "Scholarship Funds ${package_id}"]

    content::folder::register_content_type \
        -folder_id $folder_id \
        -content_type scholarship_find
}

