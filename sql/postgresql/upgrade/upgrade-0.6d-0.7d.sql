alter table scholarship_fund_grants add export_p boolean;
alter table scholarship_fund_grants alter export_p set default 'f';
update scholarship_fund_grants set export_p='f';