#进阶6：连接查询
-- 含义：又称为多表查询，当我们要查询的字段涉及到多个表时，就会用到多表查询
-- 笛卡尔乘积现象：表1有m行，表2有n行，结果=m*n行
-- 发生原因：没有有效的连接条件
-- 如何避免：添加连接条件

-- 分类
-- 按年代分类：sql92标准：仅仅支持内连接；sql99标准（推荐使用，支持内连接，左外，右外，交叉连接）
-- 按功能分类：内连接：等值连接，非等值连接，自连接，
-- 		  外连接：左外连接，右外连接，全外连接
--           交叉连接
use test;
select * from  beauty;

select name, boyname from beauty, boys; 
-- 结果不正确，等于用第一个表逐个匹配第二个表数据，所有行实现完全连接
-- 被称为笛卡尔集的错误情况

select name, boyname from beauty, boys
where beauty.boyfriend_id=boys.id;


#一，sql92标准
#1. 等值连接
-- ①多表等值连接的结果为多表的交集部分
-- ②n表连接至少需要n-1个连接条件
-- ③多表的顺序没有要求
-- ④一般需要为表起别名 不然太繁琐
-- ⑤可以搭配前边介绍的所有查询子句。比如排序 分组 筛选


-- 案例1：查询女神名和对应的男神名
select name, boyname 
from beauty, boys
where beauty.boyfriend_id=boys.id;

-- 案例2：查询员工名和对应的部门名
use myemployees;
select last_name,department_name
from employees,departments
where employees.department_id=departments.department_id;

#2. 为表起别名
-- 提高语句的简介度
-- 区分多个重名的字段
#注意：如果为表起了别名，则查询的字段就不能使用原来的表名去限定

-- 查询员工名，工种号，工种名
select e.last_name, e.job_id, j.job_title
from employees as e,jobs as j
where e.`job_id` = j.`job_id`;


-- 3.两个表的顺序是否可以调换
select e.last_name, e.job_id, j.job_title
from jobs as j, employees as e
where e.`job_id` = j.`job_id`;

-- 4.可以加筛选
-- 案例1：查询有奖金的员工名和部门名
select e.last_name, d.department_id, commission_pct
from employees e, departments d
where e.department_id=d.department_id
and e.commission_pct is not null;

-- 案例2：查询城市名中第二个字符为o的对应的部门名和城市名
select d.department_name,l.city
from departments d, locations l
where d.location_id = l.location_id
and city like '_o%';

#5. 增加分组
-- 案例1：查询一下每个城市的部门个数
select count(*) geshu, city
from departments d, locations l
where d.location_id = l.location_id
group by city;

#案例2：查询有奖金的每个部门的部门名和部门的领导编号和该部门的最低工资
select d.department_name, d.manager_id, min(salary)
from employees e, departments d
where d.department_id = e.department_id
and commission_pct is not null
group by department_name, d.manager_id;


#6. 添加排序
-- 案例： 查询每个工种的工种名和员工的个数并且按员工个数降序
select job_title, count(*) c
from employees e, jobs j
where e.job_id = j.job_id
group by job_title
order by c desc;

#7.实现三表连接
-- 查询员工名部门名和所在地城市
select last_name, department_name, city
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id
and city like 's%'
order by department_name desc;

#2.非等值连接
#案例1：查询员工的工资和工资级别
-- drop table job_grades;

-- CREATE TABLE job_grades
-- (grade_level VARCHAR(3),
-- lowest_sal INT,
-- highest_sal INT);

-- INSERT INTO job_grades
-- VALUES ('A',1000,2999);

-- INSERT INTO job_grades
-- VALUES ('B',3000,5999);

-- INSERT INTO job_grades
-- VALUES ('C',6000,9999);

-- INSERT INTO job_grades
-- VALUES ('D',10000,14999);

-- INSERT INTO job_grades
-- VALUES ('E',15000,24999);

-- INSERT INTO job_grades
-- VALUES ('F',25000,40000);

select * from job_grades;

select salary, grade_level
from employees e, job_grades j
where salary between j.lowest_sal and j.highest_sal
and grade_level = 'A';

#3. 自连接 自己连接自己 只涉及自己表
-- 查询员工名 和上级的名字
select e.employee_id, e.last_name, m.employee_id, m.last_name
from employees e, employees m
where e.manager_id = m.employee_id;

##练习题
select max(salary), avg(salary) from employees;

select employee_id, job_id, last_name
from employees
order by department_id desc, salary asc;

select job_id from employees
where job_id like '%a%e%';

-- select s.`name`, g.`name`, r.score
-- from student s, grade g, result r
-- where s.gradeID = g.id
-- and s.id = r.id;

-- select now()
-- select trim('' from '')
-- select substr(str,startindex)
-- select substr(str, startindex, length)

-- concat
-- substr
-- upper
-- lower
-- replace
-- length
-- trim 去前后空格
-- lpad 左填充
-- rpad 右填充
-- instr 获取子串第一次出现的索引

-- ceil 向上取整
-- round
-- mod 取模
-- floor 向下取整
-- truncate 截断
-- rand() 获取随机数  在0-1之间的小数  无线接近于1到不了1

-- now 当前日期加时间
-- year
-- month
-- day
-- date_formate
-- curdate
-- str_to_date 将字符转换成日期
-- curtime 返回当前时间
-- datediff 返回两个日期相差的天数
-- monthname 以英文形式返回月

-- version
-- datebase
-- user
-- password('字符') 自动加密
-- md5() 也是加密


-- select password('wang');
-- select md5('wang');

-- if(条件表达式， 表达式1， 表达式2)

-- case 变量、表达式
-- when 常量 then 值1
-- when 常量 then 值2
-- else 值n
-- end

-- case
-- when 条件1 then 值1
-- else 值n
-- end

-- 分组函数
-- 分类
-- max
-- min
-- avg
-- sum
-- count

-- 特点
-- select max(单个字段) from 表

-- 支持类型不一样
-- 以上分组函数都忽略null
-- 都可以搭配distinct使用
-- select sum（distinct 字段）from 表

-- count（字段）
-- count（*）

-- 和分组函数一同查询的字段 要求是group by 后出现的字段


-- select 分组函数，分组后的字段 from 表
-- where 筛选条件
-- group by 分组的字段  很少用别名
-- having 分组后的筛选   很少用别名
-- order by 排序列表

-- 			关键字		筛选的表		位置   					这个是重点
-- 分组前筛选	where		原始表		group by之前
-- 分组后筛选	having		分组后的结果	group by之后

-- 连接查询
-- 当查询中涉及到了多个表的字段 使用多表连接
-- select 字段1 字段2 
-- from 表1 表2
--  出现笛卡尔乘积：查询多个表妹天剑有效的连接条件 导致多个表实现完全连接
--  如何解决：分析出有效的连接条件

-- sql92语法
-- 1. 等值连接
-- select 查询列表
-- from 表1 ， 表2 
-- where 1.key = 2.key
-- and 筛选条件
-- group by 分组字段
-- having 分组后筛选
-- order by 排序字段

-- 一般需要起别名
-- 多表顺序可以调换
-- n表连接至少需要n-1个连接条件

-- 多表连接只更改where条件 改为非等值条件

-- 自连接： 把表1表2当成两个表 在where条件中提高警惕


-- 练习题 、、很好的复习与多表查询联系、、
select database();
select last_name, e.department_id, department_name
from employees e, departments d
where d.department_id = e.department_id;


select job_id, location_id
from employees e, departments d
where  e.department_id=d.department_id and e.department_id=90;
 

select last_name, department_name, l.location_id, city
from employees e, departments d, locations l
where e.department_id = d.department_id and d.location_id = l.location_id and e.commission_pct is not null;


select e.last_name, job_id, d.department_id, d.department_name
from employees e, departments d, locations l
where e.department_id=d.department_id
and d.location_id=l.location_id
and l.city='Toronto';

select department_name, job_title, min(salary) min_salary
from employees e, departments d, jobs j
where e.department_id=d.department_id
and e.job_id=j.job_id
group by department_name, job_title;


select count(*), country_id
from departments d, locations l
where d.location_id=l.location_id
group by country_id;
-- having count(*)>2;


select e.last_name employees, m.last_name emp, e.manager_id manager
from employees e, employees m
where e.manager_id = m.employee_id;

-- #二。sql99语法
-- select 列表 
-- from 表1 别名 【连接类型】
-- join 表2 别名 
-- on 连接条件
-- where 筛选条件
-- group by
-- having
-- order by

-- 类型
-- 内连接（主要）：inner
-- 外连接（左外和右外）： left （outer） right outer
-- 		全外： full outer
-- 交叉连接 cross

#一。内连接
-- select 列表 
-- from 表1
-- inner join 表2 别名
-- on 连接条件

-- 分类：
-- 等值连接
-- 非等值连接
-- 自连接

-- 特点
-- 可以添加排序分组筛选 其中inner可以省略
-- 筛选条件放在where 后边 连接条件放在on后边 提高了分离性便于阅读
-- inner join 连接和92语法中的等值连接实现的效果是一样的 实现多表交集

-- 1. 等值连接
-- 案例1。  查询员工名 部门名
select last_name, department_name
from employees e
inner join departments d
on e.department_id=d.department_id;


-- 案例2. 添加筛选 查询名字中包含e的员工名和工种名
select last_name, job_title
from employees e
inner join jobs j
on e.job_id=j.job_id
where last_name like '%e%';

-- 案例3. 查询部门个数大于3的城市名和部门个数

select city, count(*)
from locations l
inner join departments d
on l.location_id=d.location_id
group by city
having count(*)>2;


-- 案例4. 查询哪个部门的部门员工个数大于3的部门名和员工个数并按个数降序排序
select department_name, count(*)
from departments d
inner join employees e
on d.department_id=e.department_id
group by department_name
having count(*)>3
order by count(*) desc;


-- 案例5. 查询员工名 部门名 工种名 并按部门名降序排列
select last_name, department_name, job_title
from employees e
inner join departments d on e.department_id=d.department_id
inner join jobs j on e.job_id=j.job_id
order by department_name desc;
-- join 后边的表和from后边的表要有条件进行连接

# 二。 非等值连接
-- 查询员工的工资级别
select salary, grade_level
from employees e
inner join job_grades g
on e.salary between g.lowest_sal and g.highest_sal;


-- 查询每个工资级别的个数大于2的个数 并且按工资级别降序排序
select count(*), grade_level
from employees e
join job_grades g
on e.salary between g.lowest_sal and g.highest_sal
group by grade_level
having count(*)>20
order by grade_level desc;



-- 三. 自连接
#查询：员工的名字，上级的名字
select e.last_name, m.last_name
from employees e
join employees m
on m.employee_id=e.manager_id;

#外连接
-- 主要用于查询一个表有另一个表没有的查询情况
-- 特点：
-- 1. 外连接的查询结果为主表中的全部记录 如果从表中有和他匹配的 显示值 否则显示null
-- 	所以外连接查询的结果为内连接结果加上主表中有而从表中没有的记录
-- 2. 左外连接 （left outer join） left左边的为主表
--    右外连接 right右边的为主表
--    所以左外和右外如果交换主表从表的顺序可以实现同样的效果


#二。查询男朋友不在男神表的女神的名字
use test;
select * from beauty;
select * from boys;
-- 左外
select `name`
from beauty m
left outer join boys b
on m.boyfriend_id=b.id
where m.boyfriend_id not between 1 and 4;

select b.name, bo.*
from beauty b
left outer join boys bo
on b.boyfriend_id=bo.id
where bo.id is null;

#案例 查询哪个部门没有员工     `不好理解`
use myemployees;
select d.*, e.employee_id
from departments d
left outer join employees e
on d.department_id=e.department_id
where e.employee_id is null;

#全外连接  mysql不支持
-- use girls;
-- select b.*, bo.*
-- from beauty b
-- full outer join boys bo
-- on b.boyfriend_id=bo.id;
-- 结果将交集部分显示出来 然后把主有从没有 从有主没有的数据全部显示并且缺少的部分用null连接
-- 全外连接=内连接的结果+表1中有表2没有+表2有表1没有 使用where is not null 显示后边的两部分



#交叉连接   在sql99下 实现笛卡尔乘积用
use test;
select b.*, bo.*
from beauty b
cross join boys bo;

#sql92与sql99 pk
-- 功能上： sql99支持的更多
-- 可读性：sql99实现连接条件和筛选条件分离 可读性较高
-- 内连接查询ab的交集
-- 左外查询得到a独有的一部分和交集部分
-- 右外查询得到b独有的一部分和交集部分
-- 要想单独得到a独有的部分或者b独有的部分 需要在左外或者右外中添加条件
-- 条件为 where b.key is null 和where a.key is null//////让主键列is null
-- 全外连接得到的是ab的全部 用full outer join
-- 若a并b不要a交b，使用全外连接然后加上判断 where a.key is null or b.key is null

select b.id, b.name, bo.*
from beauty b
left join boys bo
on b.boyfriend_id=bo.id
where b.id>3;

use myemployees;
select city
from locations l
left outer join departments d
on l.location_id=d.location_id
where department_id is null;


select e.*, d.department_name
from departments d
left join employees e
on e.department_id=d.department_id
where d.department_name = 'SAL' or d.department_name='IT';





