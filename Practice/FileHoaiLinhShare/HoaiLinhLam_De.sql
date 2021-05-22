create database QLSV_HoaiLinhLam
go
use QLSV_HoaiLinhLam
go
create table Khoa
(
	MaKhoa char(4) not null primary key,
	TenKhoa nvarchar(30),
	SoDienThoai nchar(10)
)
create table Lop
(
	MaLop char(4) not null primary key,
	TenLop nvarchar(30),
	SiSo int,
	MaKhoa char(4),
	constraint fk_Lop foreign key (MaKhoa) references Khoa(MaKhoa) on delete cascade on update cascade
)
create table SinhVien
(
	MaSV char(4) not null primary key,
	HoTen nvarchar(30),
	GioiTinh char(4),
	NgaySinh date,
	MaLop char(4),
	constraint fk_SinhVien foreign key (MaLop) references Lop(MaLop) on delete cascade on update cascade
)

insert into Khoa values
	('MK01',N'Tên khoa 01',0123456789),
	('MK02',N'Tên khoa 02',0123456780),
	('MK03',N'Tên khoa 03',0123456781)

insert into Lop values
	('ML01',N'Tên lớp 01',32,'MK01'),
	('ML02',N'Tên lớp 02',33,'MK02'),
	('ML03',N'Tên lớp 03',34,'MK03')

insert into SinhVien values
	('MSV1',N'Nguyễn Thị A','nu','02/13/2001','ML01'),
	('MSV2',N'Nguyễn Thị B','nu','03/13/2001','ML02'),
	('MSV3',N'Nguyễn Thị C','nu','04/13/2001','ML03'),
	('MSV4',N'Nguyễn Văn A','nam','05/13/2001','ML01'),
	('MSV5',N'Nguyễn Văn B','nam','06/13/2001','ML02')

select *from Khoa
select *from Lop
select *from SinhVien


-- cau 02:
create function cau2 (@tenkhoa nvarchar(30))
returns table
as
	return
	select Lop.MaLop,TenLop,SiSo from Lop inner join Khoa on Lop.MaKhoa=Khoa.MaKhoa
	where @tenkhoa = TenKhoa

select *from Khoa
select *from Lop
select *from cau2 (N'Tên khoa 01')


-- cau 03:
create proc cau3 (@masv char(4), @hoten nvarchar(30), @gioitinh char(4),@ngaysinh date, @tenlop nvarchar(30))
as
	begin
		declare @malop char(4)
		select @malop=MaLop from Lop where @tenlop=TenLop
		if(not exists(select *from Lop where @tenlop=TenLop))
			begin
				print N'Lớp không tồn tại.'
			end
		else
			begin
				insert into SinhVien values (@masv,@hoten,@gioitinh,@ngaysinh,@malop)
			end
	end
select *from Lop
select *from SinhVien
--execute cau3 'MSV6',N'Nguyễn Ngọc A','nu', '03/11/2001',N'Tên lớp 05' -- Lớp không tồn tại
execute cau3 'MSV6',N'Nguyễn Ngọc A','nu', '03/11/2001',N'Tên lớp 02' -- Hợp lệ
select *from SinhVien