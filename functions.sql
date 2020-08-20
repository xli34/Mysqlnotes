#进阶四： 常见函数的学习
/*
功能：类似于java中的方法，将一组逻辑语句封装在方法体中，对外暴露方法名
好处：	1. 隐藏了实现细节
		2. 提高了代码的重用性
调用：select 函数名（实参列表）from 表；当函数中的参数用到了表中的字段 不然就不用调用表
特点：1. 该方法的函数名。 2. 函数的功能
分类： 
	1. 单行函数：concat。length。ifnull。
    （字符函数，数学函数，日期函数，其他函数，流程控制函数）
	2. 分组函数，做统计使用，又称为函数统计，聚合函数
*/


#一。 字符函数
#1. LENGTH
use myemployees;
SELECT LENGTH('john');
SELECT LENGTH('张三丰hahaha');#一个字母占一个字节，一个汉子占三个字节
SHOW VARIABLES LIKE '%char%';

#2. concat
SELECT CONCAT(last_name, '_', first_name) AS xingming FROM employees;

#3.upper and lower
SELECT UPPER('John');
SELECT LOWER('joHn');
SELECT CONCAT(UPPER(last_name), ' ', LOWER(first_name)) AS 姓名 FROM employees;

#4.substr/substring 注意 所有的索引在mysql中都是从1开始的
#截取从指定索引处后面所有字符
SELECT SUBSTR('李莫愁爱上了陆展元',7) out_put;
#截取从指定所以指定字符长度
SELECT SUBSTR('李莫愁爱上了陆展元',1,3) out_put;

#姓名中首字符大写 其他字符小写然后用_拼接并显示
SELECT 
CONCAT(UPPER(SUBSTR(first_name,1,1)),LOWER(SUBSTR(first_name,2))) AS out_put 
FROM employees;


#5. instr 返回子串第一次出现的索引，如果找不到就返回0
SELECT INSTR('杨不悔爱上了殷六侠','殷六侠') AS out_put;


#6. trim 
SELECT LENGTH(TRIM('       张翠山。       ')) AS out_put;
SELECT TRIM('a' FROM 'aaaaaaa张aaaa翠山aaaaaa') AS out_put;


#7. lpad 用指定的字符实现左填充指定长度   ///////////重点///////////
SELECT LPAD('yinsusu',2,'*') AS out_put;
#8.rpad 右填充
SELECT RPAD('yinsusu',12,'*') AS out_put;

#9.replace
SELECT REPLACE('张无忌爱上周芷若','周芷若','赵敏') AS zhanan;


#二。 数学函数

#round 四舍五入
SELECT ROUND(-1.55);
SELECT ROUND(1.567,2);#小数点后保留几位

#ceil 向上取整 返回大于等于该参数的最小整数
SELECT CEIL(-1.05);

#floor 向下取整，返回小于等于该参数的最大整数
SELECT FLOOR(9.99);

#truncate 截断
SELECT TRUNCATE(1.69,1);

#mod 取余 被除数为正就为正 被除数为负就为负
#MOD(a,b): a-a/b*b
SELECT MOD(10,-3);
SELECT 10%3;

#三。日期函数

#now 返回当前系统的日期加时间
SELECT NOW();

#curdate 返回系统日期 不包括时间
SELECT CURDATE();

#curtime 返回时间不包含日期
SELECT CURTIME();

#获取指定的部分，日月小时分钟
SELECT YEAR(NOW()) nian;
SELECT YEAR('1998-1-1');
SELECT YEAR(hiredate) AS nianfen FROM employees;
SELECT MONTH(NOW());
SELECT MONTHNAME(NOW());# DAY MINUTE HOUR....

#str_to_date 将日期格式的字符转换为指定格式的日期
/*
%Y 四位年份
%y 两位年份
%m 两位月份 01，02，03，04
%c 月份 1，2，3，4，5
%d 两位日期 01，02
%H 小时（24小时制）
%h 小时 12小时制
%i 分钟 两位
%s 秒 两位
*/
SELECT STR_TO_DATE('1998-3-2','%Y-%c-%d') AS out_put;
#查询入职日期为1992 年4月3号的员工信息
SELECT * FROM employees WHERE hiredate='1992-4-3';
SELECT * FROM employees WHERE hiredate = STR_TO_DATE('4-3 1992', '%c-%d %Y');

#date_format 将日期转换成字符
SELECT DATE_FORMAT(NOW(), '%Y年%m月%d日') AS `date`;
#查询有奖金的员工名和入职日期(xx月/xx日 xx年)
SELECT last_name, DATE_FORMAT(hiredate, '%m月/%d日 %y年') AS `date` 
FROM employees
WHERE commission_pct IS NOT NULL;

#四 其他函数
SELECT VERSION();
SELECT DATABASE();
SELECT USER();

#五 流程控制函数
#1. if函数 实现类似于if else的效果
SELECT IF(10>5,'da','xiao');
SELECT last_name, commission_pct, IF(commission_pct IS NULL,'mei','you') AS 'xinqing' 
FROM employees;

#2. case 
#使用1 类似于switch case
/*
switch(变量表达式){
	case 常量1: 语句1；break；
    。。
    default：语句n；break；
				}
                
mysql中
case 要判断的字段或表达式
when 常量1 then 要显示的值1或者语句1 是语句就加分号
when 常量2 then 要显示的值1或者语句2 是语句就加分号
。。。
else 要显示的值n或者语句n；
end
*/

#查询员工的工资，要求： 
-- 	部门号=30，显示的工资为1.1倍
--  部门号=40，显示的工资为1.2倍
-- 	部门号=50，显示的工资为1.3倍
--  其他部门，显示的工资为原工资

SELECT salary AS 原始工资, department_id,
CASE department_id
WHEN 30 THEN salary*1.1
WHEN 40 THEN salary*1.2
WHEN 50 THEN salary*1.3
ELSE salary
END AS 新工资
FROM employees;

#3. case函数的使用2，类似于多重if
-- java中
-- if（条件1）{
-- 语句1:
-- }else if（条件2）{
-- 语句2
-- }
-- 等等
-- else{
-- 语句n；
-- }

-- mysql中：
-- case
-- when 条件1 then 要显示的值1或 语句1；
-- when 条件2 then 要显示的值2或 语句2；
-- 。。。
-- else 要显示的值n 或 语句n
-- end

#案例： 查询员工的工资情况
-- 如果工资大于20000 显示级别a
-- 如果工资大于15000 显示级别b
-- 如果工资大于10000 显示级别c
-- 否则，级别d

SELECT salary,
CASE
WHEN salary>20000 THEN 'A'
WHEN salary>15000 THEN 'B'
WHEN salary>10000 THEN 'C'
ELSE 'D'
END AS `level`
FROM employees;

SELECT NOW();

SELECT employee_id, first_name, salary, salary*1.2 AS 'new'
FROM employees;

SELECT LENGTH(last_name) changdu, substr(last_name,1,1) shouzifu, last_name
FROM employees
ORDER BY shouzifu;

SELECT concat(last_name,' earns ',salary,' monthly but wants ',salary*3 ) DREAMSALARY
FROM employees
WHERE salary=24000;

SELECT DISTINCT job_id AS job, department_id,
case job_id
when 'AD_PRES' THEN 'A'
when 'ST_MAN' THEN 'B'
when 'IT_PROG' THEN 'C'
when 'SA_REP' THEN 'D'
when 'ST_CLERK' THEN 'E'
END AS 'Grade'
FROM employees;

  


