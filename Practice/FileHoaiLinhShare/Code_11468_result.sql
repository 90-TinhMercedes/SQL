create database FileHoaiLinhShare_Code11468

use FileHoaiLinhShare_Code11468

create table KHOA(
	MaKhoa char(10) primary key,
	TenKhoa nvarchar(50),
	SoDienThoai int
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
	GioiTinh nvarchar(50),
	NgaySinh date,
	MaLop char(10),
	constraint FK_SINHVIEN foreign key (MaLop) references LOP(MaLop) on update cascade on delete cascade
)

--drop table SINHVIEN
--drop table LOP

insert into KHOA values ('K01', 'Khoa 01', 12121212)
insert into KHOA values ('K02', 'Khoa 02', 23232323)
insert into KHOA values ('K03', 'Khoa 03', 78787878)

insert into LOP values ('L01', 'Lop 01', 80, 'K01')
insert into LOP values ('L02', 'Lop 02', 50, 'K02')
insert into LOP values ('L03', 'Lop 03', 60, 'K03')

insert into SINHVIEN values ('SV01', 'Sinh vien 01', 'Nam', '10/25/2001', 'L01')
insert into SINHVIEN values ('SV02', 'Sinh vien 02', 'Nu', '11/18/2000', 'L02')
insert into SINHVIEN values ('SV03', 'Sinh vien 03', 'Nu', '10/25/1999', 'L03')
insert into SINHVIEN values ('SV04', 'Sinh vien 04', 'Nu', '08/18/1995', 'L02')
insert into SINHVIEN values ('SV05', 'Sinh vien 05', 'Nam', '05/19/2001', 'L03')

select * from KHOA
select * from LOP
select * from SINHVIEN

-- cau 01:
create function cau02(@tenKhoa nvarchar(50))
returns table
as
	return 
		select MaLop, TenLop, Siso
		from KHOA inner join LOP on KHOA.MaKhoa = LOP.MaKhoa
		where TenKhoa = @tenKhoa

--insert into LOP values ('L04', 'Lop 04', 60, 'K01') -- insert thêm để test :v
select * from KHOA
select * from LOP
select * from dbo.cau02('Khoa 01')
select * from dbo.cau02('Khoa 02')

-- cau 03: 
create procedure cau03(@maSinhVien char(10), @hoTen nvarchar(50), @ngaySinh date, @gioiTinh nvarchar(50), @tenLop nvarchar(50))
as
	begin
		declare @maLopSinhVienInsert char(10)
		if (not exists (select * from LOP where TenLop = @tenLop))
			begin
				print N'Không tồn tại lớp có tên: ' + @tenLop
			end
		else
			begin
				select @maLopSinhVienInsert = MaLop from LOP where TenLop = @tenLop
				insert into SINHVIEN values (@maSinhVien, @hoTen, @gioiTinh, @ngaySinh, @maLopSinhVienInsert)
			end
	end

select * from LOP
select * from SINHVIEN
execute cau03 'SV06', 'Sinh vien 06', '08/22/2000', 'Nam', 'Lop 05' -- tên lớp không tồn tại
execute cau03 'SV06', 'Sinh vien 06', '08/22/2000', 'Nam', 'Lop 04' -- tên lớp tồn tại, hợp lệ
select * from LOP
select * from SINHVIEN

-- cau 04:
create trigger cau04 on SINHVIEN
for update
as
	begin
		declare @siSoLopUpdate int, @maLopUpdate char(10), @maLopOld char(10)
		select @maLopUpdate = MaLop from inserted
		select @maLopOld = MaLop from deleted
		select @siSoLopUpdate = SiSo from LOP where MaLop = @maLopUpdate
		if (@siSoLopUpdate >= 80)
			begin
				raiserror(N'Sĩ số của lớp >= 80, không cho phép thêm sinh viên.', 16, 1)
				rollback transaction
			end
		else
			begin
				update LOP set SiSo = SiSo + 1 where MaLop = @maLopUpdate
				update LOP set SiSo = SiSo - 1 where MaLop = @maLopOld
			end
	end

select * from LOP
select * from SINHVIEN
--update SINHVIEN set MaLop = 'L01' where MaSV = 'SV03'  -- Lớp 01 có sĩ số 80. Không thể update.
update SINHVIEN set MaLop = 'L02' where MaSV = 'SV03'  -- Lớp 01 có sĩ số 50. Hợp lệ.
select * from LOP
select * from SINHVIEN
		