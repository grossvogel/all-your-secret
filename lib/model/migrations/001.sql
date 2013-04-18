delimiter |

DROP PROCEDURE IF EXISTS add_created_date|
CREATE PROCEDURE add_created_date() BEGIN
	if not exists	
	(
		select * from information_schema.COLUMNS
		where COLUMN_NAME ='Created' and TABLE_NAME='Secret' and TABLE_SCHEMA=database()
	)
	then
		alter table Secret add Created datetime null;
		alter table Secret add index `secret_created`(`Created`);
	end if;
end;
|
CALL add_created_date()|
DROP PROCEDURE IF EXISTS add_created_date|

delimiter ;
