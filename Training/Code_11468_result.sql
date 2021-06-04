create database Training_FileHoaiLinhShare_Code11468

use Training_FileHoaiLinhShare_Code11468

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
create function cau01(@tenKhoa nvarchar(50))
returns table
as
	return
		select MaLop, TenLop, SiSo
		from KHOA inner join LOP on KHOA.MaKhoa = LOP.MaKhoa
		where TenKhoa = @tenKhoa

--insert into LOP values ('L04', 'Lop 04', 60, 'K01') -- insert thêm để test :v
select * from KHOA
select * from LOP
select * from cau01('Khoa 01')

-- cau 02:
alter procedure cau03(@maSinhVien char(10), @hoTen nvarchar(50), @ngaySinh date, @gioiTinh nvarchar(50), @tenLop nvarchar(50))
as
	begin
		declare @maLopInsert char(10)
		if(not exists (select * from LOP where TenLop = @tenLop))
			begin
				print N'Tên lớp: ' + @tenLop + N' không tồn tại.'
			end
		else
			begin
				select @maLopInsert = MaLop from LOP where TenLop = @tenLop
				insert into SINHVIEN values (@maSinhVien, @hoTen, @gioiTinh, @ngaySinh, @maLopInsert)	
			end
	end

select * from SINHVIEN
--execute cau03 'SV06', 'Sinh vien 05', '06/06/2001', 'female', 'Lop 05' -- Lop 05 không tồn tại
execute cau03 'SV06', 'Sinh vien 06', '06/06/2001', 'female', 'Lop 04' -- Lop 04 tồn tại
select * from SINHVIEN


-- cau 04
create trigger cau04 on SINHVIEN
for update
as
	begin
		declare @maLopCu char(10), @maLopMoi char(10), @siSoLopChuyenDen int
		select @maLopCu = MaLop from deleted
		select @maLopMoi = MaLop from inserted
		select @siSoLopChuyenDen = SiSo from LOP where MaLop = @maLopMoi
		if (@siSoLopChuyenDen >= 80)
			begin
				raiserror(N'Sĩ số lớp mới >= 80, không cho phép cập nhật', 16, 1)
				rollback transaction
			end
		else
			begin
				update LOP set SiSo = SiSo - 1 where MaLop = @maLopCu
				update LOP set SiSo = SiSo + 1 where MaLop = @maLopMoi
			end
	end

select * from LOP
select * from SINHVIEN
--update SINHVIEN set MaLop = 'L01' where MaSV = 'SV06' -- Lớp 01 đã có 80 sinh viên, không thể update
update SINHVIEN set MaLop = 'L02' where MaSV = 'SV06' -- Lớp 02 có 50 sinh viên, hợp lệ
select * from LOP
select * from SINHVIEN
