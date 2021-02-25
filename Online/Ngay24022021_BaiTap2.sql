
create database QUANLYSV
go
use QUANLYSV


create table LOP(
	maLop varchar(20) not null primary key ,
	tenLop varchar(20) not null,
	phong varchar(20) not null,
)

create table SinhVien (
	maSV varchar(20) not null primary key,
	tenSV varchar(20) not null,
	maLop varchar(20) not null,
	constraint fk_SinhVien_Lop foreign key (maLop) references LOP(maLop) on delete cascade on update cascade
)

--Tạo bảng CSDL
insert into LOP values ( '1', 'CD', '1')
insert into LOP values ( '2', 'DH', '2')
insert into LOP values ( '3', 'LT', '2')
insert into LOP values ( '4', 'CH', '4')

select * from LOP

insert into SinhVien values ( '1', 'A', '1')
insert into SinhVien values ( '2', 'B', '2')
insert into SinhVien values ( '3', 'C', '1')
insert into SinhVien values ( '4', 'D', '3')

select * from SinhVien


-- Câu 1: Viểt hàm thống kê xem mỗi lớp có bao nhiêu sinh viên với malop là tham số truyền vào từ bàn phím 

create function ThongKe(@malop varchar(20) )
returns int as
begin 
	declare @soluong int 
	select @soluong = count(SinhVien.maSV) 
	from SinhVien,LOP
	where SinhVien.maLop = LOP.maLop  and LOP.maLop = @maLop
	Group by LOP.tenLop
	return @soluong
end

create function ThongKe2(@malop int)
returns int
as
begin
	declare @sl int
	select @sl=count(*)
	from SinhVien 
	where SinhVien.MaLop =@malop
	return @sl
end;

select dbo.ThongKe('1')
select dbo.ThongKe2('1')

-- Câu 2: Ðưa ra danh sách sinh viên (masv,tensv) học lớp với tenlop được truyền vào từ bàn phím 

create function cau2(@tenLop varchar(20))
returns table 
return (
	select SinhVien.maSV, SinhVien.tenSV  
	from  SinhVien inner join LOP on  LOP.maLop = SinhVien.maLop
	where LOP.tenLop = @tenLop
	group by SinhVien.maSV, SinhVien.tenSV 
)

select * from dbo.cau2('CD')


/* Câu 3:  Đưa ra hàm thống kê sinhvien: malop,tenlop,soluong sinh viên trong lớp, với tên lớp
được nhập từ bàn phím. Nếu lớp đó chưa tồn tại thì thống kê tất cả các lớp, ngược lại nếu
lớp đó đã tồn tại thì chỉ thống kê mỗi lớp đó */

create function ThongKeSV(@tenLop nvarchar(20))
returns @ThongKeSV table (maLop varchar(20), tenLop varchar(20), soluongSV int)
as
begin 
	if(not exists(select maLop from LOP where tenLop = @tenLop))
		insert into @ThongKeSV
		select LOP.maLop, LOP.tenLop, count(SinhVien.maSV)
		from LOP inner join SinhVien on LOP.maLop = SinhVien.maLop
		group by LOP.maLop, LOP.tenLop
	else
		insert into @ThongKeSV
		select LOP.maLop, LOP.tenLop, COUNT(SinhVien.maSV)
		from LOP inner join SinhVien on LOP.maLop = SinhVien.maSV
		where LOP.tenLop = @tenLop
		group by LOP.maLop, LOP.tenLop
		
	return 
end

select * from dbo.ThongKeSV('TIN1')

-- Câu 4: Đưa ra phòng học của tên sinh viên nhập từ bàn phím.

create function cau4_c1(@tenSV varchar(20))
returns int as
begin 
	declare @tenPhong varchar(20)
	select @tenPhong = LOP.phong
	from LOP inner join SinhVien on SinhVien.maLop = LOP.maLop
	group by LOP.phong
	return @tenPhong
end

select dbo.cau4_c1('C')

/* Câu 5:  Đưa ra thống kê masv,tensv, tenlop với tham biến nhập từ bàn phím là phòng. Nếu phòng
không tồn tại thì đưa ra tất cả các sinh viên và các phòng. Neu phòng tồn tại thì đưa ra các
sinh vien của các lớp học phòng đó (Nhiều lớp học cùng phòng). */

create function Cau5(@phong varchar(20))
returns @cau5 table(maSV varchar(20), tenSV varchar(20), tenLop varchar(20))
as 
begin
	if(not exists(select phong from LOP where phong = @phong))
		insert into @cau5
		select SinhVien.maSV, SinhVien.tenSV, LOP.tenLop
		from SinhVien inner join LOP on SinhVien.maLop = LOP.maLop
		group by  SinhVien.maSV, SinhVien.tenSV, LOP.tenLop
	else 
		insert into @cau5
		select SinhVien.maSV, SinhVien.tenSV, LOP.tenLop
		from SinhVien inner join LOP on SinhVien.maLop = LOP.maLop
		where LOP.phong = @phong
	return
end 

select * from dbo.cau5('2')

-- Câu 6: Viết hàm thống kê xem mỗi phòng có bao nhiêu lớp học. Nếu phòng không tồn tại trả về giá trị 0.

create function Cau6(@phong varchar(20))
returns int
as
	begin
		if(not exists(select phong from LOP where phong = @phong))
			return 0
		else 
			declare @soluong int
			select @soluong = count(LOP.maLop)
			from LOP
			where LOP.phong = @phong
			group by LOP.phong
			return @soluong
end

select dbo.Cau6('5')
select dbo.Cau6('4')