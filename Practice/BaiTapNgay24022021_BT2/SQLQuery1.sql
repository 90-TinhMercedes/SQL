CREATE DATABASE QLSV_NGAY_24022021

use QLSV_Ngay_24022021

create table LOP(
	MaLop char(10) primary key,
	TenLop nvarchar(50),
	Phong nvarchar(50)
)

create table SV(
	MaSV char(10) primary key,
	TenSV nvarchar(50),
	MaLop char(10),
	constraint fk_SV foreign key (MaLop) references LOP(MaLop) on update cascade on delete cascade
)

insert into LOP values ('1', 'CD', '1')
insert into LOP values ('2', 'DH', '2')
insert into LOP values ('3', 'LT', '3')
insert into LOP values ('4', 'CH', '4')

insert into SV values ('SV01', 'AAA', '1')
insert into SV values ('SV02', 'BBB', '2')
insert into SV values ('SV03', 'CCC', '1')
insert into SV values ('SV04', 'DDD', '3')



 --Câu 01:
create function thongKeSoLuongSinhVienLop(@MaLop char(10))
returns int
as
	begin
		declare @SoLuong int 
		select @SoLuong = count (SV.MaLop)
		from SV, LOP
		where SV.MaLop= LOP.MaLop
		and LOP.MaLop = @MaLop
		group by LOP.TenLop
		return @SoLuong
	end

drop function thongKeSoLuongSinhVienLop

select  dbo.thongKeSoLuongSinhVienLop('1')
		
-- Câu 02
create function danhSachSinhVienTheoLop(@TenLop nvarchar(50))
returns table
as 
	return
		select MaSV, TenSV From SV, LOP 
		where SV.MaLop = LOP.MaLop and TenLop = @TenLop
		group by MaSV, TenSV

drop function danhSachSinhVienTheoLop

select * from dbo.danhSachSinhVienTheoLop('DH')
select * from dbo.danhSachSinhVienTheoLop('CD')

-- Câu 02 - Cách 2:
alter function danhSachSinhVienTheoLopVer2(@TenLop nvarchar(50))
returns @SinhVien table(MaSV char(10), TenSV nvarchar(50))
as 
	begin
		insert into @SinhVien
		select MaSV, TenSV from SV, LOP
		where SV.MaLop = LOP.MaLop and TenLop = @TenLop
		group by MaSV, TenSV
		return 
	end

select * from dbo.danhSachSinhVienTheoLopVer2('DH')
select * from dbo.danhSachSinhVienTheoLopVer2('CD')

--Câu 03 3. Đưa ra hàm thống kê sinhvien: malop,tenlop,soluong sinh viên trong lớp, với tên lớp
--được nhập từ bàn phím. Nếu lớp đó chưa tồn tại thì thống kê tất cả các lớp, ngược lại nếu
--lớp đó đã tồn tại thì chỉ thống kê mỗi lớp đó.

create function cau03(@TenLop nvarchar(50))
returns @ThongKe table(MaLop char(10), TenLop nvarchar(50), SoLuongSV int)
as
	begin
		if (not exists (select MaLop from LOP where TenLop = @TenLop))
			begin
				insert into @ThongKe
				select	LOP.MaLop, TenLop, count(SV.MaSV)
				from SV, LOP
				where SV.MaLop = LOP.MaLop
				group by LOP.MaLop, LOP.TenLop
				--return
			end
		else
			begin
				insert into @ThongKe
				select LOP.MaLop, TenLop, count(SV.MaSV)
				from SV, LOP
				where SV.MaLop = LOP.MaLop and TenLop = @TenLop
				group by LOP.MaLop, LOP.TenLop
			end
			return
	end

select * from dbo.cau03('QQ') --Tên lớp không tồn tại
select * from dbo.cau03('CD') --Tên lớp tồn tại
select * from dbo.cau03('DH') -- Tên lớp tồn tại


--Câu 04: Đưa ra phòng học của tên sinh viên nhập từ bàn phím.
create function cau04(@TenSV nvarchar(50))
returns table
as 
begin
	return 
	select LOP.Phong from SV, LOP
	where SV.MaLop = LOP.MaLop and TenSV = @TenSV
	group by LOP.Phong
end

select * from cau04('BBB')  --phòng tồn tại
select * from cau04('EEE')  --phòng không tồn tại

