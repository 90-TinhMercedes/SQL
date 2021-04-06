create database QLSinhVien_De1

use QLSinhVien_De1

create table Khoa (
	MaKhoa char(10) not null primary key,
	TenKhoa nvarchar(50)
)

create table Lop (
	MaLop char(10) primary key,
	TenLop nvarchar(50),
	SiSo int,
	MaKhoa char(10),
	constraint FK_Lop foreign key (MaKhoa) references Khoa(MaKhoa) on update cascade on delete cascade,
	--alter table Lop add constraint df_Lop default (0) for SiSo
)

alter table Lop add constraint df_Lop default (0) for SiSo

create table SinhVien (
	MaSV char(10) primary key,
	HoTen nvarchar(50),
	NgaySinh datetime,
	GioiTinh bit,
	MaLop char(10),
	constraint FK_SinhVien foreign key (MaLop) references Lop(MaLop) on update cascade on delete cascade
)

insert into Khoa values('K01', 'Khoa 01')
insert into Khoa values('K02', 'Khoa 02')


insert into Lop values('L01', 'Lop 01', null, 'K01')
update Lop set SiSo = 15 where MaLop = 'L01'
insert into Lop values('L02', 'Lop 02', 25, 'K02')
insert into Lop values('L03', 'Lop 03', 20, 'K01')

insert into SinhVien values('SV01', 'Tinh Handsome', '03/06/2001', 0, 'L01')
insert into SinhVien values('SV02', 'Tinh Mercedes', '12/07/2000', 0, 'L02')
insert into SinhVien values('SV03', 'Tinh Veigar', '08/06/2001', 1, 'L01')
insert into SinhVien values('SV04', 'Tinh Vjp', '11/25/1999', 1, 'L01')
insert into SinhVien values('SV05', 'Tinh Renekton', '07/17/2000', 0, 'L02')
insert into SinhVien values('SV06', 'Tinh Ashe', '03/16/2001', 1, 'L02')
insert into SinhVien values('SV07', 'Tinh Yasuo', '06/27/2000', 0, 'L01')

select * from Khoa
select * from Lop
select * from SinhVien

-- Câu 2 (3 đ): Hãy tạo View đưa ra thống kê số lớp của từng khoa gồm các thông tin: TenKhoa, Số lớp.
alter view cau2 
as 
	select TenKhoa, count(MaLop) as 'SoLop' from Khoa inner join Lop on Khoa.MaKhoa = Lop.MaKhoa
	group by TenKhoa
	
select * from cau2 


-- Câu 3 (2đ): Viết hàm với tham số truyền vào là MaKhoa, hàm trả về một bảng gồm các thông tin:
--MaSV, HoTen, NgaySinh, GioiTinh (là “Nam“ hoặc “Nữ“), TenLop, TenKhoa. 
alter function cau3 (@MaKhoa char(10))
returns @ThongKe table (MaSV char(10), HoTen nvarchar(50), NgaySinh datetime, GioiTinh nvarchar(50), TenLop nvarchar(50), TenKhoa nvarchar(50))
as 
	begin
		insert into @ThongKe
		select MaSV, HoTen, NgaySinh, case when GioiTinh = 0 then 'Nu' when GioiTinh = 1 then 'Nam' end,
		TenLop, TenKhoa from Khoa inner join Lop on Khoa.MaKhoa = Lop.MaKhoa
		inner join SinhVien on Lop.MaLop = SinhVien.MaLop
		where Lop.MaKhoa = @MaKhoa
		return
	end
--Test

select * from Khoa
select * from Lop
select * from SinhVien
select * from cau3('K01')
select * from cau3('K02')

--Câu 4 (3đ): Hãy tạo thủ tục lưu trữ tìm kiếm sinh viên theo khoảng tuổi và lớp (Với 3 tham số 
--vào là: TuTuoi và DenTuoi và tên lớp). Kết quả tìm được sẽ đưa ra một danh sách 
--gồm: MaSV, HoTen, NgaySinh,TenLop,TenKhoa, Tuoi. 

create procedure cau4(@tuTuoi int, @denTuoi int, @tenLop nvarchar(50))
as
	begin
		select MaSV, HoTen, NgaySinh, TenLop, TenKhoa, year(GETDATE()) - YEAR(SinhVien.NgaySinh) as Tuoi
		from Khoa inner join Lop on Khoa.MaKhoa = Lop.MaKhoa
		inner join SinhVien on Lop.MaLop = SinhVien.MaLop
		where (year(GETDATE()) - YEAR(SinhVien.NgaySinh)) between @tuTuoi and @denTuoi
		and TenLop = @tenLop
	end

select * from Khoa
select * from Lop
select * from SinhVien
execute cau4 19, 20, 'Lop 01'




