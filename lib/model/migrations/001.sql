delimiter |

DROP PROCEDURE IF EXISTS add_created_date|
CREATE PROCEDURE add_created_date() BEGIN
	if not exists	
	(
		select * from information_schema.COLUMNS
		where COLUMN_NAME ='created' and TABLE_NAME='secret' and TABLE_SCHEMA=database()
	)
	then
		alter table secret add created datetime null;
		alter table secret add index `secret_created`(`created`);
	end if;
end;
|
CALL add_created_date()|
DROP PROCEDURE IF EXISTS add_created_date|

delimiter ;
