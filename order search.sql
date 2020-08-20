#进阶三 排序查询
/*
语法：
	select 查询列表
    from 表
    【where 筛选条件】
    order by 排序查询 【asc 升序 或者desc 降序】

特点：
	1. 如果不写asc默认是升序
    2. order by子句中可以支持单个字段 多个字段 表达式 函数 别名
    3. order by子句一般放在查询语句的最后，除了limit子句，其他都是放在order by的前边

*/
use myemployees; 
select * from employees;  

#查询员工信息 工资从高到低排序
select * from employees order by salary desc;
#其中 asc可以省略
select * from employees order by salary;

#查询部门编号大于等于90的员工信息，按入职时间的先后排序
#按年薪高低显示员工信息（按表达式）
select *,salary*12*(1+ifnull(commission_pct,0)) as nianxin from employees
where department_id>=90
order by salary*12*(1+ifnull(commission_pct,0)) desc;

#案例4: 按年薪高低显示员工信息和年薪（按别名排序）
select *,salary*12*(1+ifnull(commission_pct,0)) as nianxin from employees
order by nianxin desc;

#案例5: 查询姓名的字节长度进行排序 显示员工的姓名和工资(按函数排序)
select LENGTH(last_name) as zijiechangdu, last_name, salary
FROM employees
ORDER BY LENGTH(last_name) desc;

#案例6:查询员工信息要求先按工资排序再按员工编号排序[按多个字段排序]
#在工资相同的情况下，员工编号从高到低排序
SELECT * FROM employees
ORDER by salary, employee_id desc;

#测试
SELECT last_name,department_id,salary*12*(1+ifnull(commission_pct,0)) as nianxin
FROM employees
ORDER BY nianxin DESC, last_name;


SELECT last_name, salary FROM employees
WHERE salary<8000 OR salary>17000
#WHERE salary NOT BETWEEN 8000 AND 17000
ORDER BY salary DESC;


SELECT *,LENGTH(email) FROM employees
WHERE email LIKE '%e%'
ORDER BY LENGTH(email) DESC, department_id ASC;	








