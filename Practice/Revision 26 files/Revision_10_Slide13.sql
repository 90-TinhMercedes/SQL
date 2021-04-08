--Câu 1 (3đ): Tạo csdl QLHANG gåm 3 bảng sau: 
--+ Hang(MaHang,TenHang,DVTinh, SLTon)
--+ HDBan(MaHD,NgayBan,HoTenKhach)
--+ HangBan(MaHD,MaHang,DonGia,SoLuong)

create database QLHANG_Slide13

use QLHANG_Slide13

create table HANG (
	MaHang char(10) primary key,
	TenHang nvarchar(50),
	DVTinh nvarchar(50),
	SLTon int
)

create table HDBAN (
	MaHD char(10) primary key,
	NgayBan datetime,
	HoTenKhach nvarchar(50)
)

create table HANGBAN (
	MaHD char(10),
	MaHang char(10),
	DonGia money,
	SoLuong int,
	constraint pk_HANGBAN primary key (MaHD, MaHang),
	constraint first_fk_HangBan foreign key (MaHD) references HDBAN(MaHD) on update cascade on delete cascade,
	constraint second_fk_HangBan foreign key (MaHang) references HANG(MaHang) on update cascade on delete cascade 
)

insert into HANG values ('H01', 'Hang 01', 'cai', 10)
insert into HANG values ('H02', 'Hang 02', 'chiec', 15)

insert into HDBAN values ('HD01', '12/25/2020', 'Tinh Mercedes')
insert into HDBAN values ('HD02', '08/20/2019', 'Tinh Main Veigar')

insert into HANGBAN values ('HD01', 'H01', 15000, 5)
insert into HANGBAN values ('HD02', 'H02', 20000, 4)
insert into HANGBAN values ('HD02', 'H01', 17000, 3)
insert into HANGBAN values ('HD01', 'H02', 9000, 7)

select * from HANG
select * from HDBAN
select * from HANGBAN

--Câu 2 (2đ): Đưa ra hóa đơn có số mặt hàng >1 gồm: MaHD, Số mặt hàng.
select * from HANG
select * from HDBAN
select * from HANGBAN
select MaHD, COUNT(MaHang) as SoMatHang from HANGBAN
group by MaHD
having COUNT(MaHang) > 1

--Câu 3 (2đ): Hãy tạo hàm in ra tổng tiền hàng bán theo năm là bao nhiêu? (Với tham số vào là: Năm). 
create function cau3 (@nam int)
returns int
as
	begin
		declare @tongTienTheoNam int
		select @tongTienTheoNam = SUM(SoLuong * DonGia)
		from HDBAN inner join HANGBAN on HDBAN.MaHD = HANGBAN.MaHD
		where YEAR(NgayBan) = @nam
		return @tongTienTheoNam
	end

select * from HANG
select * from HDBAN
select * from HANGBAN
select dbo.cau3 (2019) as TongTien


--Câu 4 (3đ): Hãy tạo thủ tục lưu trữ tìm kiếm hàng theo tháng và năm 
--(Với 2 tham số vào là: Thang và Nam). Kết quả tìm được sẽ đưa ra một danh sách 
--gồm: MaHang, TenHang, NgayBan, SoLuong, NgayThu. Trong đó: 
--Cột NgayThu sẽ là: chủ nhật, thứ hai, ..., thứ bảy (dựa vào giá trị của cột NgayBan)

create procedure cau4 (@thang int, @nam int)
as
	begin
		select HANGBAN.MaHang, TenHang, NgayBan, SoLuong, case DATEPART(WEEKDAY, NgayBan)
			when 1 then 'Sunday'
			when 2 then 'Monday'
			when 3 then 'Tuesday'
			when 4 then 'Wednesday'
			when 5 then 'Thurday'
			when 6 then 'Friday'
			when 7 then 'Saturday' 
			end as NgayThu
		from HANG inner join HANGBAN on HANG.MaHang = HANGBAN.MaHang
		inner join HDBAN on HANGBAN.MaHD = HDBAN.MaHD
		where MONTH(NgayBan) = @thang and YEAR(NgayBan) = @nam
	end

select * from HANG
select * from HDBAN
select * from HANGBAN
execute cau4 12, 2020 
execute cau4 8, 2019 

