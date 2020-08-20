#一些面试题 
show databases;
select database();
use students;
create table if not exists chengji(
	name varchar(20) not null,
    kecheng varchar(20) not null,
    fenshu int 
);
INSERT into chengji values
('zhang','yu','81'),
('zhang','shu',75),
('li','yu','76'),
('li','shu','90'),
('wang','yu','98'),
('wang','shu','99'),
('wang','ying','97');

select * from chengji;
SELECT name from chengji 
group by name
having min(fenshu)>80;

select distinct name from chengji
where name not in(select distinct name from chengji where fenshu<=80);

# delete chengji where zi not in(select min(zi) from chengji group by xuehao, xingming);

select * from testdb a, (select * from testdb where accid='101') b
group by occmonth
having a.debitoccur>b.debitoccur;


create table if not exists hangzhuanlie(
	name varchar(20),
    subject varchar(20),
    score int
);
insert into hangzhuanlie values
('zhang','yu','81'),
('zhang','shu',75),
('zhang','ying',79),
('li','yu','76'),
('li','shu','90'),
('li','ying',56),
('wang','yu','98'),
('wang','shu','99'),
('wang','ying','97');

select * from hangzhuanlie;

select name,
sum(case when subject='yu' then score else 0 end) as 语文,
sum(case when subject='shu' then score else 0 end) as 数学,
sum(case when subject='ying' then score else 0 end) as 英语,
sum(score) as 总分
from hangzhuanlie
group by name;