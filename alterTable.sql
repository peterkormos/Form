create table poll_group (
	record_id int primary key, 
    name VARCHAR(50), 
    group_id int 
);


DROP TABLE IF EXISTS `poll_binding`;
create table poll_binding (
    user_id int not null, 
    group_id int not null
);

alter table poll_poll add group_id int;