create database condition_02_code_21

use condition_02_code_21

create table SACH(
	MaSach char(10) primary key,
	TenSach nvarchar(50),
	SLCo int,
	MaTG char(10),
	NgayXB date
)

create table NXB(
	MaNXB char(10) primary key,
	TenNXB nvarchar(50)
)

create table XUATSACH(
	MaNXB char(10), 
	MaSach char(10),
	SoLuong int,
	Gia money,
	constraint PK_XUATSACH primary key (MaNXB, MaSach),
	constraint FK_XUATSACH_01 foreign key (MaNXB) references NXB(MaNXB) on update cascade on delete cascade,
	constraint FK_XUATSACH_02 foreign key (MaSach) references SACH(MaSach) on update cascade on delete cascade
)


insert into SACH values ('S01', 'Sach 01', 100, 'TG01', '10/25/2020')
insert into SACH values ('S02', 'Sach 02', 150, 'TG03', '08/17/2020')
insert into SACH values ('S03', 'Sach 03', 200, 'TG05', '04/26/2021')

insert into NXB values ('NXB01', 'Nha Xuat Ban 01')
insert into NXB values ('NXB02', 'Nha Xuat Ban 02')

insert into XUATSACH values ('NXB01', 'S01', 10, 15000)
insert into XUATSACH values ('NXB01', 'S02', 15, 20000)
insert into XUATSACH values ('NXB01', 'S03', 20, 10000)
insert into XUATSACH values ('NXB02', 'S01', 5, 15000)
insert into XUATSACH values ('NXB02', 'S02', 15, 20000)

select * from SACH
select * from NXB
select * from XUATSACH









