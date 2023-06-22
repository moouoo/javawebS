show tables;

create table pds2 (
  idx		int  not null auto_increment,	/* 자료실 고유번호 */
  mid		varchar(20) not null,					/* 올린이 아이디 */
  nickName	varchar(20)  not null,		/* 올린이 닉네임 */
  fName			varchar(200) not null,		/* 업로드시의 파일명 */
  fSName		varchar(300) not null,		/* 실제 파일서버에 저장되는 파일명 */
  fSize			int  not null,						/* 파일의 총 사이즈 */
  title			varchar(100) not null,		/* 업로드파일의 제목 */
  part			varchar(20)  not null,		/* 파일 분류(학습/여행/음식/기타___) */
  pwd				varchar(100) not null,		/* 비밀번호(스프링 시큐리티(BCryptPasswordEncoder) 암호화 처리) */
  fDate			datetime  default now(),	/* 파일 업로드한 날짜 */
  downNum		int 	default 0,					/* 파일 다운로드 횟수 */
  openSw		char(6)	default '공개',		/* 파일 공개(비공개) 여부 */
  content   text,											/* 업로드 파일의 상세설명 */
  hostIp		varchar(50) not null,			/* 업로드시 클라이언트 IP 주소 */
  primary key (idx)										/* 기본키 : 자료실의 고유번호 */
);

SELECT 	datediff(now(), '2023-6-1');
SELECT 	timestampdiff(hour, '2023-6-20 22:20', now());
SELECT 	*,datediff(now(), fDate) as day_diff, timestampdiff(hour, fDate, now()) as hour_diff FROM pds2;
