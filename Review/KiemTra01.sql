create database de_kiem_tra_01

use de_kiem_tra_01

create table BENHVIEN (
	MaBV char(10) primary key,
	TenBV nvarchar(50),
	DiaChi nvarchar(50),
	DienThoai int
)

create table KHOAKHAM (
	MaKhoa char(10) primary key,
	TenKhoa nvarchar(50),
	SoBenhNhan int,
	MaBV char(10),
	constraint FK_KHOAKHAM foreign key (MaBV) references BENHVIEN(MaBV) on update cascade on delete cascade
)

create table BENHNHAN (
	MaBN char(10) primary key,
	HoTen nvarchar(50),
	NgaySinh date,
	GioiTinh bit,
	SoNgayNV int,
	MaKhoa char(10),
	DienThoai varchar(15),
	constraint FK_BENHNHAN foreign key (MaKhoa) references KHOAKHAM(MaKhoa) on update cascade on delete cascade
)

insert into BENHVIEN values ('BV01', 'Benh vien 01', 'Dia chi 01', 457878788)
insert into BENHVIEN values ('BV02', 'Benh vien 02', 'Dia chi 02', 121212121)

insert into KHOAKHAM values ('K01', 'Khoa 01', 20, 'BV01')
insert into KHOAKHAM values ('K02', 'Khoa 02', 30, 'BV02')

insert into BENHNHAN values ('BN01', 'Benh nhan 01', '04/17/2000', 0, 10, 'K01', '0454545454')
insert into BENHNHAN values ('BN02', 'Benh nhan 02', '04/17/2000', 0, 5, 'K02', '1212121212')
insert into BENHNHAN values ('BN03', 'Benh nhan 03', '04/17/2000', 1, 15, 'K01', '36363636')
insert into BENHNHAN values ('BN04', 'Benh nhan 04', '04/17/2000', 1, 5, 'K02', '0454545454')
insert into BENHNHAN values ('BN05', 'Benh nhan 05', '04/17/2000', 0, 20, 'K01', '0454545454')

select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN

-- cau 02:
create procedure cau02 (@tenKhoa nvarchar(50))
as
	begin
		select SUM(SoNgayNV * 120000) as TongTien 
		from BENHNHAN inner join KHOAKHAM on BENHNHAN.MaKhoa = KHOAKHAM.MaKhoa
		where TenKhoa = @tenKhoa
	end


select * from KHOAKHAM
select * from BENHNHAN
execute cau02 'Khoa 01'
execute cau02 'Khoa 02'
select * from KHOAKHAM
select * from BENHNHAN

--cau 03:
alter trigger cau03
on BENHNHAN
for insert
as
	begin
		declare @soLuongKyTuSDT int
		select @soLuongKyTuSDT = LEN(DienThoai) from inserted
		if (@soLuongKyTuSDT != 10)
			begin
				raiserror (N'Số điện thoại bênh nhân không hợp lệ.', 16, 1)
				rollback transaction
			end
	end

select * from BENHNHAN
--insert into BENHNHAN values ('BN06', 'Benh nhan 06', '04/17/2000', 0, 10, 'K01', 0454545) -- số điện thoại không hợp lệ
insert into BENHNHAN values ('BN06', 'Benh nhan 06', '04/17/2000', 0, 10, 'K01', '4121223235') -- số điện thoại hợp lệ
select * from BENHNHAN








