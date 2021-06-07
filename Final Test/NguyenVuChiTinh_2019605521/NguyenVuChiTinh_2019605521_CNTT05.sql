-- Họ và tên: Nguyễn Vũ Chí Tình
-- Mã sinh viên: 2019605521
-- Lớp: 2019DHCNTT05 - K14
-- Mã lớp: 202020503123005


-- BÀI LÀM
-- câu 01:
-- a,
create database QLTruongHoc

use QLTruongHoc 

create table GIAOVIEN (
	MaGV char(10) primary key,
	TenGV nvarchar(50)
)

create table LOP (
	MaLop char(10) primary key,
	TenLop nvarchar(50),
	Phong nvarchar(50),
	SiSo int,
	MaGV char(10),
	constraint FK_LOP foreign key (MaGV) references GIAOVIEN(MaGV) on update cascade on delete cascade
)

create table SINHVIEN (
	MaSV char(10) primary key,
	TenSV nvarchar(50),
	GioiTinh nvarchar(50),
	QueQuan nvarchar(50),
	MaLop char(10),
	constraint FK_SINHVIEN foreign key (MaLop) references LOP(MaLop) on update cascade on delete cascade
)

-- b,
insert into GIAOVIEN values ('GV01', 'Giao Vien 01')
insert into GIAOVIEN values ('GV02', 'Giao Vien 02')
insert into GIAOVIEN values ('GV03', 'Giao Vien 03')

insert into LOP values ('L01', 'Lop 01', 'Phong 01', 1, 'GV01')
insert into LOP values ('L02', 'Lop 02', 'Phong 02', 2, 'GV02')
insert into LOP values ('L03', 'Lop 03', 'Phong 03', 2, 'GV02')

insert into SINHVIEN values ('SV01', 'Sinh Vien 01', 'Nam', 'Ha Nam', 'L01')
insert into SINHVIEN values ('SV02', 'Sinh Vien 02', 'Nu', 'Ha Noi', 'L02')
insert into SINHVIEN values ('SV03', 'Sinh Vien 03', 'Nam', 'Hai Phong', 'L02')
insert into SINHVIEN values ('SV04', 'Sinh Vien 04', 'Nam', 'Ha Nam', 'L03')
insert into SINHVIEN values ('SV05', 'Sinh Vien 05', 'Nu', 'Ninh Binh', 'L03')

select * from GIAOVIEN
select * from LOP
select * from SINHVIEN

-- câu 02:
create function cau02(@tenLop nvarchar(50), @tenGiaoVien nvarchar(50))
returns table
as
	return
		select MaSV, TenSV, GioiTinh, QueQuan, SINHVIEN.MaLop
		from GIAOVIEN inner join LOP on GIAOVIEN.MaGV = LOP.MaGV
		inner join SINHVIEN on LOP.MaLop = SINHVIEN.MaLop
		where TenLop = @tenLop and TenGV = @tenGiaoVien

-- Test cau 02:
select * from GIAOVIEN
select * from LOP
select * from SINHVIEN
--select * from cau02('Lop 02', 'Giao Vien 02') -- Lop 02 và Giao Vien 02 có 2 sinh viên
select * from cau02('Lop 01', 'Giao Vien 01') -- Lop 01 và Giao Vien 01 có 1 sinh viên


-- câu 03:
create procedure cau03(@maSV char(10), @tenSV nvarchar(50), @gioiTinh nvarchar(50), @queQuan nvarchar(50), @tenLop nvarchar(50))
as
	begin
		declare @maLopThemSinhVien char(10)
		if (not exists (select * from LOP where TenLop = @tenLop))
			begin
				print N'Tên lớp: ' + @tenLop + N' không tồn tại.'
			end
		else
			begin
				select @maLopThemSinhVien = MaLop from LOP where TenLop = @tenLop
				insert into SINHVIEN values (@maSV, @tenSV, @gioiTinh, @queQuan, @maLopThemSinhVien)
			end
	end


select * from LOP
select * from SINHVIEN
--execute cau03 'SV06', 'Sinh vien 06', 'Nu', 'Ha Noi', 'Lop 99' -- Tên lớp: Lop 99 không tồn tại
execute cau03 'SV06', 'Sinh vien 06', 'Nu', 'Ha Noi', 'Lop 03' -- Tên lớp: Lop 03 tồn tại. Hợp lệ
select * from LOP
select * from SINHVIEN


-- câu 04:
create trigger cau04 on SINHVIEN
for update
as
	begin
		declare @maLopCu char(10), @maLopMoi char(10), @siSoLopCu int, @siSoLopMoi int
		select @maLopCu = MaLop from deleted
		select @maLopMoi = MaLop from inserted
		select @siSoLopCu = COUNT(MaSV) from SINHVIEN where MaLop = @maLopCu
		select @siSoLopMoi = COUNT(MaSV) from SINHVIEN where MaLop = @maLopMoi
		update LOP set SiSo = @siSoLopCu where MaLop = @maLopCu
		update LOP set SiSo = @siSoLopMoi where MaLop = @maLopMoi
	end

select * from LOP
select * from SINHVIEN
update SINHVIEN set MaLop = 'L03' where MaSV = 'SV02' -- Chuyển sinh viên L02 sang L03
select * from LOP
select * from SINHVIEN