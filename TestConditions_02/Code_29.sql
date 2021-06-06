create database condition_02_code_29

use condition_02_code_29

--drop table BENHNHAN
--drop table KHOAKHAM

create table BENHVIEN (
	MaBV char(10) primary key,
	TenBV nvarchar(50)
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
	constraint FK_BENHNHAN foreign key (MaKhoa) references KHOAKHAM(MaKhoa) on update cascade on delete cascade
)

insert into BENHVIEN values ('BV01', 'Benh vien 01')
insert into BENHVIEN values ('BV02', 'Benh vien 02')

insert into KHOAKHAM values ('KH01', 'Khoa 01', 3, 'BV01')
insert into KHOAKHAM values ('KH02', 'Khoa 02', 4, 'BV02')

insert into BENHNHAN values ('BN01', 'Benh nhan 01', '2/25/2001', 0, 10, 'KH01')
insert into BENHNHAN values ('BN02', 'Benh nhan 02', '10/17/1999', 1, 10, 'KH01')
insert into BENHNHAN values ('BN03', 'Benh nhan 03', '2/25/2000', 1, 10, 'KH01')
insert into BENHNHAN values ('BN04', 'Benh nhan 04', '2/25/1995', 0, 10, 'KH02')
insert into BENHNHAN values ('BN05', 'Benh nhan 05', '2/25/1997', 0, 10, 'KH02')
insert into BENHNHAN values ('BN06', 'Benh nhan 06', '2/25/2001', 1, 10, 'KH02')
insert into BENHNHAN values ('BN07', 'Benh nhan 07', '2/25/2001', 0, 10, 'KH02')
-- giới tính 0: bệnh nhân nam
-- giới tính 1: bệnh nhân nữ

select * from BENHVIEN
select * from KHOAKHAM
select * from BENHNHAN

-- cau 02:
alter procedure cau02(@maKhoa char(10))
as
	begin
		declare @soBenhNhan int
		select TenKhoa, COUNT(MaBN) as 'SoNguoi'
		from KHOAKHAM inner join BENHNHAN on KHOAKHAM.MaKhoa = BENHNHAN.MaKhoa
		where KHOAKHAM.MaKhoa = @maKhoa and GioiTinh = 1
		group by TenKhoa
	end

select * from KHOAKHAM
select * from BENHNHAN
execute cau02 'KH01'

-- cau 03:
create trigger cau03 on BENHNHAN
for insert
as
	begin
		declare @maKhoaInsert char(10), @soBenhNhanHienTai int
		select @maKhoaInsert = MaKhoa from inserted
		if (not exists (select * from KHOAKHAM where MaKhoa = @maKhoaInsert))
			begin
				raiserror (N'Không tồn tại mã khoa.', 16, 1)
				rollback transaction
			end
		else
			begin
				select @soBenhNhanHienTai = COUNT(MaBN) from BENHNHAN where MaKhoa = @maKhoaInsert
				update KHOAKHAM set SoBenhNhan = @soBenhNhanHienTai where MaKhoa = @maKhoaInsert
			end			
	end

select * from KHOAKHAM
select * from BENHNHAN
alter table BENHNHAN nocheck constraint all
--insert into BENHNHAN values ('BN09', 'Benh nhan 08', '2/25/2001', 0, 10, 'KH05') -- mã khoa KH05 không tồn tại.
insert into BENHNHAN values ('BN08', 'Benh nhan 08', '2/25/2001', 0, 10, 'KH01') -- hợp lệ
select * from KHOAKHAM
select * from BENHNHAN