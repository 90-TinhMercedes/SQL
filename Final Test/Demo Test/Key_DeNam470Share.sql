create database DeNam470Share

use DeNam470Share

create table KHOA (
	MaKhoa char(10) primary key,
	TenKhoa nvarchar(50),
	NgayThanhLap date
)

create table LOP (
	MaLop char(10) primary key,
	TenLop nvarchar(50),
	SiSo int,
	MaKhoa char(10),
	constraint FK_LOP foreign key (MaKhoa) references KHOA(MaKhoa) on update cascade on delete cascade
)

create table SINHVIEN (
	MaSV char(10) primary key,
	HoTen nvarchar(50),
	NgaySinh date,
	MaLop char(10),
	constraint FK_SINHVIEN foreign key (MaLop) references LOP(MaLop) on update cascade on delete cascade
)

insert into KHOA values ('KH01', 'Khoa 01', '05/27/1995')
insert into KHOA values ('KH02', 'Khoa 02', '05/27/1995')
insert into KHOA values ('KH03', 'Khoa 03', '05/27/1995')

insert into LOP values ('L01', 'Lop 01', 1, 'KH01')
insert into LOP values ('L02', 'Lop 02', 2, 'KH02')
insert into LOP values ('L03', 'Lop 03', 2, 'KH03')

insert into SINHVIEN values ('SV01', 'Sinh vien 01', '07/26/2000', 'L01')
insert into SINHVIEN values ('SV02', 'Sinh vien 02', '07/26/2000', 'L02')
insert into SINHVIEN values ('SV03', 'Sinh vien 03', '07/26/2000', 'L02')
insert into SINHVIEN values ('SV04', 'Sinh vien 04', '07/26/2000', 'L03')
insert into SINHVIEN values ('SV05', 'Sinh vien 05', '07/26/2000', 'L03')

select * from KHOA
select * from LOP
select * from SINHVIEN

-- cau 04:
alter trigger cau01 on SINHVIEN for delete
as
	begin
		declare @maSinhVienDelete char(10), @maLopLopDelete char(10), @siSoLopDelete int
		select @maSinhVienDelete = MaSV, @maLopLopDelete = MaLop from deleted
		if (not exists (select * from deleted where MaSV = @maSinhVienDelete))
			begin
				raiserror (N'Mã sinh viên không tồn tại.', 16, 1)
				rollback transaction
			end
		else
			begin
				select @siSoLopDelete = COUNT(MaSV) from SINHVIEN where MaLop = @maLopLopDelete
				update LOP set SiSo = @siSoLopDelete where MaLop = @maLopLopDelete
			end
	end

select * from LOP
select * from SINHVIEN
delete SINHVIEN where MaSV = 'SV03'
select * from LOP
select * from SINHVIEN