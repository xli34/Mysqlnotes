#进阶8， 分页查询 --✨ 使用广泛
#应用场景：当要显示的数据一页显示不全，需要分页提交sql请求
-- select 查询列表
-- from 表名
-- join type
-- on 连接条件
-- where 筛选条件
-- group by 分组字段
-- having 分组后的筛选
-- order by 排序字段
-- limit 启示索引offset， size；

-- offset代表要显示的条目的起始索引，从0开始
-- size代表要显示的条目个数

-- 特点：
-- 1. limit在查询语句的最后 执行顺序上也是最后
-- 2. 公式
-- 	要显示的页数是page，每一页的条目数是size
--     select 查询列表
--     from
--     limit （page-1）*size

-- 案例1： 查询前5条员工信息
select * from employees limit 0, 5;
select * from employees limit 5;

-- 案例2：查询第11条到第25条 (末位-首位+1)
select * from employees limit 10, 15;

-- 案例3：有奖金的员工信息并且工资较高的前10名显示
select * from employees
where commission_pct is not null
order by salary desc
limit 10;

-- 习题
select substr(email, 1,instr(email, '@')-1) from stuinfo;

select count(*), sex
from stuinfo
group by sex;

select `name`, gradeName
from stuinfo s
inner join grade g
on s.grade_id = g.id
where age > 18;

select min(age), grade_id
from stuinfo
group by grade_id
having min(age) > 20;

select last_name,salary
from employees
where salary = (
	select min(salary) from employees
);

select last_name
from employees
where employee_id in (
	select manager_id
    from employees
);

-- 经典案例
select last_name, salary
from employees
where salary = (
	select min(salary)
    from employees
);

-- 查询平均工资最低的部门信息
-- ①查询各部门的平均工资
-- select department_id, avg(salary）
-- from employees
-- group by department_id
-- ②查询结果集上avg（salary）的最小值
-- select min(ag)
-- from (
-- 	select department_id, avg(salary) ag
-- 	from employees
-- 	group by department_id
-- ) ag_dep
-- ③查询哪个部门编号的平均工资等于②
select avg(salary), department_id
from employees
group by department_id
having avg(salary) = (
	select min(ag)
	from (
		select department_id, avg(salary) ag
		from employees
		group by department_id
		 ) ag_dep
);


select d.* 
from departments d
where d.department_id = (
	select department_id
	from employees
	group by department_id
	having avg(salary) = (
		select min(ag)
		from (
			select department_id, avg(salary) ag
			from employees
			group by department_id
			 ) ag_dep
						 )
);

-- 简单方法
-- 计算各部门平均工资
-- 求出最低的平均工资的部门编号 用limit
select department_id
from employees
group by department_id
order by avg(salary)
limit 1;

-- 查询部门信息
select *
from departments
where department_id = (
	select department_id
	from employees
	group by department_id
	order by avg(salary)
	limit 1
);

select d.*, ag
from departments d
inner join (
	select avg(salary) ag, department_id
	from employees
	group by department_id
	order by avg(salary)
    limit 1
) ag_dep
on d.department_id = ag_dep.department_id;


-- 查询平均工资最高的job信息
select *
from jobs
where job_id = (
	select  job_id
	from employees
	group by job_id
	order by avg(salary) desc
	limit 1
);


-- 查询平均工资高于公司平均工资的部门

select  department_id
from employees
group by department_id
having avg(salary) > (
	SELECT avg(salary)
    from employees
);

select distinct department_id
from employees
where department_id = any (
	select  department_id
	from employees
	group by department_id
	having avg(salary) > (
		SELECT avg(salary)
		from employees
)
);

select *
from employees
where employee_id in (
	select manager_id 
    from employees
);


-- select max(salary), department_id
-- from employees
-- GROUP BY department_id
-- order by max(salary)
-- limit 1

select min(salary), department_id
from employees
group by department_id
having department_id = (
	select department_id
	from employees
	GROUP BY department_id
	order by avg(salary)
	limit 1
);


-- select avg(salary), department_id
-- from employees
-- group by department_id
-- order by avg(salary) desc
-- limit 1

-- select manager_id, department_id
-- from employees
-- order by department_id;



select last_name, department_id, email, salary
from employees
where employee_id = any (
	select manager_id
    from employees
    where department_id = (
		select department_id
		from employees
		group by department_id
		order by avg(salary) desc
		limit 1
    )
);


-- 生日在。。。之后的判断条件 用到datediff函数
-- where datediff(borndate, '1988-1-1')>0 

-- 联合查询的后半段
#进阶9. 联合查询
-- 涉及到关键字 union 联合、合并：将多条查询语句的结果合并成一个结果
-- 语法：
-- 查询语句1
-- union
-- 查询语句2
-- union......

-- 应用场景:
-- 要查询的结果来自于多个表并且他们之间没有直接的连接关系
-- 但需要查询的信息一致时可以使用


#引入案例： 查询部门编号大于90或者邮箱中包含a的员工信息
select * from employees
where email like '%a%' or department_id>90;

select * from employees where email like '%a%'
union
select * from employees where department_id>90;


-- #案例：查询中国用户中性别为男的信息以及外国用户中男性的信息
-- select c_id, cName, cGender from t_ca where csex = '男'
-- union
-- select t_id, tName, tGender from t_ua where tGender = 'male';

-- 联合查询的特点
-- 1. 要求多条查询语句的查询列数是一致的
-- 2. 结果的字段名默认为第一条查询语句的字段名，要求多条查询语句查询的每一列的类型和顺序最好是一致的
-- 3. 使用union会自动去重，如果不想去重则使用union all关键字就可以全部显示











