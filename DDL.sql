#DDL
# 数据定义语言
# 库和表的管理
# 一、库的管理
# 创建  修改 删除
# 二、表的管理
# 创建、修改、删除

# 创建：create
# 修改：alter
# 删除：drop （需要和insert update delete 区分开来）

# 一、库的管理
# 1. 库的创建 
# 语法：
# create database 库名；

#创建库book
create database books;
create database if not exists books;

#2. 库的修改
# 一般来说不修改 库名不让更改 除非去路径中
#更改库的字符集
alter database books character set gbk;

#3.库的删除
drop database books;
drop database if exists books;


#二、库中表的管理
# 1. 表的创建
create database if not exists books;
# 语法：
# create table 表名
# 	列名 列的类型（长度） 约束，
# 	列名 列的类型（长度） 约束，
# 	列名 列的类型（长度） 约束，
# 	列名 列的类型（长度） 约束，
#     ...
# 	列名 列的类型（长度） 约束

use books;
create table book (
	id int,
    bname VARCHAR(20),
    price double,
    authorid int,
    publishdate datetime
);
desc book;

create table author(
	id int,
    au_name varchar(20),
    nation varchar(10)
);
desc author;

#2. 表的修改
# alter table 表名 add drop modify change column 列名 列类型 约束；
# 1. 修改列名
alter table book change COLUMN publishdate pubdate DATEtime;

# 2. 修改列的类型或约束
alter table book modify column pubdate TIMESTAMP;

# 3. 添加新列
alter table author add column annual double;

# 4. 删除列
alter table author drop column annual;

# 5. 修改表名 
alter table author rename to authors;
desc authors;


#三。表的删除 drop table 表名
drop table authors;
show tables;

drop table if exists authors;


#通用写法
# drop database if exists 旧库名;
# create database 新库名;

# drop table if exists 旧表名;
# create table 表名();

#四。表的复制
insert into books.author values
(1,'村上春树','日本'),
(2,'moyan','zhongguo'),
(3,'jinyong','zhongguo'),
(4,'gulong','zhongguo');

#1. 仅仅复制表的结构
create table copy like author;
show tables;

select * from copy;
select * from author;

#2. 复制表的结构外加数据
create table copy2
select * from author;

show tables;
select * from copy2;

#3. 只复制部分数据
create table copy3 
select id, au_name from author
where nation='zhongguo';
select * from copy3;

#4. 只想复制某些字段
create table copy4
select id, au_name
from author
where 0;-- 设置一个不可能成立的条件就可以

select * from copy4;

-- P117 习题 创建删除等表的操作，选用test库进行操作
use test;
create table dept1(
	id int(7),
    name varchar(25)
);


create table dept2
select department_id, department_name from myemployees.departments;
select * from dept2;

drop table emp5;
create table emp5(
	id int,
    First_name varchar(25),
    last_name varchar(25),
    dept_id int
);
alter table emp5 modify column last_name varchar(50);

create table employees2 like myemployees.employees;

drop table if exists emp5;

alter table employees2 rename to emp5;

alter table emp5 add column test_column int;

desc emp5;
alter table emp5 drop column test_column;


#常见的数据类型
/*
	数值型：
		整型
        小数：
			定点数
            浮点数
	字符型：
		较短的文本：char、varchar
        较长的文本：text、blob（较长的二进制数据）
	日期型：
*/

#一。整型
/*
分类：
tinyint smallint mediumint int/integer bigint
1		2			3		4			8
特点：
1. 如果不设置无符号和有符号，默认有符号，如果要设置无符号 需要添加unsigned
2. 如果插入的数值超出了我们整型的范围 直接报错
3. 如果不设置长度也没关系 会有默认的长度 长度代表了显示的最大宽度 不够会用0填充 需要zerofill

*/

#1. 如何设置无符号有符号
use test;
drop table if exists tab_int;
create table tab_int(
	t1 int(7) zerofill,
    t2 int unsigned
);
desc tab_int;
insert into tab_int values(12345,12345);

select * from tab_int;

#2. 小数
# 特点：
# 浮点型
# float(M,D)
# double(M,D)
# 定点型
# dec(M,D)
# decimal(M,D)
# M: 有效数字
# D: 小数部位
# MD都可以省略
# 如果是decimal 则M默认为10 D默认为0
# 如果是float和double 则根据插入的数值的精度来决定精度
# 定点型的精确度较高，如果要求插入的数值的精度较高则考虑使用


drop table tab_float;
create table tab_float(
	f1 float,
    f2 double,
    f3 decimal
);

desc tab_float;

#原则：所选择的类型越简单约好，能保存数值的类型越小越好


#三、字符型
/*
较短的文本：
char	固定长度的字符
varchar	可变长度的字符
较长的文本：
text
blob 较大的二进制
其他类型: binary varbinary enum用于保存枚举  set用于保存集合
特点：


char	char(M)		M代表最大字符数，可以省略默认为1		固定长度的字符		比较耗费空间		效率高
varchar	varchar(M)	M代表最大字符数，M不可以省略			可变长度的字符		比较节省空间		效率低
*/

create table tab_char(
	c1 enum('a','b','c')
);
insert into tab_char values('a');
insert into tab_char values('b');
insert into tab_char values('c');
insert into tab_char values('A');
insert into tab_char values('M'); -- error
select * from tab_char;




#4.日期型
/*
date	只保存日期
datetime	保存日期加时间 
timestamp 保存日期加时间
time 只保存时间
year 只保存年


特点					字节				范围				时区等的影响
datetime			8				1000-9999		不受
timestamp			4				1970-2038		受
*/


create table tab_date(
	t1 datetime,
    t2 timestamp

);



insert into tab_date values(now(), now());
select * from tab_date;

show variables like 'time_zone';
set time_zone = '+9:00';


-- 复习
/*
select 查询列表		7
from 表 别名			1
连接类型 join 表2		2
on 连接条件			3
where				4
group by			5
having				6
order by			8
limit 起始条目索引 条目数		9

方式1： insert into 表名（字段名）values(),(),(),...支持子查询
方式2： insert into 表名 set 字段=值,字段=值,...

update 表名 set 字段=值,字段=值... where 筛选条件
update 表名 别名
left right inner join 表2 别名
on 连接条件
set 字段=值...
where 筛选条件
 
delete from 表名 where 条件 limit 行数
delete from 表1 inner、left、right join 表2 别名
on 连接条件
where 筛选条件

truncate table 表名

delete 和trucate的区别    ✨✨✨重点重点重点
1. truncate删除后再插入标识列从1开始，delete删除后再插入标识从断点开始
2. delete可以添加筛选条件  truncate不可以添加筛选条件
3. truncate效率更高
4.truncate没有返回值，delete可以返回受影响的行数
5.truncate无法回滚 delete可以回滚

delete后边也可以跟limit limit=1则删除一行


DDL
create database if not exists 库名 character set 字符集合
create table if not exists 表名 (
	字段名 字段类型 约束,
    ...
);

alter table 表名 add column 列名 类型 【first|after 字段名】 这样就可以插入指定的位置 first指从头插入
alter table 表名 modify column 列名 新类型 新约束
alter table 表名 change column 旧列名 新列名 类型
alter table 表名 drop column 列名
alter table 表名 rename to 新表明
drop table if exists 表名

create table like 旧表
create table 表名
select 查询列表 from 旧表 where
*/


#常见的约束
/*
含义：一种限制，用于限制表中数据，为了保证表中数据的一致性，准确性，可靠性

分类：六大约束
		not null: 非空,保证该字段的值不能为空  eg:姓名  学号
        default: 默认,用于保证该字段有默认值	   eg:性别  
        primary key: 主键,用于保证该字段的值具有唯一性，并且非空  eg:学号 员工编号
        unnique: 唯一 用于保证该字段的值具有唯一性 可以为空   eg:座位号
        check: 检查约束, mysql中不支持   eg:年龄  性别
        foreign key: 外键 用于限制两个表的关系，用于限制该字段的值必须来自于主表的关联列的值 
                     添加在从表中。用于引用主表中某列的值  eg：学生表的专业编号 员工表的部门编号 员工表的工种编号
                     

添加约束的时机：
	1. 创建表时
    2. 修改表时
    
约束的添加分类：
	列级约束:
		六大约束语法上都支持 但是外键约束没效果
    表级约束
		除了非空 默认 其他的都支持
create table 表名（
	字段名 字段类型 列级约束，
    字段名 字段类型，
    表级约束
）;


主键和唯一约束的大对比
			保证唯一性		是否可以为空			一个表中可以有多少个		是否允许组合
主键			可以				不可以				最多一个					允许 不推荐
唯一			可以  			可以					可以有多个				允许 不推荐


外键：
	1. 要求在从表设置外键关系
    2. 从表的外键列的类型和主表的关联列的类型要求一致或兼容，名称无要求
    3. 主表的关联列必须是一个key （一般是主键或唯一）
    4. 插入数据时，先插入主表再插入从表，删除数据时先删除从表再删除主表
    
可以为一个数据类型添加多个约束，只需用空格隔开  eg id int primary key not null
*/

#一。 创建表时添加约束
#1. 添加列级约束
/*
语法：在字段名和类型后边直接追加即可 只支持 默认 非空 主键 唯一
*/
create database students;
use students;
create table stuinfo(
	id int primary key, -- 主键
    stuname varchar(20) not null, -- 非空
    gender char(1) check(gender='男' or gender='女'), -- 检查
    seat int unique, -- 唯一
    age int default 18, -- 默认约束
    majorid int references major(id) -- 外键
);
desc stuinfo;

create table major(
	id int primary key,
    majorname varchar(20)
);

#查看stuifo表中所有的索引
show index from stuinfo;


#2. 添加表级约束
/*
在各个字段的最下面
[constraint 约束名] 约束类型（字段名）
*/

drop table if exists stuinfo;
create table stuinfo(
	id int,
    stuname varchar(20),
    gender char(1),
    seat int,
    majorid int,
    
    CONSTRAINT pk primary key(id),
    CONSTRAINT uq unique(seat),
    CONSTRAINT ck check(gender='男' or gender = '女'),
	CONSTRAINT fk_stuinfo_major foreign key(majorid) references major(id)
);
show index from stuinfo;

#通用写法:
create table if not exists stuinfo(
	id int primary key,
    stuname varchar(20) not null,
    sex char(1),
    age int unique,
    seat int unique,
    majorid int,
    constraint fk_stuinfo_major foreign key(majorid) references major(id)
    
);


show databases;
select database();
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

#二。修改表时添加约束
/*
1. 添加列级约束
alter table 表名 modify column 字段名 字段类型 新约束
2. 添加表级约束
alter table 表名 add [constraint 约束名] 约束类型(字段名) 【外键的引用】
*/

drop table if exists stuinfo;
create table stuinfo(
	id int,
    stuname varchar(20),
    gender char(1),
    seat int,
    majorid int,
    age int
);
use students;
#1. 添加非空约束
alter table stuinfo modify column stuname varchar(20) not null;
#2. 添加默认约束
alter table stuinfo modify column age int default 18;
#3. 添加主键
alter table stuinfo modify column id int PRIMARY key; -- 列级约束
alter table stuinfo add PRIMARY KEY(id); -- 表级约束
#4. 添加唯一
alter table stuinfo modify column seat int unique;
alter table stuinfo add unique(seat);
#5. 添加外键
alter table stuinfo add CONSTRAINT fk_stuinfo_major foreign key(majorid) references major(id);


#三。 修改表时删除约束
#1. 删除非空约束
desc stuinfo;
show index from stuinfo;
alter table stuinfo modify column stuname varchar(20) null;
#删除默认约束
alter table stuinfo modify column age int;
#删除主键
alter table stuinfo drop PRIMARY KEY;
#删除唯一
alter table stuinfo drop index seat;
#删除外键
alter table stuinfo drop foreign key fk_stuinfo_major;

#练习题
alter table emp2 modify column id int primary key;
alter table emp2 add constraint my_emp_id_pk PRIMARY KEY;
alter table dept2 modify column id primary key;
alter table emp2 add column dept_id int;
alter table emp2 add constraint fk_emp2_dept2 foreign key (dept_id) references dept2(id);

# 			位置				支持的约束类型					是否可以起约束名
# 列级约束		列的后面			语法都支持，但外键没效果		不可以
# 表级约束		所有列的下面		默认和非空不支持，其他支持		可以（主键没效果

#标识列
/*
又称为自增长列
含义： 可以不用手动插入值，系统提供默认的序列值，默认从1 开始 并且会自己自动+1

特点：
1. 标识列必须和主键一起搭配吗？ 不一定 但是需要是可以key
2. 一个表中可以有多少个标识列？ 最多一个
3. 标识列的类型有没有限制？ 只能是数值型（int float double）
4. 标识列可以通过set auto_increment_increment=1; 设置步长
   也可以通过手动插入值设置起始值

*/
#一。创建表时设置标识列
drop table if exists tab_identity;
create table tab_identity(
	id int primary key AUTO_INCREMENT,
    name varchar(20)
	
);
truncate table tab_identity;
insert into tab_identity(id, name) values(null, 'john');
insert into tab_identity(name) values('lucy');

select * from tab_identity;

show variables like '%auto_increment%'; 
-- 通过设置变量设置起始值 步长 但是mysql中起始值不可以更改 步长可以

set auto_increment_increment=1;

#手动插入一个值 然后每次加一 就可以实现从一个特定的编号开始
insert into tab_identity(id, name) values(10, 'john');
insert into tab_identity(id, name) values(null, 'john');

#二。修改表时设置标识列
drop table if exists tab_identity;
create table tab_identity(
	id int primary key,
    name varchar(20),
    seat int
);
alter table tab_identity modify column id int auto_increment;
show index from tab_identity;

#修改表时删除标识列
alter table tab_identity modify column id int;




