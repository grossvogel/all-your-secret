delimiter |

DROP PROCEDURE IF EXISTS fresh_schema|
CREATE PROCEDURE fresh_schema() BEGIN
	if not exists	
	(
		select * from information_schema.COLUMNS
		where COLUMN_NAME ='ID' and TABLE_NAME='Secret' and TABLE_SCHEMA=database()
	)
	then
		create table `secret` (
			`id` int(11) unsigned not null auto_increment,
			`encrypted` text not null,
			`token` varchar(255) null,
			primary key(`id`),
			unique index unique_token(Token)
		) engine=innodb;
	end if;
end;
|
CALL fresh_schema()|
DROP PROCEDURE IF EXISTS fresh_schema|

delimiter ;
