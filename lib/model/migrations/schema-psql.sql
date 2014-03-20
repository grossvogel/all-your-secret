
drop table if exists secret;
create table secret (
	id serial,
	encrypted text not null,
	token varchar(255) null,
	created timestamp not null,
	primary key(id),
	unique (Token)
);

create index on secret(created);
