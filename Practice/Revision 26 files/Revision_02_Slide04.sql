create database QLBenhVien_Slide_04

use QLBenhVien_Slide_04

create table BenhVien (
	MaBV char(10) primary key,
	TenBV nvarchar(50),
	DiaChi nvarchar(50),
	DienThoai nvarchar(50)
)

create table KhoaKham (
	MaKhoa char(10) primary key,
	TenKhoa nvarchar(50),
	SoBenhNhan int, 
	MaBV char(10),
	constraint fk_KhoaKham foreign key (MaBV) references BenhVien(MaBV) on update cascade on delete cascade
)

create table BenhNhan (
	MaBN char(10) primary key,
	HoTen nvarchar(50),
	NgaySinh datetime,
	GioiTinh nvarchar(50),
	SoNgayNV int,
	MaKhoa char(10),
	constraint fk_BenhNhan foreign key (MaKhoa) references KhoaKham(MaKhoa) on update cascade on delete cascade
)

insert into BenhVien values('BV01', 'Benh Vien 01', 'Dia Chi 01', '045454545')
insert into BenhVien values('BV02', 'Benh Vien 02', 'Dia Chi 02', '025252525')

insert into KhoaKham values('K01', 'khoa 01', 15, 'BV01')
insert into KhoaKham values('K02', 'khoa 02', 15, 'BV02')
update KhoaKham set TenKhoa = 'Khoa 01' where MaKhoa = 'K01'
update KhoaKham set TenKhoa = 'Khoa 02' where MaKhoa = 'K02'


insert into BenhNhan values('BN01', 'Yasuo', '12/07/2000', 'Nam', 7, 'K01')
insert into BenhNhan values('BN02', 'Zed', '10/27/1999', 'Nam', 6, 'K01')
insert into BenhNhan values('BN03', 'Yone', '02/17/2000', 'Nu', 10, 'K02')
insert into BenhNhan values('BN04', 'Master Yi', '05/08/2002', 'Nam', 3, 'K02')
insert into BenhNhan values('BN05', 'Renekton', '10/06/2003', 'Nu', 5, 'K02')
insert into BenhNhan values('BN06', 'Leblance', '08/05/1998', 'Nam', 7, 'K01')
insert into BenhNhan values('BN07', 'Rengar', '07/25/1998', 'Nu', 7, 'K01')

-- Cau 02: Tạo view đưa ra thống kê số bệnh nhân Nữ của từng khoa khám gồm: MaKhoa, TenKhoa, Số người.
create view cau02
as
	select KhoaKham.MaKhoa, TenKhoa, count(MaBN) as 'So Nguoi'
	from KhoaKham inner join BenhNhan on KhoaKham.MaKhoa = BenhNhan.MaKhoa
	where GioiTinh = 'Nu'
	group by KhoaKham.MaKhoa, TenKhoa

select * from cau02

--cau 03: tạo hàm đưa ra tổng số tiền thu được của từng khoa khám bệnh là bao nhiêu?
--Tham số truyền vào là: TenKhoa, Tien = SoNgayNV * 60000

create function cau03(@TenKhoa nvarchar(50))
returns money
as
	begin
		declare @SumPrice money
		select @SumPrice = sum(SoNgayNV * 60000)
		from KhoaKham inner join BenhNhan on KhoaKham.MaKhoa = BenhNhan.MaKhoa
		where TenKhoa = @TenKhoa 
		return @Sumprice
	end

select dbo.cau03('Khoa 01')
