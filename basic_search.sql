#进阶1: 基础查询
/*
select 查询列表 from 表名；
类似于： system.out.println(需要打印的东西);

特点：
1. 查询列表可以是： 表中的字段/常量值/表达式/函数
2. 查询的结果是一个虚拟的表格
*/
USE myemployees;

#1. 查询表中的单个字段
SELECT last_name From employees;

#2. 查询表中的多个字段
SELECT last_name, salary, email FROM employees;

#3. 查询表中的所有字段 --  双击左边词条可以直接出现
SELECT * FROM employees;
#SELECT `NAME` FROM stuinfo;  用着重号区分字段和关键字，着重号为键盘上数字1左边的按键

#4. 查询常量值 （不区分字符和字符串）
SELECT 100;
SELECT 'john';

#5. 查询表达式
SELECT 100*98;
SELECT 100%98;

#6. 查询函数
SELECT VERSION();

#7. 起别名
/*
1. 便于理解
2. 如果要查询的字段有重名的情况，使用别名可以区分开来
*/
SELECT 100%98 AS 结果;
SELECT last_name AS xing, first_name AS ming FROM employees;

SELECT last_name xing, first_name ming FROM employees;

# 案例： 查询salary 显示的结果为 out put (当别名中出现关键词 用双引号区分)
SELECT salary AS "out put" From employees;

#8. 去重
#案例： 查询员工表中涉及到的所有部门编号
SELECT department_id FROM employees;
SELECT DISTINCT department_id FROM employees;

#9. +号的作用
/*
java中的加号
1. 运算符，两个操作数都为数值型
2. 连接符：只要有一个操作数为字符串

mysql中 的+号
仅仅有一个功能：运算符

eg： SELECT 100+90; 两个操作数都为数值型则做加法运算
SELECT '123'+90;  其中一方为字符型，则会试图将字符型数值转换成数值型
                  如果转换成功，则继续做加法运算
                  如果转换失败则将字符型的数值转换为0
SELECT 'john'+90;

SELECT null+10;    只要其中一方为null 则输出的结果肯定为null；
*/
#instance: 查询员工名和姓 连接成一个字段，并显示为 姓名

SELECT CONCAT('a','b','c') AS jieguo;

#SELECT last_name+first_name AS xingming FROM employees; 这样表达不对
SELECT CONCAT(last_name,first_name) AS xingming FROM employees;

DESC employees;
SELECT * FROM departments;
SELECT DISTINCT job_id FROM employees;

SELECT 
        IFNULL(commission_pct, 0) AS jiangjinlv, 
		commission_pct 
from employees;

SELECT 
   CONCAT(`employee_id`,',',`first_name`,',',`last_name`,',',IFNULL(commission_pct, 0)) AS out_put
FROM 
   employees;