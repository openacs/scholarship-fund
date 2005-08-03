-- 
-- packages/scholarship-fund/sql/postgresql/upgrade-0.1d-0.1d1.sql
-- 
-- @author Roel Canicula (roelmc@pldtdsl.net)
-- @creation-date 2005-08-03
-- @arch-tag: abd54f8f-d9cc-4590-8f1c-c23cd8587484
-- @cvs-id $Id$
--

create table scholarship_fund_grants (
	grant_id		serial primary key,
	fund_id			integer references scholarship_fund on delete cascade not null,
	user_id			integer references users on delete cascade not null,
	grant_date		timestamp default current_timestamp not null,
	gift_certificate_id 	integer references ec_gift_certificates not null,
	grant_amount		float not null
);