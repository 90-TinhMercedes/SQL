create database condition_02_code_30

use condition_02_code_30

create table KHOA(
	MaKhoa char(10) primary key,
	TenKhoa nvarchar(50)
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

insert into KHOA values ('K01', 'Khoa 01')
insert into KHOA values ('K02', 'Khoa 02')

insert into LOP values ('L01', 'Lop 01', 3, 'K01')
insert into LOP values ('L02', 'Lop 02', 4, 'K02')

insert into SINHVIEN values ('SV01', 'Sinh Vien 01', '10/25/2001', 0, 'L01')
insert into SINHVIEN values ('SV02', 'Sinh Vien 02', '12/20/1999', 1, 'L01')
insert into SINHVIEN values ('SV03', 'Sinh Vien 03', '10/05/1995', 0, 'L01')
insert into SINHVIEN values ('SV04', 'Sinh Vien 04', '05/17/2005', 0, 'L02')
insert into SINHVIEN values ('SV05', 'Sinh Vien 05', '10/25/2000', 1, 'L02')
insert into SINHVIEN values ('SV06', 'Sinh Vien 06', '10/25/1998', 0, 'L02')
insert into SINHVIEN values ('SV07', 'Sinh Vien 07', '10/25/2004', 1, 'L02')

select * from KHOA
select * from LOP
select * from SINHVIEN

-- cau 02:
alter procedure cau02(@tuTuoi int, @denTuoi int, @tenLop nvarchar(50))
as
	begin
		select SINHVIEN.MaSV, HoTen, NgaySinh, TenLop, TenKhoa, YEAR(GETDATE()) - YEAR(NgaySinh) as Tuoi
		from SINHVIEN inner join LOP on SINHVIEN.MaLop = LOP.MaLop
		inner join KHOA on LOP.MaKhoa = KHOA.MaKhoa
		where @tuTuoi <= (YEAR(GETDATE()) - YEAR(NgaySinh))
		and (YEAR(GETDATE()) - YEAR(NgaySinh)) <= @denTuoi
		and TenLop = @tenLop
	end

select * from SINHVIEN
execute cau02 15, 20, 'Lop 01'
execute cau02 22, 30, 'Lop 01'
execute cau02 15, 20, 'Lop 01'
execute cau02 15, 20, 'Lop 02'



-- cau 03:
create trigger cau03 on SINHVIEN
for delete
as
	begin
		declare @maSinhVienXoa char(10)
		declare @tuoi int, @maLop char(10), @siSoHienTai int
		select @maSinhVienXoa = MaSV, @tuoi = YEAR(GETDATE()) - YEAR(NgaySinh), @maLop = MaLop from deleted
		select @siSoHienTai = COUNT(MaSV) from SINHVIEN where MaLop = @maLop
		if (@tuoi >= 18) 
			begin
				raiserror(N'Sinh viên có tuổi >= 18 không được xoá.', 16, 1)
				rollback transaction
			end 
		else
			update LOP set SiSo = @siSoHienTai where MaLop = @maLop
	end

--update LOP set SiSo = 4 where MaLop = 'L02'
--insert into SINHVIEN values ('SV01', 'Sinh Vien 01', '10/25/2001', 0, 'L01')

select * from LOP
select * from SINHVIEN
--delete SINHVIEN where MaSV = 'SV01' -- sinh viên có tuổi = 20. Không hợp lệ.
delete SINHVIEN where MaSV = 'SV04' -- sinh viên có tuổi = 16. Hợp lệ.
select * from LOP
select * from SINHVIEN