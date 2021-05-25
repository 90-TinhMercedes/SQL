create database condition_02_code_28

use condition_02_code_28

create table KHOA(
	MaKhoa char(10) primary key,
	TenKhoa nvarchar(50),
)

create table LOP(
	MaLop char(10) primary key,
	TenLop nvarchar(50),
	SiSo int,
	MaKhoa char(10),
	constraint FK_LOP foreign key (MaKhoa) references KHOA(MaKhoa) on update cascade on delete cascade
)
 
create table SINHVIEN(
	MaSV char(10) primary key,
	HoTen nvarchar(50),
	NgaySinh date,
	GioiTinh bit,
	MaLop char(10),
	constraint FK_SINHVIEN foreign key (MaLop) references LOP(MaLop) on update cascade on delete cascade
)

--drop table SINHVIEN
--drop table LOP

insert into KHOA values ('K01', 'Khoa 01')
insert into KHOA values ('K02', 'Khoa 02')

insert into LOP values ('L01', 'Lop 01', 3, 'K01')
insert into LOP values ('L02', 'Lop 02', 4, 'K02')

insert into SINHVIEN values ('SV01', 'Sinh vien 01', '10/25/2001', 0, 'L01')
insert into SINHVIEN values ('SV02', 'Sinh vien 02', '10/25/2001', 1, 'L02')
insert into SINHVIEN values ('SV03', 'Sinh vien 03', '10/25/2001', 0, 'L02')
insert into SINHVIEN values ('SV04', 'Sinh vien 04', '10/25/2001', 1, 'L02')
insert into SINHVIEN values ('SV05', 'Sinh vien 05', '10/25/2001', 1, 'L01')
insert into SINHVIEN values ('SV06', 'Sinh vien 06', '10/25/2001', 1, 'L01')
insert into SINHVIEN values ('SV07', 'Sinh vien 07', '10/25/2001', 0, 'L02')

select * from KHOA
select * from LOP
select * from SINHVIEN

-- cau 02:
alter function cau02(@maKhoa char(10))
returns table
as
	return
		select MaSV, HoTen, NgaySinh, 
		CASE(GioiTinh) when 0 then 'Nam' when 1 then 'Nu' end as GioiTinh,
		TenLop, TenKhoa
		from SINHVIEN inner join LOP on SINHVIEN.MaLop = LOP.MaLop
		inner join KHOA on KHOA.MaKhoa = LOP.MaKhoa
		where KHOA.MaKhoa = @maKhoa

select * from KHOA
select * from LOP
select * from SINHVIEN
select * from dbo.cau02('K01')
select * from dbo.cau02('K02')

-- cau 03:
create trigger cau03 on SINHVIEN
for insert
as
	begin
		declare @siSoLopInsert int
		declare @maLopSinhVienInsert char(10), @tuoiSinhVienInsert int
		select @maLopSinhVienInsert = MaLop, @tuoiSinhVienInsert =  YEAR(GETDATE()) - YEAR(NgaySinh) from inserted
		select @siSoLopInsert = COUNT(MaSV) from SINHVIEN where MaLop = @maLopSinhVienInsert
		if(@tuoiSinhVienInsert < 18)
			begin
				raiserror(N'Sinh viên không đủ 18 tuổi. Không được thêm.', 16, 1)
				rollback transaction
			end
		else
			begin
				update LOP set SiSo = @siSoLopInsert where MaLop = @maLopSinhVienInsert
			end
	end

select * from LOP
select * from SINHVIEN
--insert into SINHVIEN values ('SV08', 'Sinh vien 08', '10/25/2008', 0, 'L02') -- sinh viên tuổi < 18. Không hợp lệ
insert into SINHVIEN values ('SV08', 'Sinh vien 08', '10/25/2001', 0, 'L02') -- hợp lệ
select * from LOP
select * from SINHVIEN