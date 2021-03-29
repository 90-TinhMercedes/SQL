--Câu 1 (3đ): Tạo csdl QLHANG gåm 3 bảng sau: 
--+ Hang(MaHang,TenHang,DVTinh, SLTon)
--+ HDBan(MaHD,NgayBan,HoTenKhach)
--+ HangBan(MaHD,MaHang,DonGia,SoLuong)

create database QLHANG_Slide13

use QLHANG_Slide13

create table HANG (
	MaHang char(10) primary key,
	TenHang nvarchar(50),
	DVTinh nvarchar(50),
	SLTon int
)

create table HDBAN (
	MaHD char(10) primary key,
	NgayBan datetime,
	HoTenKhach nvarchar(50)
)

create table HANGBAN (
	MaHD char(10),
	MaHang char(10),
	DonGia money,
	SoLuong int,
	constraint pk_HANGBAN primary key (MaHD, MaHang),
	constraint first_fk_HangBan foreign key (MaHD) references HDBAN(MaHD) on update cascade on delete cascade,
	constraint second_fk_HangBan foreign key (MaHang) references HANG(MaHang) on update cascade on delete cascade 
)

insert into HANG values ('H01', 'Hang 01', 'cai', 10)
insert into HANG values ('H02', 'Hang 02', 'chiec', 15)

insert into HDBAN values ('HD01', '12/25/2020', 'Tinh Mercedes')
insert into HDBAN values ('HD02', '08/20/2019', 'Tinh Main Veigar')

insert into HANGBAN values ('HD01', 'H01', 15000, 5)
insert into HANGBAN values ('HD02', 'H02', 20000, 4)
insert into HANGBAN values ('HD02', 'H01', 17000, 3)
insert into HANGBAN values ('HD01', 'H02', 9000, 7)

select * from HANG
select * from HDBAN
select * from HANGBAN