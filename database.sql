MySQL：
配置文件：
/etc/mt.cnf

服务端将mysqld进程放到内存中执行，就是启动了MySQL服务

上层：server层
	1.连接层：
		1）检查客户端请求是否合法
		2）确定连接协议（TCP/IP，进程间通信）
		3）创建一个线程和客户端通信
	2.SQL层：处理sql语句：
		1）语法检测；
		2）语义检查（权限）；
		3）解析预处理
		4）优化器：选择最优方案并执行
		告诉存储引擎，应该在磁盘上哪个地方取数据
	3.查询缓存：当页表来理解
		1）记录日志：记录修改记录
		
下层：引擎层（存储引擎）（Linux的文件系统）

逻辑结构：库（相当于Linux目录） -- 表（相当于Linux文件）
	磁盘：扇区 -> block -> 页 -> 区 -> 段
		扇区大小：512B
		block：4K
		页：将连续的若干个block组成一页--16K
		区：连续的64页组成一个区 -- 1M
		段：将若干个可能连续的区组成一个段
	MySQL中的表由段组成
	
	
DDL 定义数据库
DML 表的增、删、改、查	
	DQL：数据库查询语言
DCL 数据库控制
	
字符集：默认utf8
字符校验规则：


数据库基本操作：
	创建：
		create database db_name charset=utf8;
	修改：
		alter database ...
	查找：
		查看系统有哪些数据库：
			show databases;
		查看一个数据库的创建信息：
			show create database db_name;
	删除：
		drop database db_name;
	备份：
		mysqldump -P3306 -uroot -p[密码] shop > shop.sql

表的基本操作：
	创建：
		create table 表名(列)engine，charset
	查看：
		desc 表名
		show tables
	修改：
		alter table 表名 ADD/MODIFY/drop 
		alter table 表名 rename to 新名
	删除：
		drop table 表名
		
数据类型：
	bit(n):n取值1~64，默认1；显示的是ASCII码
	float(M,D):M表示总长度，D表示小数位数，需要注意的是，float值精确到小数后7bit
	decimal(M,D):用法和float相同，但是精确度高，65bit
	char(n):n最大255，单位是字符
	varchar(n):n的最大值和表的编码相关
		最大65535字节，varchar会用前若干个字节表示数据的长度
		当存储的字符串长度小于255字节时，其需要1字节的空间，当大于255字节时，需要2字节的空间。
		比如汉字utf8下是3B，所以最大能容纳的汉字数目就是
		（65535-3）/ 3 = 21844 n最大就是21844
		GBK：汉字是2B，65532 / 2 = 32766 n最大就是32766
	InnoDB规定一个varchar大小不要超过767B；如果数据流量过大，会变成Text类型
	MySQL中规定一行个字段的大小之和不能超过	65536B
	日期和时间：date，datetime（后者包含时分秒），timestamp（当前时间时间戳）
	enum和set：
	
表的约束：
	1.空属性：在列后面加上 not null
	2.默认值：default 值，都是在列后
	3.列描述：commit 描述，相当于注释，相比较于--，
		它是存储在创建表的代码中的
	4.zerofill：占位不够，前面自动补0
	5.主键：primary key  不重复，不为空
		在最后写时，可以使用复合主键
		create table test(
			id int,
			name varchar(10),
			primary key(id)	--这里就可以写复合主键
		);
	6.auto_increment:自增长，每执行一次插入操作（无论失败还是成功），
					它就加1，
		delete也不会影响此约束，因为delete没有真正从磁盘上把数据删除
		但是truncate会真正删除
	7.unique：唯一键，不能重复，unique key
	8.foreign key：外键，建立两个表之间的联系
		create table class(
			id int primary key,
			name varchar(10) not null,
		);
		create table stu(
			id int primary key,
			name varchar(10) not null,
			cid int,
			foreign key(cid) references class
		);
操作表：
	1.插入：
		1）insert into 表名 values (...),(...);
		--利用‘,’隔开，进行多条插入
		2）插入时更新
			insert into 表名 values (...) 
			on duplicate key update 列1 = ..., 列2 = ...;
		3)替换
			replace into 表名 values(...)
	2.查询：
		select 
		1）去重 distinct （整行相同），all（不去重，默认）
		from
		where
		1）比较 > >= < <= !=  <>
		2)like 模糊查询
			% -- 匹配多个 / 0个 写在后面不要写在前面，否则不走索引
			_ -- 匹配一个
			like只能用于字符类型，不能用于数字
		3）逻辑运算 and or
		4）between ... and ...	闭区间
		5）in 
		group by
		1）必须要和聚合函数结合使用，max、min、avg、count、sum
		2）a.取出表中的列
		   b.按照分组列进行排序
		   c.去重
		   d.把剩下的列通过聚合函数变成一行
		having
		order by
		1）asc 升序	-- 默认
		2）desc 降序
		limit
		
		
		
		
	
	
存储引擎：
	



	
	









