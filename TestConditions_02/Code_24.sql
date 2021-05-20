create database QLDA_Code24

use QLDA_Code24

create table NHANVIEN (
	MaNV char(10) primary key,
	TenNV nvarchar(50),
	GioiTinh nvarchar(50),
	HeSoLuong float
)

create table DUAN (
	MaDA char(10) primary key,
	TenDA nvarchar(50),
	NgayBatDau date,
	SoLuongNV int
)

create table THAMGIA (
	MaNV char(10),
	MaDA char(10),
	NhiemVu nvarchar(50),
	constraint PK_THAMGIA primary key (MaNV, MaDA),
	constraint FK_THAMGIA_01 foreign key (MaNV) references NHANVIEN(MaNV) on update cascade on delete cascade,
	constraint FK_THAMGIA_02 foreign key (MaDA) references DUAN(MaDA) on update cascade on delete cascade
)

insert into NHANVIEN values ('NV01', 'Nhan vien 01', 'Nam', 2.5)
insert into NHANVIEN values ('NV02', 'Nhan vien 02', 'Nam', 1.7)
insert into NHANVIEN values ('NV03', 'Nhan vien 03', 'Nu', 2.2)

insert into DUAN values ('DA01', 'Du an 01', '04/17/2021', 2)
insert into DUAN values ('DA02', 'Du an 02', '04/17/2021', 2)
insert into DUAN values ('DA03', 'Du an 03', '04/17/2021', 3)

insert into THAMGIA values ('NV01', 'DA01', 'Nhiem vu 01')
insert into THAMGIA values ('NV01', 'DA02', 'Nhiem vu 02')
insert into THAMGIA values ('NV02', 'DA01', 'Nhiem vu 03')
insert into THAMGIA values ('NV03', 'DA02', 'Nhiem vu 04')
insert into THAMGIA values ('NV01', 'DA03', 'Nhiem vu 05')
insert into THAMGIA values ('NV02', 'DA03', 'Nhiem vu 06')
insert into THAMGIA values ('NV03', 'DA03', 'Nhiem vu 07')

select * from NHANVIEN
select * from DUAN
select * from THAMGIA

-- Cau 02:
alter procedure cau02 (@maNV char(10), @heSoLuong float)
as
	begin
		declare @heSoLuongHienTai float
		select @heSoLuongHienTai = (select HeSoLuong from NHANVIEN where MaNV = @maNV)
		if (not exists (select * from NHANVIEN where @maNV = MaNV))
			begin
				print N'Mã nhân viên ' + @maNV + N' không tồn tại.'
			end
		else if (@heSoLuongHienTai > @heSoLuong)
			begin
				print N'Hệ số lương vừa nhập nhỏ hơn Hệ số lương hiện tại. Không cho phép update.'
			end
		else
			update NHANVIEN set HeSoLuong = @heSoLuong where MaNV = @maNV
	end

select * from NHANVIEN
execute cau02 'NV05', '3.0' -- Mã nhân viên không tồn tại. Loại
select * from NHANVIEN

-- Cau 03:

create trigger cau03
on THAMGIA
for insert
as
	begin
		declare @heSoLuongNhanVien float
		declare @maDuAn char(10)
		declare @soLuongNhanVienTrongDuAn int
		select @heSoLuongNhanVien = HeSoLuong, @maDuAn = inserted.MaDA 
		from inserted inner join DUAN on DUAN.MaDA = inserted.MaDA
		inner join NHANVIEN on NHANVIEN.MaNV = inserted.MaNV
		select @soLuongNhanVienTrongDuAn = COUNT(MaDA) from THAMGIA where MaDA = @maDuAn 



	end

select * from NHANVIEN
select * from DUAN
select * from THAMGIA