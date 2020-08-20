#进阶2: 条件查询
/*
语法： select 查询列表 from 表名 where 筛选条件；
顺序： 表名--筛选--查询
分类： 
1. 按条件表达式筛选：
   条件运算符：> < = != <>(不等于) >= <=
2. 按逻辑表达式筛选
   逻辑运算符：&& || ! 
   and or not (推荐使用)
   主要用于连接条件表达式
3. 模糊查询
   like
   between and
   in
   is null
*/

#1. 按条件表达式筛选
#案例1。 查询工资大于12000的员工信息

SELECT 
  *
FROM
  employees
WHERE 
  salary>12000;
  
#案例2: 部门编号不等于90号的员工名和部门编号
SELECT
  first_name, 
  department_id
FROM
  employees
WHERE
  department_id<>90;
  
  
#2. 按逻辑表达式筛选
#案例1. 工资在一万到两万之间的员工的员工名，工资以及奖金
SELECT
 last_name,
 salary,
 commission_pct
FROM
 employees
WHERE
 salary>=10000 AND salary<=20000;

#查询部门编号不在90-110之间或者工资高于15000的员工信息
SELECT
 *
FROM
 employees
WHERE 
 NOT(department_id>=90 AND department_id<=110) OR salary>15000;

#三。模糊查询
/*
like
特点：
1. 一般和通配符搭配使用
	通配符：
	% 任意多个字符，包含0个字符
    _ 任意单个字符
    
between and
1. 可以提高简介度
2. 包含区间值
3. 两个临界值不能调换顺序大于等于左边小于等于右边

in
1. 用于判断某字段的值是否属于in列表中的某一项
特点：
使用in做筛选比使用or提高了语句简洁度
in列表的值类型必须统一或兼容
不支持通配符

is null | is not null
=和<>不能判断null值
*/

#案例1. 查询员工名中包含字符a的员工信息
SELECT * FROM employees WHERE last_name like '%a%';
#字符都需要用单引号扩起来 ，百分号在这里以为着通配符

#案例2. 员工名中第三个字符为e 第五个字符为a的员工名字和工资
SELECT 
	first_name, 
    salary 
FROM 
	employees 
WHERE 
	first_name 
LIKE 
	'__e_a%';
    
#案例3. 查询员工名中第二个字符为_的员工名
SELECT last_name FROM employees WHERE last_name LIKE '_\_%';
#转译符号\也可以在mysql中进行使用
#自定义转译符号
SELECT last_name FROM employees WHERE last_name LIKE '_$_%' ESCAPE '$';

#2. between and 在什么什么之间
#案例1. 查询员工编号在100到120之间的所有员工信息
SELECT * FROM employees WHERE employee_id>=100 AND employee_id<=120;
SELECT * FROM employees WHERE employee_id BETWEEN 100 AND 120;

#3. in
#案例： 查询员工的工种编号是 it_prog, ad_vp, AD_PRES 中的一个的员工名和工种编号
SELECT employee_id, job_id FROM employees 
#WHERE job_id = 'IT_PROG' OR  job_id = 'AD_VP' OR job_id = 'AD_PRES';
WHERE job_id IN ('IT_PROG', 'AD_VP', 'AD_PRES');

#4. 查询没有奖金的员工名和奖金率
SELECT last_name, commission_pct FROM employees
WHERE commission_pct IS NOT NULL; #等于号不能直接接null 需要用到 is null

#安全等于. <=>. 也可以用于判断null 作用相当于 is
SELECT last_name, commission_pct FROM employees
WHERE commission_pct <=> NULL;

#案例2:查询工资为一万2的员工信息
SELECT last_name, commission_pct FROM employees
WHERE salary <=> 12000;

#is null pk <=>
#is null 仅仅可以用于判断null值
#<=> 既可以用于判断null 又可以用于判断普通数值 但是可读性较低

SELECT
	first_name, 
    last_name, 
    department_id, 
    salary*12*(1+IFNULL(commission_pct, 0)) AS nianxin
FROM
	employees;
    
SELECT
	last_name,
    salary
FROM 
	employees
WHERE
	salary>12000;
    
SELECT
	first_name,
    last_name,
    employee_id,
    department_id,
    salary*12*(1+IFNULL(commission_pct, 0)) AS nianxin
FROM
	employees
WHERE employee_id=176;

SELECT
	first_name,
    salary
FROM
	employees
WHERE
	salary<5000 OR salary>12000;
    
SELECT
	first_name,
    department_id
FROM
	employees
WHERE
	department_id=20 OR department_id=50;
    
SELECT
	concat(first_name, ' ' ,last_name) AS xingming,
    job_id
FROM
	employees
WHERE
	manager_id IS NULL;
    
SELECT
	concat(first_name, ' ', last_name) AS xingming,
    salary,
    commission_pct
FROM
	employees
WHERE
	commission_pct IS NOT NULL;
    
SELECT
	concat(first_name, ' ', last_name) AS xingming
FROM
	employees
WHERE
	first_name 
lIKE
	'__a%';
    
SELECT
	concat(first_name, ' ', last_name) AS xingming
FROM
	employees
WHERE
	first_name lIKE '%a%'
OR
	first_name LIKE '%e%';
    
SELECT * FROM employees
WHERE first_name lIKE '%e';

SELECT
	concat(first_name, ' ', last_name) AS xingming,
    job_id,
    department_id
FROM
	employees
WHERE 
	department_id BETWEEN 80 AND 100;
    
SELECT
	CONCAT(first_name, ' ', last_name) AS xingming,
    job_id
FROM
	employees
WHERE
	manager_id IN ('100', '101', '110');
    
    
    
SELECT
	salary,
    last_name
FROM employees
WHERE salary<18000 AND commission_pct IS NULL;

SELECT * FROM employees
WHERE NOT job_id LIKE '%IT%'
OR salary=12000;

DESC departments;

#查询表中涉及到了哪些位置编号
SELECT distinct location_id from departments;

#经典面试题p37：如果判断的字段有null 则不一样 总归有一个字段不为null所以连起来用or是可以的

#！！！复习！！！
/*
数据库的好处
1. 可以持久化数据到本地
2. 结构化查询

数据库的常见概念
1. db： 数据库，存储数据的容器
2. dbms：数据库管理系统 又称为数据库软件/数据库产品 用于创建和管理db
3. sql：结构化查询语言，用于和数据库通讯的语言，不是某个数据库软件特有的
   几乎所有的主流的数据库软件都使用这个语言
   
数据库存储数据的特点
1. 数据存放在表中，表放在库中
2. 多张表，唯一的表名
3. 表中有一个或多个列，又称为字段，相当于java中的属性
4. 表中的每一行数据相当于java中的对象

常见的数据库管理系统
mysql
oracle
db2
sqlserver
*/



