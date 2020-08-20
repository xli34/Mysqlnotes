#TCL语言
/*
transaction control language 事务控制语言
事务：
一个或一组sql语句组成一个执行单元，这个执行单元要么全部执行要么全部不执行，在这个单用中，
每个sql语句都是相互依赖的

案例：转账
张三丰 1000
郭襄  1000

update biao set zhangsanfeng的余额=500 where name = 'zhang'
update biao set guoxiang的余额=1500 where name = 'guoxiang'
事务主要用于解决此类事件
要么全部成功要么全部失败

mysql中的存储引擎：数据的不通存储技术/表类型
不是所有的存储引擎都支持事务
innodb支持事务 mysam  memory不支持

事务的acid属性
1. 原子性（atomicity）
原子性是指事务是一个不可分割的工作单位，事务中的操作要么都发生要么都不发生
2. 一致性（consistency）
事务必须使数据库从一个一致性状态变换到另一个一致性状态
3. 隔离性（isolation）
事务的隔离性是指一个事务的执行不能被其他事务干扰，即一个事务内部的操作以及使用的数据
对并发的其他事务是隔离的，并发执行的各个事务之间不能互相干扰 （需要注意隔离级别）
4. 持久性（durability）
持久性是指一个事务一旦被提交，它对数据库中数据的改变就是永久性的，，接下来的其他操作和数据库的故障不应该对其
有任何的影响

事务的创建
隐式事务：事务没有明显的开启和结束标识
比如insert update delete语句
delete from biao where id=1;

显式事务：事务具有明显的开启和结束的标记
前提：必须先设置自动提交功能为禁用
show variables like 'autocommit';
set autocommit=0;

步骤1：开启事务
set autocommit=0;
start transaction; -- 这条可选
步骤2：编写事务中的sql语句（select insert update delete）增删改查
语句1；
语句2；
...

步骤3：结束事务
commit；提交事务
rollback；回滚事务


开启事务的语句；
update biao set zhangsanfeng的余额=500 where name = 'zhang'
update biao set guoxiang的余额=1500 where name = 'guoxiang'
结束事务的语句；
*/
Show engines;


use test;
drop table if exists account;
create table account(
	id int primary key auto_increment,
    username varchar(20),
    balance double
);
insert into account(username, balance)
values('张无忌',1000),('赵敏','1000');

select * from account;

#演示事务的使用步骤
#开启事务
set autocommit=0;
start transaction;
#编写一组事务的语句
update account set balance = 1500 where username = '张无忌';
update account set balance = 500 where username = '赵敏';
#结束事务  
rollback;-- 回滚，大概意思就是运行了但是没提交上去 所以结果不会变
#commit; -- 提交 运行完并且提交 所以运行的结果都会显示

#当 同时运行多个事务，当这些事务访问数据库中相同的数据时，如果没有采取必要的隔离机制，就会导致各种并发问题
/*
1. 脏读：对于两个事务T1和T2，T1读取了已经被T2更新但还//没有被提交//的字段之后，若T2回滚，T1读取的内容就是临时且无效的
2. 不可重复读：对于两个事务T1和T2，T1读取了一个字段，然后T2//更新//了该字段之后，T1再次读取同一个字段，值就不一样了
3. 幻读：T1读取了一个字段然后T2在该表中//插入//了一些新的行，如果T1再读就会多几行 

可以通过设置事务隔离级别来避免以上问题
oracle支持两种：READ COMMITED  SERIALIZABLE
Mysql支持四种： 默认的事务隔离级别为 REPEARABLE READ

隔离级别设置的高了 效率会受到影响
事务隔离级别是全局变量

事务的隔离级别
read uncommitted： 出现脏读 幻读 不可重复读
read committed： 不出现脏读 其他出现
repeatable read ：不出现脏读 不出现不可重复读 出现幻读
serializable： 三个都不出现
mysql中默认第三个隔离级别：repeatable read
oracle中默认 read committed

select transaction_isolation;  查看当前隔离级别
set session|global transaction isolation level 隔离级别; 更改隔离级别
*/

#delete和truncate在事务中的区别
#演示delete
use test;
set autocommit=0;
start transaction;
delete from account;
rollback;

#演示truncate
set autocommit=0;
start transaction;
truncate table account;
rollback;

-- delete语句支持回滚 truncate语句不支持回滚


-- savepoint 节点名，设置保存点
#3. 演示savepoint的使用
set autocommit=0;
start TRANSACTION;
delete from account where id=25;
savepoint a; -- 设置保存点
delete from account where id=28;
rollback to a;  -- 回滚到设置的断点处；
select * from account;

#视图
/*
含义：虚拟的表，和普通的表一样使用
mysql 5.1版本出现的新特征你 是通过表的动态生成的数据
根据需要临时组建的虚拟表，只保持了sql逻辑，不保存查询结果
一个复杂查询多次使用就不妨将它保存成为一个视图
应用场景： 多个地方用到同样的查询结果，语句比较复杂的情况
*/

#案例，查询姓张的学生名和专业名
select stuname, majorname
from stuinfo s
inner join major m on s.`majorid`=m.`id`
where s.`stuname` like '%张';

create view v1
as 
select stuname, majorname
from stuinfo s
inner join major m on s.`majorid`=m.`id`;

select * from v1 where stuname like '张%';

#一。创建视图
# create view 视图名
# as
# 查询语句；
use myemployees;
#查询邮箱中包含a字符的员工名 部门名和工种信息
create view myv1
as
select last_name,department_name, job_title
from employees e
join departments d on e.department_id = d.department_id
join jobs j on j.job_id= e.job_id;

select * from myv1 where last_name like '%a%';

#查询各部门平均工资级别
drop view myv2;
create view myv2 as
select avg(salary) ag, department_id from employees
group by department_id;
select * from myv2;
select department_id, myv2.`ag`, g.grade_level
from myv2
join job_grades g
on myv2.`ag` between g.`lowest_sal` and g.`highest_sal`;


-- 查询平均工资最低的部门信息
select * from myv2;
select * from departments
where department_id = (
	select department_id from myv2
	where ag = (select min(ag) from myv2)
);
-- 查询平均工资最低的部门信息
create view myv3 as
select d.department_name, myv2.ag
from departments d 
join myv2
on d.department_id = myv2.department_id;

select * from myv3
where ag = (
	select min(ag) from myv3
);



#视图的好处
# 1. sql语句的重用
# 2. 简化了复杂的sql操作
# 3. 保护数据提高安全性：相当于封装函数，使得视图和原始的数据相分离

#二。 视图的修改
/*
create or replace view 视图名
as
查询语句

#方式2
alter view 视图名 as 查询语句
*/


#视图的删除
drop view 视图名,视图名...;

#视图的查看
desc myv3;
show create view myv3;


create or replace view emp_v1 as
select last_name, salary, email from employees
where phone_number like '011%';

create or replace view emp_v2 as
SELECT * from departments
where department_id in (
	select department_id from employees
    group by department_id
    having max(salary)>12000
);

select * from emp_v2;


#视图的更新 更改七中的数据
create or replace view myv1
as
select last_name, email
from employees;

select * from myv1;
select * from employees;
#插入
insert into myv1 values('zhang', 'zhang@qq.com'); -- 原始表也更新了

#修改
update myv1 set last_name = '张无忌' where last_name = 'zhang'; -- 也影响原始表

#删除
delete from myv1 where last_name = '张无忌';

-- 正因为如此 常常对视图添加权限 只允许读 不允许更新
-- 一般视图中保留的数据不允许更改
-- 具备以下特点的视图不允许更新
# 1. 包含以下关键字的sql语句： 分组函数 distinct group by having union union all
# 2. 常量视图
# 3. select 中包含子查询
# 4. join 连接等
# 5. from 一个不能更新的视图
# 6. where 子句的子查询引用了from子句中的表


# #视图和表的对比		语法			ALTER是否实际占用物理空间			使用
# 视图				create view			只保存sql逻辑					增删改查，一般不能增删改
# 表					create table 		保存了数据					增删改查


#测试题 p147
use test;
drop table book;
create table book(
	bid int primary key,
    bname varchar(20) unique not null,
    price float default 10,
    btypeID int,
    foreign key(btypeid) references bookType(id)
);

create table bookType(
	id int,
    name varchar(20)
);

set autocommit=0;
insert into book values
(1, 'laoren', 15, 1);
commit;

select * from book;

create or replace view myv as 
select b.bname, bt.name
from book b
join bookType bt
on b.btypeid = bt.id
where b.price>100;


alter view myv as
select b.bname, bt.name
from book b
join bookType bt
on b.btypeid = bt.id
where b.price>90 and b.price<120;

drop view myv;

# 包含以下特点的视图不允许更新
# 1. group by  distinct  having  union
# 2. join
# 3. 常量视图
# 4. where 后的子查询用到了from中的表
# 5. 用哪个到了不可更新的视图


#级联删除
select database();
alter table stuinfo add constraint fk_stu_major foreign key(majorid) REFERENCES major(id) on delete cascade;
#删除专业表的3号专业
delete from major where id=3;

#级联置空
 alter table stuinfo add constraint fk_stu_major foreign key(majorid) REFERENCES major(id) on delete set null;

-- alter table name modify column xx type constraint
-- 添加外键
-- alter table 表名 add foreign key (字段名) references 主表 (被引用列);
-- alter table 表名 drop foreign key 约束名;

#自增长列  标识列
# 1. 不用手动插入值，可以自动提供序列值 默认从1开始步长为1
# auto_increment_increment
# 如果要更改起始值：手动插入值
# 如果更改步长 更改系统变量
# set auto_increment_increment=值;
# 2. 一个表至多一个自增长列
# 3. 自增长列只能支持数值型
# 4. 自增长列必须为一个key
# create table biao (
# 	字段名 字段类型 约束 auto_increment
# );

# alter table biao modify column 字段名 字段类型 约束 auto_increment
# alter table biao modify column 字段名 字段类型 约束






