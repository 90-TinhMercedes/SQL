create database QLHANG_Slide08

use QLHANG_Slide08

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

--Câu 2 (2đ): Hãy tạo View đưa ra thống kê tiền hàng bán theo từng hóa đơn gồm: MaHD,NgayBan,Tổng tiền (tiền=SoLuong*DonGia)

create view cau02
as
	select HDBAN.MaHD, NgayBan, sum(SoLuong * DonGia) as TongTien
	from HDBAN inner join HANGBAN on HDBAN.MaHD = HANGBAN.MaHD
	group by HDBAN.MaHD, NgayBan 



select * from HANG
select * from HDBAN
select * from HANGBAN
select * from cau02

--Câu 3 (2đ): Hãy tạo thủ tục lưu trữ tìm kiếm hàng theo tháng và năm 
--(Với 2 tham số vào là: Thang và Nam). Kết quả tìm được sẽ đưa ra một 
--danh sách gồm: MaHang, TenHang, NgayBan, SoLuong, NgayThu. 
--Trong đó: Cột NgayThu sẽ là: chủ nhật, thứ hai, ..., 
--thứ bảy (dựa vào giá trị của cột NgayBan)

create procedure cau3 (@thang int, @nam int)
as
	begin
		select HANGBAN.MaHang, TenHang, NgayBan, SoLuong, case DATEPART(WEEKDAY, HDBAN.NgayBan)
		when 1 then 'Sunday'
		when 2 then 'Monday'
		when 3 then 'Tuesday'
		when 4 then 'Wednesday'
		when 5 then 'Thurday'
		when 6 then 'Friday'
		when 7 then 'Saturday' end
		from HANGBAN inner join HANG on HANG.MaHang = HANGBAN.MaHang
		inner join HDBAN on HDBAN.MaHD = HANGBAN.MaHD
		where MONTH(NgayBan) = @thang and YEAR(NgayBan) = @nam
	end

select * from HANG
select * from HDBAN
select * from HANGBAN
execute cau3 8, 2019
execute cau3 12, 2020

--Câu 4 (3đ): Hãy tạo Trigger để tự động giảm số lượng tồn (SLTon) 
--trong bảng Hang, mỗi khi thêm mới dữ liệu cho bảng HangBan. 
--(Đưa ra thông báo lỗi nếu SoLuong>SLTon) 

create trigger cau4
on HANGBAN
for insert
as
	begin
		declare @soLuongTon int
		declare @soLuongBan int
		declare @maHang char(10)
		select @soLuongTon = SLTon from HANG
		select @soLuongBan = SoLuong, @maHang = MaHang from inserted
		if (@soLuongTon < @soLuongBan)
			begin
				raiserror (N'Error: Không đủ hàng trong kho để bán. TRANSACTION!!', 16, 1)
				rollback transaction 
			end
		else
			update HANG set SLTon = SLTon - @soLuongBan where MaHang = @maHang
	end

drop trigger cay4


select * from HANG
select * from HDBAN
select * from HANGBAN
--insert into HANGBAN values ('HD01', 'H01', 15000, 100) -- Số lượng trong kho không đủ. Lỗi
insert into HANGBAN values ('HD02', 'H02', 20000, 4) -- Hợp lệ
select * from HANG
select * from HDBAN
select * from HANGBAN












