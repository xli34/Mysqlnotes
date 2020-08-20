#进阶7 子查询
-- 含义：出现在其他语句中的select语句 称为子查询或者内查询
-- 可以用于增删改动
-- 外部的查询语句，称为主查询或外查询
-- 子查询语句需要放在小括号内 增加可读性

-- 分类：
-- 按子查询出现的位置进行
-- 	select后面：
-- 		仅仅支持标量子查询
--     from后面：
-- 		支持表子查询
--     where或having后边： ※重点讲※
-- 		支持标量子查询或列子查询/行子查询（较少用
--     exists后面（相关子查询）
-- 		支持表子查询
-- 按功能/结果集的行列数不通
-- 	标量子查询（结果集只有一行一列）
--     列子查询（结果集只有一列多行）
--     行子查询（结果集可以有多行多列）
--     表子查询 （结果集一般为多行多列）


#一。 where或者having后边
-- 标量子查询 单行子查询
-- 列子查询 多行子查询
-- 行子查询（多列多行）
-- 特点：
-- ①子查询都会放在（）内
-- ②子查询一般放在条件的右侧
-- ③标量子查询：一般搭配着单行操作符使用
-- 	> < >= <= = <>
-- ④列子查询一般搭配多行操作符使用
-- 	in any some all
-- ⑤子查询的执行，优先于主查询的执行

#1.标量子查询
#案例1.谁的工资比abel高
-- 查询abel的工资 然后查询员工的信息满足工资高于他
select salary from employees
where last_name = 'Abel';

select *
from employees
where salary>(
	select salary 
    from employees
	where last_name = 'Abel'
    );
    
    
#案例2： 查询job_id与141号员工相同，salary比143员工高的员工姓名 job_id 和工资
select last_name, job_id, salary
from employees
where job_id = (
	select job_id
    from employees
    where employee_id = 141
) and salary > (
	select salary
    from employees
    where employee_id=143
);


#案例3. 返回公司工资最少的员工的last_name, job_id, salary
select last_name, job_id, salary from employees
where salary = (
	select min(salary)
    from employees
);


#案例4. 查询最低工资大于50号部门最低工资的部门的部门id和其最低工资
select department_id, min(salary)
from employees
group by department_id
having min(salary)>(
	select min(salary)
	from employees
	where department_id = 50
);

#非法使用标量子查询：子查询的结果不是一行一列

#2. 列子查询（多行子查询），也是放在where或者having后边
-- 需要搭配多行操作符： in any some all 配合not

#案例1： 返回location_id是1400或者1700的部门中所有的员工姓名
select last_name
from employees
where department_id in  (
   -- 也可以用=any; not in 可以换成 <>all
	select distinct department_id 
    from departments
	where location_id in (1400, 1700)
);


#案例2： 返回其他工种中比job_id为‘IT_PROG’部门任意一工资低的员工的：工号 姓名 job_id以及salary
select employee_id, last_name,salary
from employees
where salary<any( 
	select salary
	from employees
	where job_id = 'IT_PROG'
    )
and job_id <> 'IT_PROG';


#案例3：返回其他工种中比job_id为‘IT_PROG’的部门所有工资都低的员工的：工号 姓名 job_id以及salary
select employee_id, last_name,salary
from employees
where salary<all( 
	select salary
	from employees
	where job_id = 'IT_PROG'
    )
and job_id <> 'IT_PROG';

#3. 行子查询（结果集是一行多列或者是多行多列）
#案例1.查询员工编号最小并且工资最高的员工信息
#先查询最小的员工编号
select min(employee_id)
from employees;
#查询出最高的工资
select max(salary)
from employees;
#查询员工信息
select *
from employees
where employee_id=(
	select min(employee_id)
	from employees
) 
and salary=(
	select max(salary)
	from employees	
);

#行子查询  只有筛选条件都是等号连接的时候才会使用
select *
from employees
where (employee_id, salary)=(
	select min(employee_id), max(salary)
    from employees
);

-- 二。放在select后面的子查询
-- 查询每个部门的员工个数
-- 仅仅支持标量子查询
select d.*, 
(	select count(*) 
	from employees e
	where e.department_id=d.department_id
) 个数
from departments d;

-- 查询员工号等于102的部门名
select
(
	select department_name
    from departments d
	inner join employees e
    on d.department_id=e.department_id
    where e.employee_id=102
) 部门名;


#三。 将子查询放在from后边
-- 将子查询的结果充当一张表要求必须起别名
-- 将结果集当成表来使用

-- 案例：查询每个部门的平均工资的工资等级
-- 先查平均工资
select avg(salary), department_id
from employees
group by department_id;

select * from job_grades;

-- 连接1的结果集和job_gradesbiao 筛选条件为平均工资在low和high之间
select ag_dep.*,g.grade_level
from (
	select avg(salary) ag, department_id
	from employees
	group by department_id
) ag_dep
inner join job_grades g
on ag_dep.ag between lowest_sal and highest_sal;


#4. 放在exists后面的子查询   相关子查询
select exists(select employee_id from employees where salary=20000000);
-- exists判断后边的条件成立不成立  成立输出1 不成立输出0

-- 案例1：查询有员工的部门名
select department_name 
from departments d
where exists(
	select *
    from employees e
    where d.department_id=e.department_id
);
-- 子查询涉及到了主查询的字段

select department_name
from departments d
where d.department_id in (
	select department_id
    from employees
);

-- 习题
select last_name, salary
from employees
where department_id = (
	select department_id
    from employees
    where last_name = 'Zlotkey'
);


select employee_id, last_name, salary
from employees
where salary > (
	select avg(salary)
    from employees
);

select employee_id, last_name, salary, e.department_id
from employees e
inner join 
(
	select avg(salary) ag, department_id
	from employees
    group by department_id
) avg_dep
on e.department_id=avg_dep.department_id
where e.salary>avg_dep.ag; 
-- 这里用where不用having 因为group by在括号里 整体看成一个表 所以主函数里边没group by 所以用where


select employee_id, last_name, department_id
from employees e
where department_id in (
	select distinct department_id
	from employees
	where last_name like '%u%'
)
and last_name like '%u%'
order by department_id;

-- 子查询的结果集为多行 所以用in

select employee_id
from employees
where department_id in (
	select distinct department_id
    from departments
    where location_id = 1700
);
-- in可以用=any替代 一样的意思


select last_name, salary, manager_id
from employees
where manager_id = any (
	select employee_id
    from employees
    where last_name='K_ing'
);

select concat(first_name, ' ', last_name) as 姓名
from employees
where salary = (
	select max(salary) from employees
);