create database condition_02_code_23

use condition_02_code_23

create table CONGTY(
	MaCT char(10) primary key,
	TenCT nvarchar(50),
	TrangThai nvarchar(50),
	ThanhPho nvarchar(50)	
)

create table SANPHAM(
	MaSP char(10) primary key,
	TenSP nvarchar(50),
	MauSac nvarchar(50),
	SoLuong int,
	GiaBan money
)

create table CUNGUNG(
	MaCT char(10),
	MaSP char(10),
	SoLuongCungUng int,
	constraint PK_CUNGUNG primary key (MaCT, MaSP),
	constraint FK_CUNGUNG_01 foreign key (MaCT) references CONGTY(MaCT) on update cascade on delete cascade,
	constraint FK_CUNGUNG_02 foreign key (MaSP) references SANPHAM(MaSP) on update cascade on delete cascade
)

insert into CONGTY values ('CTY01', 'Cong Ty 01', 'Ready', 'Thanh pho 01')
insert into CONGTY values ('CTY02', 'Cong Ty 02', 'Ready', 'Thanh pho 02')
insert into CONGTY values ('CTY03', 'Cong Ty 03', 'Ready', 'Thanh pho 03')

insert into SANPHAM values ('SP01', 'San Pham 01', 'Lam', 100, 15000)
insert into SANPHAM values ('SP02', 'San Pham 02', 'Lam', 150, 10000)
insert into SANPHAM values ('SP03', 'San Pham 03', 'Lam', 200, 20000)

insert into CUNGUNG values ('CTY01', 'SP01', 10)
insert into CUNGUNG values ('CTY01', 'SP02', 20)
insert into CUNGUNG values ('CTY01', 'SP03', 50)
insert into CUNGUNG values ('CTY02', 'SP02', 15)
insert into CUNGUNG values ('CTY03', 'SP02', 30)


-- Check data in database

select * from CONGTY
select * from SANPHAM
select * from CUNGUNG

-- cau 02:
create procedure cau02(@tenCongTy nvarchar(50))
as
	begin
		declare @maCongTyImport char(10)
		select @maCongTyImport = MaCT from CONGTY where TenCT = @tenCongTy
		select TenSP, MauSac, SoLuong, GiaBan
		from CUNGUNG inner join SANPHAM on CUNGUNG.MaSP = SANPHAM.MaSP
		inner join CONGTY on CUNGUNG.MaCT = CONGTY.MaCT
		where CUNGUNG.MaCT = @maCongTyImport
	end

select * from CUNGUNG	
execute cau02 'Cong Ty 01'
execute cau02 'Cong Ty 02'
execute cau02 'Cong Ty 03'