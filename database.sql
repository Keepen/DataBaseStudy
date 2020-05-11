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
		1）limit n 		--前n行
		2）limit s,n 	--从s行开始，前n行
		
	内连接：
		select * from A (inner) join B on 条件;
		A 交 B
	外连接：
		select *from A left join B 
		A
		select * from A right join B
		B
MySQL的索引：
	1.聚簇索引
		构建聚簇索引的前提：
			1）设置了主键列 -- 主键列就是聚簇索引
			2）没有主键列，选择唯一索引的列作为聚簇索引
			3）前两者都没有，MySQL会自动增加一列作为聚簇索引列
		作用：
			1）在存放数据时，会按照聚簇索引进行排序放到磁盘上
	2.辅助索引：
		将经常作为查询条件的列设置成辅助索引，需要手动添加
		1）在建表的最后加上 index(列名)
		2）alter table 表名 add index(列)
		3）create index 索引名 on 表名(列)
	3.单列索引和联合索引：
		如果是联合索引，查询时的最左原则：
		eg：
			alter table test add index(a,b,c);
		--走索引	
			select * from test where a=xxx;
			select * from test where a=xxx and b=xxx;
			select * from test where a... b... c...;
			select * from test where c,b,a;		--会被优化器优化成a,b,c
		--不走索引	
			select * from test where b,c;
	4.查看索引：
		desc 表名;
		show index from 表名;
	原则：
		1.经常在where后作为查询条件的列
		2.列的数据尽可能地不要重复
		3.索引不是建地越多越好，因为会消耗磁盘空间
	5.查看查询是否走索引
		explain + 查询语句
		在type那一列可以得到结果：
			all -- 全表扫描，
				1）不加where；
				2）like “%..”都是不走索引
				3）not in (...) 不是主键列时，不走索引
			ref -- 走索引
			index  		< 	range 	< 	ref 	< 	eq_ref 		< 	const	效率依次变高
			全索引扫描	  范围查找	  等值查询   多表驱动表是主键    聚簇索引等值查询
		
事务：
	开启事务：
		1.begin 
		2.start transaction
	保存节点
		savepoint 节点名称
		...
	事务回滚
		rollback 节点名称	（不写名称就回滚到begin的位置）
	提交
		commit
		

事务的隔离级别：
脏读：
	B读到了A在commit之前的数据，A又要进行回滚
不可重复读：
	commit之前查到的数据和commit之后查到的数据不同	
	针对update和delete	
幻读：
	由于insert操作导致的读数据错误

			脏读		不可重复读		幻读	加锁读
读未提交：	1				1			1		不加锁
读已提交：	0				1			1		不加锁
可重复读：	0				0			0		不加锁
可串行化：	0				0			0		加锁

	特性：
		1.原子性：最小执行单位
		2.一致性：简单理解为稳定状态，commit后的状态
		3.隔离性：各个事务的执行互不干扰
		4.持久性：一个事务一旦被提交就会永久存储到库中


视图：就是基表的副本（部分）
	1.修改视图会影响基表
	

设置权限：
	1.grant 权限 on 对象（某个库的某个表） to 用户
		刷新权限：flush privileges;
回收权限：
	revoke 权限列表 on 库.对象名 from '用户名'@'登陆位置'
	
存储引擎：
	InnoDB建表会有两个文件，一个.frm，一个.idb
	MyISAM建表会有三个文件，一个.frm，一个.MYD，一个.MYI
	
	



	
	









