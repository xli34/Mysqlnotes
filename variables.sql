# 变量
/*
系统变量
	全局变量
    会话变量
自定义变量
	用户变量
    局部变量
*/

# #系统变量： 由系统提供，不是用户定义，属于服务器层面
# # 使用语法：
# # 1. 查看所有的系统变量
# show global variables;
# # 2. 查看满足条件的部分系统变量
# show global variables like '%char%';
# # 3. 查看某个指定的某个系统变量的值
# select @@系统变量值
# # 4. 为某个系统变量赋值
# set global 系统变量名=值

#如果是全局级别就加global 如果是会话级别 需要去加session 如果什么都不写 默认session
#模糊查询用show 具体的用select 
show global variables;
show global variables like '%char%';
select @@global.autocommit;
set @@global.autocommit=1;

# 全局变量
# 作用域：服务器每次启动将为所有的全局变量赋初始值，针对所有的会话连接有效，但不能跨重启

#2. 会话变量
/*
作用域： 仅仅针对于当前的会话（连接）有效
*/
# 查看所有的会话变量
show session variables;

show session variables like '%char%';

select @@session.transaction_isolation;

set @@session.transaction_isolation = 'read-uncommitted';
set session transaction_isolation = 'read-committed';


# 3. 自定义变量
/*
说明： 变量是用户自定义的 不是系统定义的
使用步骤：
声明
赋值
使用（查看比较运算）
*/

#1. 用户变量
# 作用域： 针对于当前会话有效 同会话变量的作用域

# 1. 声明并初始化
# set @用户变量名=值;
# set @用户变量值:=值;
# select @用户变量名:=值;

# 2. 赋值（更新）用户变量的值
# 方式1：set或者select
# set @用户变量名=值;
# set @用户变量值:=值;
# select @用户变量名:=值;

# 方式2：select into
# select 字段 into 变量名
# from 表；

# 3. 查看
# select @用户变量值;
# #案例：
# 声明并且初始化
# set @name='john';
# set @name=100;
# 赋值
# select count(*) into @count
# from employees
# 查看
# select @count;
# # 存储过程和函数
# # 流程控制结构



