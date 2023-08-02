create table visit (
  visitDate datetime not null default now(),
  visitCount			int  not null default 1
);

drop table visit;
delete from visit;

select now();
select date(now());

insert into visit values (date(now()),default);
insert into visit values ('2023-06-30',8);
insert into visit values ('2023-06-28',5);
insert into visit values ('2023-06-25',10);
insert into visit values ('2023-06-26',12);
insert into visit values ('2023-06-24',5);
insert into visit values ('2023-06-23',3);
insert into visit values ('2023-06-21',15);

select * from visit;
select substring(visitDate,1,10) as visitDate, visitCount from visit order by visitDate desc limit 7;

select mid as visitDate,visitCnt as visitCount from member2 order by visitCnt desc limit 7;