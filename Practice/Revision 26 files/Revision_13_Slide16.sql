--Câu 1 (3đ): Tạo csdl QLKHO gồm 3 bảng: 
--	Nhap (SoHDN,MaVT,SoLuongN,DonGiaN,NgayN)
--	Xuat (SoHDX,MaVT,SoLuongX,DonGiaX,NgayX)
--	Ton (MaVT,TenVT,SoLuongT)

create database QLBenhVien_Slide16

use QLBenhVien_Slide16

create table TON (
	MaVT char(10) primary key,
	TenVT nvarchar(50),
	SoLuongT int
)

create table NHAP (
	SoHDN char(10),
	MaVT char(10),
	SoLuongN int,
	DonGiaN money,
	NgayN date,
	constraint PK_NHAP primary key (SoHDN, MaVT),
	constraint FK_NHAP foreign key (MaVT) references TON(MaVT) on update cascade on delete cascade
)

create table XUAT (
	SoHDX char(10),
	MaVT char(10),
	SoLuongX int,
	DonGiaX money,
	NgayX date
	constraint PK_XUAT primary key (SoHDX, MaVT),
	constraint FK_XUAT foreign key (MaVT) references TON(MaVT) on update cascade on delete cascade
)

insert into TON values ('VT01', 'Vat tu 01', 200)
insert into TON values ('VT02', 'Vat tu 02', 200)
insert into TON values ('VT03', 'Vat tu 03', 200)
insert into TON values ('VT04', 'Vat tu 04', 200)
insert into TON values ('VT05', 'Vat tu 05', 200)

insert into NHAP values ('HDN01', 'VT01', 10, 10000, '04/09/2021')
insert into NHAP values ('HDN02', 'VT02', 10, 10000, '04/09/2021')
insert into NHAP values ('HDN03', 'VT05', 10, 10000, '04/09/2021')

insert into XUAT values ('HDX01', 'VT01', 5, 10000, '04/05/2021')
insert into XUAT values ('HDX02', 'VT01', 5, 10000, '04/05/2021')
insert into XUAT values ('HDX03', 'VT01', 5, 10000, '04/05/2021')

select * from TON
select * from NHAP
select * from XUAT













