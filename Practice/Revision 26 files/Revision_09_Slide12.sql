--Câu 1(3đ): Tạo csdl QLSinhVien gồm 3 bảng: 
--+ Khoa(MaKhoa,TenKhoa)
--+ Lop(MaLop, TenLop, SiSo, MaKhoa)
--+ SinhVien(MaSV, HoTen, NgaySinh, GioiTinh(bit), MaLop)

create database QLSinhVien_Slide12

use QLSinhVien_Slide12

create table KHOA (
	MaKhoa char(10) not null primary key,
	TenKhoa nvarchar(50)
)

create table LOP (
	MaLop char(10) primary key,
	TenLop nvarchar(50),
	SiSo int,
	MaKhoa char(10),
	constraint FK_Lop foreign key (MaKhoa) references KHOA(MaKhoa) on update cascade on delete cascade,
)

create table SINHVIEN (
	MaSV char(10) primary key,
	HoTen nvarchar(50),
	NgaySinh datetime,
	GioiTinh bit,
	MaLop char(10),
	constraint FK_SinhVien foreign key (MaLop) references LOP(MaLop) on update cascade on delete cascade
)

insert into KHOA values('K01', 'Khoa 01')
insert into KHOA values('K02', 'Khoa 02')

insert into LOP values('L01', 'Lop 01', 15, 'K01')
insert into LOP values('L02', 'Lop 02', 25, 'K02')
insert into LOP values('L03', 'Lop 03', 20, 'K01')

insert into SINHVIEN values('SV01', 'Tinh Handsome', '03/06/2001', 0, 'L01')
insert into SINHVIEN values('SV02', 'Tinh Mercedes', '12/07/2000', 0, 'L02')
insert into SINHVIEN values('SV03', 'Tinh Veigar', '08/06/2001', 1, 'L01')
insert into SINHVIEN values('SV04', 'Tinh Vjp', '11/25/1999', 1, 'L01')
insert into SINHVIEN values('SV05', 'Tinh Renekton', '07/17/2000', 0, 'L02')
insert into SINHVIEN values('SV06', 'Tinh Ashe', '03/16/2001', 1, 'L02')
insert into SINHVIEN values('SV07', 'Tinh Yasuo', '06/27/2000', 0, 'L01')
insert into SINHVIEN values('SV08', 'Tinh Yone', '06/27/1995', 0, 'L03')

select * from KHOA
select * from LOP
select * from SINHVIEN

--Câu 2(2đ): Đưa ra những sinh viên ít tuổi nhất (của một khoa nào đó) gồm: MaSV, HoTen, Tuổi.
-- xử lý bằng tạo view

alter view cau02
as
	select MaSV, HoTen, year(getdate()) - year(NgaySinh) as Tuoi
	from LOP inner join SINHVIEN on LOP.MaLop = SINHVIEN.MaLop
	where NgaySinh = (select max(NgaySinh) from SINHVIEN)


select * from cau02

--Câu 3(2đ): Hãy tạo thủ tục lưu trữ tìm kiếm sinh viên theo khoảng tuổi 
--(Với 2 tham số vào là: TuTuoi và DenTuoi). 
--Kết quả tìm được sẽ đưa ra một danh sách gồm: MaSV, HoTen, NgaySinh,TenLop,TenKhoa, Tuoi.  

-- xử lý bằng tạo hàm
create function cau03_function(@TuTuoi int, @DenTuoi int)
returns @ThongKe table (MaSV char(10), HoTen nvarchar(50), NgaySinh datetime, TenLop nvarchar(50),
TenKhoa nvarchar(50), Tuoi int)
as
	begin
		insert into @ThongKe
		select MaSV, HoTen, NgaySinh, TenLop, TenKhoa, year(getdate()) - year(NgaySinh) as Tuoi
		from KHOA inner join LOP on KHOA.MaKhoa = LOP.MaKhoa inner join SINHVIEN on LOP.MaLop = SINHVIEN.MaLop
		where @TuTuoi <= year(getdate()) - year(NgaySinh) and year(getdate()) - year(NgaySinh) <= @DenTuoi
		return

	end

select * from cau03_function(25, 27)
select * from cau03_function(20, 21)
select * from cau03_function(19, 20)


--Câu 3(2đ): Hãy tạo thủ tục lưu trữ tìm kiếm sinh viên theo khoảng tuổi 
--(Với 2 tham số vào là: TuTuoi và DenTuoi). Kết quả tìm được sẽ đưa ra một danh sách 
--gồm: MaSV, HoTen, NgaySinh,TenLop,TenKhoa, Tuoi.  

create procedure cau3 (@tuTuoi int, @denTuoi int)
as
	begin
		select MaSV, HoTen, NgaySinh, TenLop, TenKhoa, YEAR(GETDATE()) - YEAR(NgaySinh) as Tuoi
		from KHOA inner join LOP on KHOA.MaKhoa = LOP.MaKhoa
		inner join SINHVIEN on LOP.MaLop = SINHVIEN.MaLop
		where @tuTuoi <= YEAR(GETDATE()) - YEAR(NgaySinh) and YEAR(GETDATE()) - YEAR(NgaySinh) <= @denTuoi
	end

select * from KHOA
select * from LOP
select * from SINHVIEN
execute cau3 19, 20
execute cau3 22, 30


--Câu 4(3đ): Hãy tạo Trigger để tự động tăng sĩ số sinh viên trong bảng lớp, 
--mỗi khi thêm mới dữ liệu cho bảng Sinh viên. 
--Nếu sĩ số trong 1 lớp > 20 thì không cho thêm và đưa ra cảnh báo.

create trigger cau4
on SINHVIEN
for insert
as
	begin
		declare @siSoHienTai int
		declare @maLopThemSinhVien char(10)
		select @siSoHienTai = SiSo from LOP
		select @maLopThemSinhVien = MaLop from inserted
		if (@siSoHienTai > 20)
			begin
				raiserror (N'Error: Lớp đã có nhiều hơn 20 sinh viên, không thể thêm.', 16, 1)
				rollback transaction
			end
		else
			update LOP set SiSo = SiSo + 1 where MaLop = @maLopThemSinhVien
	end

select * from KHOA
select * from LOP
select * from SINHVIEN
--insert into SINHVIEN values('SV09', 'Tinh Sivir', '06/27/1995', 0, 'L03')
insert into SINHVIEN values('SV10', 'Tinh Malphite', '06/27/1995', 0, 'L03')
select * from KHOA
select * from LOP
select * from SINHVIEN








