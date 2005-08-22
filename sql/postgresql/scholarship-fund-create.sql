-- 
-- packages/scholarship-fund/sql/postgresql/scholarship-fund-create.sql
-- 
-- @author Roel Canicula (roelmc@pldtdsl.net)
-- @creation-date 2005-08-03
-- @arch-tag: 904b71ab-89cf-4c36-af73-7fc85414a6bc
-- @cvs-id $Id$
--

create table scholarship_fund_grants (
	grant_id serial primary key,
	fund_id integer not null,
	user_id integer references users on delete cascade not null,
	grant_date timestamp default current_timestamp not null,
	gift_certificate_id integer references ec_gift_certificates not null,
	grant_amount float not null,
	export_p boolean
);