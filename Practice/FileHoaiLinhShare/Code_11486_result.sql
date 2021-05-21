create database FileHoaiLinhShare_Code11486

use FileHoaiLinhShare_Code11486


create table CONGTY(
	MaCongTy char(10) primary key,
	TenCongTy nvarchar(50),
	DiaChi nvarchar(50),
)

create table SANPHAM(
	MaSanPham char(10) primary key,
	TenSanPham nvarchar(50),
	SoLuongCo int,
	GiaBan money
)

create table CUNGUNG(
	MaCongTy char(10),
	MaSanPham char(10),
	SoLuongCungUng int,
	NgayCungUng date,
	constraint PK_CUNGUNG primary key (MaCongTy, MaSanPham),
	constraint FK_CUNGUNG_01 foreign key (MaCongTy) references CONGTY(MaCongTy) on update cascade on delete cascade,
	constraint FK_CUNGUNG_02 foreign key (MaSanPham) references SANPHAM(MaSanPham) on update cascade on delete cascade,
)

insert into CONGTY values ('CTY01', 'Cong Ty 01', 'Dia chi 01')
insert into CONGTY values ('CTY02', 'Cong Ty 02', 'Dia chi 02')
insert into CONGTY values ('CTY03', 'Cong Ty 03', 'Dia chi 03')

insert into SANPHAM values ('SP01', 'San Pham 01', 100, 10000)
insert into SANPHAM values ('SP02', 'San Pham 02', 5, 15000)
insert into SANPHAM values ('SP03', 'San Pham 03', 20, 20000)

insert into CUNGUNG values ('CTY01', 'SP01', 15, '10/25/2020')
insert into CUNGUNG values ('CTY01', 'SP02', 20, '03/17/2021')
insert into CUNGUNG values ('CTY01', 'SP03', 20, '03/17/2021')
insert into CUNGUNG values ('CTY02', 'SP02', 10, '03/17/2021')
insert into CUNGUNG values ('CTY02', 'SP03', 5, '03/17/2021')

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG





