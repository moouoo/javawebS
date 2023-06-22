show tables;

create table board2 (
	idx   int not null auto_increment,	/* 게시글의 고유번호 */
	mid      varchar(20) not null,					/* 게시글 올린이 아이디 */
	nickName varchar(20) not null,			/* 게시글 올린이 닉네임 */
	title   varchar(100) not null,				/* 게시글 제목 */
	email		varchar(50),							/* 이메일 주소 */
	homePage varchar(50),							/* 홈페이지(개인블로그) 주소 */
	content text not null,						/* 게시글 내용 */
	readNum int default 0,						/* 글 조회수 */
	hostIp  varchar(40) not null,			/* 글 올린이의 IP */
	openSw  char(2)	default 'OK',			/* 게시글 공개여부(OK:공개,NO:비공개) */
	wDate   datetime  default now(),		/* 글 올린 날짜/시간 */
	good		int default 0,						/* '좋아요' 클릭 횟수 누적 */
	primary key(idx)
);

desc board2;

insert into board2 values (default,'admin','관리맨','게시판 서비스를 시작합니다.','cjsk1126@naver.com','cjsk1126.tistory.com','이곳은 게시판입니다.',default,'192.168.50.20',default,default,default);

select * from board2;

/* 게시판에 댓글 달기 */
create table board2Reply (
  idx   int not null auto_increment,		/* 댓글의 고유번호 */
  boardIdx int not null,								/* 원본글의 고유번호(외래키로 지정) */
  mid		varchar(20) not null,						/* 댓글올린이의 아이디 */
  nickName varchar(20) not null,				/* 댓글올린이의 닉네임 */
  wDate		datetime default now(),				/* 댓글 올린 날짜 */
  hostIp  varchar(50)  not null,				/* 댓글 올린 PC의 고유 IP */
  content text not null,								/* 댓글 내용 */
  groupId int default 0,						/* 그룹ID(같은 댓글끼리의 그룹아이디는 같다) */
  level int default 0,							/* 대댓글의 구분을 위한 level(원본글의 댓글은 0, 대댓글은 1,2,3.. */
  primary key(idx),											/* 기본키 : 고유번호 */
  foreign key(boardIdx) references board2(idx)		/* 외래키 설정 */
  on update cascade
  on delete restrict
);

desc board2Reply;


/* 날짜함수 처리 연습 */
select now();				/* 오늘 날짜 보여달라. */
select year(now());
select month(now());
select day(now());
select concat(year(now()),'년 ',month(now()), '월 ', day(now()), '일');
select concat(year(now()),'년 ',month(now()), '월 ', day(now()), '일') as nalja;
select date(now());				/* 날짜를 '년-월-일' 로 출력 */
select weekday(now()); 		/* 0(월), 1(화), 2(수), 3(목), 4(금), 5(토), 6(일) */
select dayofweek(now());	/* 1(일), 2(월), 3(화), 4(수), 5(목), 6(금), 7(토) */

select year('2023-5-3');
select idx,wDate from board2;
select idx,year(wDate) from board2;

/* 날짜 연산 */
/* date_add(date, interval 값 Type) */
select date_add(now(), interval 1 day);		/* 오늘 날짜보다 +1 = 내일날짜 출력 */
select date_add(now(), interval -1 day);		/* 오늘 날짜보다 -1 = 어제날짜 출력 */
select now(),date_add(now(), interval 10 day_hour);		/* 오늘날짜보다 +10시간 이후의 날짜/시간 출력 */
select now(),date_add(now(), interval -10 day_hour);		/* 오늘날짜보다 -10시간 이후의 날짜/시간 출력 */

/* date_sub(date, interval 값 Type) */
select date_sub(now(), interval 1 day);		/* 오늘 날짜보다 -1 = 어제날짜 출력 */
select date_sub(now(), interval -1 day);		/* 오늘 날짜보다 +1 = 내일날짜 출력 */

/* board2테이블에 적용하기 */
select wDate, date_add(now(), interval -1 day) from board2;		/* 게시글중에서 하루전에 올라온 글만 보여주시오 */
select substring(wDate,1,10), substring(date_add(now(), interval -1 day),1,10) from board2;
select idx, wDate, date_add(now(), interval -1 day) from board2 where substring(wDate,1,10) = substring(date_add(now(), interval -1 day),1,10);
select idx, wDate, now() from board2 where wDate >= date_add(now(), interval -24 day_hour);		/* 게시글중 24시간 전에 올라온 글에대해서만 보여주시오 */
select * from board2 where wDate >= date_add(now(), interval -24 day_hour);
select idx, wDate, date_add(now(), interval -24 day_hour), now(), (wDate - date_add(now(), interval -24 day_hour)) from board2;

/* 날짜차이 계산 : DATEDIFF(시작날짜, 마지막날짜) */
select datediff('2023-05-04', '2023-05-01');
select datediff(now(), '2023-05-01');
select idx, datediff(now(), wDate) from board2;
select idx, datediff(now(), wDate) as day_diff from board2;

select timestampdiff(hour, now(), '2023-05-04');
select timestampdiff(hour, '2023-05-04', now());
select timestampdiff(hour, wDate, now()) from board2;
select timestampdiff(hour, wDate, now()) as hour_diff from board2;
select *,timestampdiff(hour, wDate, now()) as hour_diff from board2 order by idx desc;
select *,timestampdiff(hour, wDate, now()) as hour_diff from board2 order by idx desc limit 0,5;
select *,datediff(wDate, now()) as day_diff,timestampdiff(hour, wDate, now()) as hour_diff from board2 order by idx desc limit 0,5;
select timestampdiff(day, '2023-05-01', now());

/* 날짜양식(date_format()) : 4자리년도(%Y), 월(%m), 일(%d) */
select wDate, date_format(wDate, '%Y-%m-%d %H:%i') from board2;
select *,date_format(wDate, '%Y-%m-%d'),date_format(wDate, '%H:%i'),timestampdiff(hour, wDate, now()) as hour_diff from board2;
select *,date_format(wDate, '%Y-%m-%d') as day_format, date_format(wDate, '%H:%i') as hour_format, timestampdiff(hour, wDate, now()) as hour_diff from board2;

/* 이전글/ 다음글 꺼내오기 */
select * from board2;
select * from board2 where idx = 6;
select idx,title from board2 where idx < 6 order by idx desc limit 1; /* 이전글 */
select idx,title from board2 where idx > 6 limit 1;	/* 다음글 */

--<![CDATA[조건식]]> ???? -> mapper에서 확인!!
select idx,title from board2 where idx in (
	(select idx from board2 where idx < 6 order by idx desc limit 1),
	(select idx from board2 where idx > 6 limit 1))
	

/* 게시판(board2) 리스트 글제목옆에 해당글의 댓글(board2Reply)수를 출력하시오 */

/* 댓글의 수를 전체 List에 출력하기위한 연습 */
-- 전체 board2테이블의 내용을 최신순으로 출력?
select * from board2 order by idx desc;

-- board2테이블 고유번호 22번에 해당하는 댓글테이블의 댓글수는?
select count(*) from board2Reply where boardIdx = 22;

-- 앞의 예에서 원본글의 고유번호와함께, 총 댓글의 갯수는 replyCnt 로 출력?
select boardIdx, count(*) as replyCnt from board2Reply where boardIdx = 22;

-- 이때, 원본글을 쓴 닉네임도 함께 출력하시오. 단, 닉네임은 원본글(board2)테이블에서 가져와 출력하시오?
select boardIdx, count(*) as replyCnt,
  (select nickName from board2 where idx = 22) as nickName
  from board2Reply 
  where boardIdx = 22;

-- 앞의 내용들을 부모관점(board2테이블)에서 보자....
select mid, nickName from board2 where idx = 22;

-- 이때 앞의 닉네임을 자식(댓글)테이블(board2Reply)에서 가져와서 보여준다면??
select mid, 
  (select nickName from board2Reply where boardIdx=22) as nickName
  from board2 where idx = 22;
  
select mid, 
  (select count(*) from board2Reply where boardIdx=22) as nickName
  from board2 where idx = 22;
  
select *, 
  (select count(*) from board2Reply where boardIdx=22) as replyCnt
  from board2 where idx = 22;
  
-- 부모관점(board2)테이블을 기준으로 처리....
-- board2테이블의 1페이지 5건을 출력하되, board2테이블의 모든내용과, 현재 출력된 게시글에 달려있는 댓글의 개수를 출력?
-- 단, 최신글을 먼처 출력시켜주세요.
select *,
  (select count(*) from board2Reply where boardIdx=b.idx) as replyCnt
  from board2 b
  order by idx desc
  limit 5;
  