-- 二，分组函数
-- 功能：用作统计使用，又称为聚合函数，统计函数或组函数
-- 分类：
-- sum
-- avg
-- max
-- min
-- count：计算个数

-- 1. sum avg 一般只用于处理数字
-- count max min 可以处理任意类型
-- 2. 以上分组函数都忽略null值
-- 3. 可以和distinct搭配实现去重的运算
-- 4. count函数的单独介绍
-- 5. 和分组函数一同查询的字段要求是group by 后的字段；


-- 1.简单使用
use myemployees;
SELECT sum(salary) from employees;
select avg(salary) from employees;
select count(salary) from employees;
select max(salary) from employees;

select sum(salary) he, round(avg(salary),2) pingjun from employees;

-- 2.参数支持哪些类型
select sum(last_name), avg(last_name) from employees;-- 一般只支持数字

select max(last_name), min(last_name) from employees;-- 这个支持 因为名字可以按字母排序

select count(commission_pct) from employees;

-- 3. 是否忽略null
-- avg函数在有null存在的情况下 直接忽略null值，不用做分母
-- max和min也都忽略null 不做计算
-- count：计算非空的值的个数 不包括null
-- 总结；以上的分组函数都忽略null值

-- 4. 和distinct进行搭配
select sum(distinct salary), sum(salary) from employees;
select count(distinct salary), count(salary) from employees;
-- 其他也都支持和distinct的组合

-- 5. count函数的详细介绍 
select count(*) FROM employees; -- 一般用于统计有多少行 只要有一个没有null就+1 所以得到行数
select count(1) from employees; -- 等于新建一个列 每一行的值都是1 然后统计多少个1 还是等于行数

-- 效率: INNODB
-- 在myisam的存储引擎下，count(*) 效率最高
-- 在innodb的存储引擎下，count(1)和count(*)差不多 比count(字段)要高一些

-- 6. 和分组函数一起查询的字段有限制
select avg(employee_id), last_name from employees; -- 报错 无法执行

select max(salary) max_sal, min(salary), round(avg(salary),2), sum(salary) from employees;

select datediff(max(hiredate), min(hiredate)) from employees; -- datediff函数先大后小

select count(*) from employees where department_id>90; 

#进阶5：分组查询
-- 引入：查询每个部门的平均工资
-- select column, group_function(column)
-- from
-- where 条件在groupby之前
-- group by 分组的列表
-- order by

-- 注意：查询列表比较特殊，要求是分组函数和group by后出现的字段

-- 特点：
-- 	1. 分组查询中的筛选条件分为两类
-- 		分组前筛选 数据源是原始表          	 放在group by的前边 用where
--         分组后筛选 数据源是分组后的结果集		 放在group by的后边 用having
--         分组函数作为条件一定放在having子句中
--         能用分组前筛选的 优先考虑使用
--  2. group by支持单个字段分组也支持多个字段分组（多个字段之间用逗号隔开没有顺序要求）
--  3. 也可以添加排序，位置放在整个分组查询的最后
        
select avg(salary) from employees;

-- 查询每个工种的最高工资
select max(salary), job_id
from employees
group by job_id;

-- 查询每个位置上的部门个数
select count(*), location_id
from departments
group by location_id;

-- 添加筛选条件
-- 查询邮箱中包含a字符的每个部门的平均工资
select avg(salary), department_id
from employees
where email like '%a%'
group by department_id;

-- 查询有奖金的每个领导手下员工的最高工资
select max(salary), manager_id
from employees
where commission_pct IS NOT NULL
group by manager_id;

-- 添加复杂的筛选条件

-- 案例1：查询哪个部门的员工个数大于2 !!!!!!!! where放在group by之前 、having 放在之后
-- 1. 查询每个部门的员工个数
-- 2. 根据1的结果进行筛选 得到哪个部门的员工个数大于2
select count(*), department_id
from employees
group by department_id
having count(*)>2;

-- 查询每个工种有奖金的员工的最高工资并且最高工资大于12000的工种编号和最高工资
select max(salary), job_id
from employees
where commission_pct is not null
group by job_id
having max(salary)>12000;

-- 查询领导编号大于102的每个领导手下的最低工资大于5000的领导编号
select min(salary), manager_id
from employees
where manager_id>102
group by manager_id
having min(salary)>5000;

-- 按表达式或函数分组
-- 按员工姓名的长度分组，查询每一组的员工个数 筛选员工个数》5的有哪些
#1. 查询每个长度的员工个数
select count(*), LENGTH(last_name) len_name
from employees
group by LENGTH(last_name);
-- #2. 添加筛选条件
select count(*) c, LENGTH(last_name) len_name
from employees
group by len_name
having c>5;

#按多个字段分组
#案例：查询每个部门每个工种的员工的平均工资 所分的组顺序可以改变
select avg(salary), department_id, job_id
from employees
group by department_id, job_id;

#添加排序
#案例：查询每个部门每个工种的员工的平均工资 并且按平均工资的高低排名
select avg(salary), department_id, job_id
from employees
where department_id is not null
group by department_id, job_id
having avg(salary)>10000
order by avg(salary) desc;

-- 练习部分
select max(salary), min(salary), avg(salary), sum(salary), job_id
from employees
group by job_id
order by job_id;

select max(salary)-min(salary) as difference from employees;

select min(salary), manager_id
from employees
where manager_id is not null
group by manager_id
having min(salary)>=6000 ;

select department_id, count(*), round(avg(salary),2) a
from employees
group by department_id
order by a desc;

select count(*), job_id
from employees
where job_id is not null
group by job_id;
