create database QLSach_Slide6

use QLSach_Slide6

create table TACGIA (
	MaTG char(10) primary key,
	TenTG nvarchar(50),
	SoLuongCo int
)

create table NHAXB (
	MaNXB char(10) primary key,
	TenNXB nvarchar(50),
	SoLuongCo int
)

create table SACH (
	MaSach char(10) primary key,
	TenSach nvarchar(50),
	MaNXB char(10),
	MaTG char(10),
	NamXB int,
	SoLuong int,
	DonGia money
	constraint fk_SACH_01 foreign key (MaNXB) references NHAXB(MaNXB) on update cascade on delete cascade,
	constraint fk_SACH_02 foreign key (MaTG) references TACGIA(MaTG) on update cascade on delete cascade
)

insert into TACGIA values('TG01', 'Tac gia 01', 3)
insert into TACGIA values('TG02', 'Tac gia 02', 5)
insert into TACGIA values('TG03', 'Tac gia 03', 2)

insert into NHAXB values('NXB01', 'Nha xuat ban 01', 4)
insert into NHAXB values('NXB02', 'Nha xuat ban 02', 2)
insert into NHAXB values('NXB03', 'Nha xuat ban 03', 5)

insert into SACH values('SA01', 'Sach 01', 'NXB02', 'TG01', 2019, 20, 15000)
insert into SACH values('SA02', 'Sach 02', 'NXB03', 'TG02', 2015, 15, 21000)
insert into SACH values('SA03', 'Sach 03', 'NXB01', 'TG02', 2017, 17, 17000)
insert into SACH values('SA04', 'Sach 04', 'NXB01', 'TG03', 2020, 9, 9000)
insert into SACH values('SA05', 'Sach 05', 'NXB01', 'TG01', 2019, 14, 16000)
insert into SACH values('SA06', 'Sach 06', 'NXB02', 'TG02', 2020, 22, 15500)

select * from TACGIA
select * from NHAXB
select * from SACH

--Câu 2(3 đ): Hãy tạo view đưa ra tiền bán theo tên TG, gồm Masach, Tensach, TenTG,TienBan 
create view cau02
as
	select MaSach, TenSach, TACGIA.TenTG, sum(SoLuong * DonGia) as TienBan
	from TACGIA inner join SACH on TACGIA.MaTG = SACH.MaTG
	group by MaSach, TenSach, TACGIA.TenTG

select * from TACGIA
select * from NHAXB
select * from SACH
select * from cau02

--Câu 3(3 đ): Hãy tạo view thống kê tiền bán theo tên NXB, gồm Masach, Tensach, TenNXB,TienBan (TienBan=SoLuong*DonGia)
create view cau03
as
	select MaSach, TenSach, NHAXB.TenNXB, sum(SoLuong * DonGia) as TienBan
	from NHAXB inner join SACH on NHAXB.MaNXB = SACH.MaNXB
	group by MaSach, TenSach, NHAXB.TenNXB

select * from cau03




