-- DML （data manipulate language）--数据操纵语言
-- 插入  insert
-- 修改	  update
-- 删除  delete

-- 一。 插入语句
-- 语法：
-- insert into 表名 (列名,...) values(值1,...)；

#1. 插入的值的类型与列的类型一致或兼容
use test;
insert into beauty(id, name, sex, borndate, phone, photo, boyfriend_id)
values(13, '唐艺昕', '女', '1990-4-23', '1898888888', null, 2);

select * from beauty;

#2. 不可以为null的列必须插入值,可以为null的列如何插入值
-- 如果不想插入
-- 方式1. 在values中填写null
-- 方式2.在insert中不加该列，则在下边values就业不用写了


#3.列的顺序是否可以调换
insert into beauty(name,sex,id,phone)
values('蒋欣','女','14','110');
select * from beauty; -- 没写的部分会用默认值（null）来填充

#4. 列数和值的个数必须一致

#5. 可以省略列名，则默认为所有列，并且列的顺序和表中列的顺序是一致的
insert into beauty
values('18','张飞','男',null,'119',null,'1'); -- 默认值可以自己设置
select * from beauty;


#方式2 另一种插入的方法
-- insert into 表名
-- set 列名=值,列明=值,...

insert into beauty
set id=19,name='刘涛',phone='999';

-- 两种方式大PK
-- 1. 方式1 支持插入多行 方式2不支持
-- insert into
-- values(),(),()...;

-- 2. 方式1支持子查询，方式2也不支持
insert into beauty(id, name, phone)
select 26, '宋茜', '118';-- 也可以加where条件语句

#二。修改语句
-- 1. 修改单表记录
-- 语法：	
-- update 表名	1
-- set 列=新值（字符和日期型要加‘’），列=值...	3
-- where 筛选条件;	2
-- 1. 修改单表中的记录 重点
-- 2. 修改多表中的记录 （级联更新） 补充语法

-- 2. 修改多表记录
-- sql92语法
-- update 表1 别名， 表2， 别名
-- set 列=值，...
-- where 连接条件
-- and 筛选条件；

-- sql99语法
-- update 表1 别名
-- 连接类型 inner、left、right 表2 别名
-- on 连接条件
-- set列=值
-- where 筛选条件；

	

#1.修改beauty表中姓唐的人的电话为138
SET SQL_SAFE_UPDATES = 0; -- 缺少这一句无法更改某些值 比如下边的唐%
update beauty
set phone = '138555'
where name like '唐%';
select * from beauty;
#案例2：boys表中id号为2的名称为zhangfei 
update boys set boyname = '张飞', usercp = 10
where id=2;


#2. 修改多表的记录
#案例1. 修改张无忌的女朋友的手机号为114
update boys bo
inner join beauty b on bo.id=b.boyfriend_id
set b.phone='114'
where bo.boyname='张无忌';

#案例2 修改没有男朋友的女神的男朋友编号都为2
update beauty b
left join boys bo on b.boyfriend_id=bo.id
set boyfriend_id='2'
where b.boyfriend_id is null;


#三。删除语句
-- 方式1. delete 一删除就是一整行
-- 1.单表的删除 （重点）
-- delete from 表名 where 筛选条件
-- 2.多表的删除 （补充）
-- sql92语法
-- delete （这里要删除谁就写谁的别名）
-- from 表1 别名，表2 别名
-- where 连接条件
-- and 筛选条件

-- sql99语法
-- delete  （这里要删除谁就写谁的别名）
-- from 表1 别名
-- inner、left、right 表2 别名 on 连接条件
-- where 筛选条件；
-- 方式2. truncate
-- 语法：truncate table 表名；不能加where条件

#方式1：delete
#单表删除
#案例1：删除手机编号最后一位为9的女神信息
delete from beauty
where phone like '%9';

#2. 多表的删除
#删除张无忌的女朋友的信息
delete b
from beauty b
inner join boys bo on b.boyfriend_id=bo.id
where bo.boyname = '张无忌';

#删除黄晓明的信息以及他女朋友的信息  指教两个表都删除了
delete b,bo
from beauty b
inner join boys bo on b.boyfriend_id=bo.id
where bo.boyName='黄晓';

#方式2 truncate语句
#案例：将魅力值大于100 的人删除 无法实现因为无法驾驶条件
-- truncate table boys;

-- delete pk truncate （经典面试题）
-- 1. delete可以加where条件 truncate不可以加
-- 2. 使用truncate删除效率高很多
-- 3. 加入要删除的表中有自增长列，如果用delete删除后在插入数据，自增长列的值从断点开始
-- 而truncate删除后，再插入数据，自增长列的值从1开始
-- 4. truncate删除没有返回值，delete删除有返回值，如果执行完sql需要返回受影响的行数 则用delete
-- 5. truncate删除不能回滚，而delete删除可以回滚

select * from boys;
delete from boys;
truncate table boys;
insert into boys (boyName,userCP)
values('张飞', 100), ('eric', 900);

-- desc beauty; -- 查看表结构

-- update beauty
-- set last_name = 'drex' where id=3;


-- update employees
-- set salary = 1000 where salary<900;

# delete  u,e
# from user U
# join my_employees e on u.userid = e.userid
# where u.userid = 'Bbiri';

-- 删除所有数据 结果显示列名而没数据 
# delete from my_employees;
# delete from users;

-- 删除表 结果表整个删除
# truncate my_employees;
# truncate users;




