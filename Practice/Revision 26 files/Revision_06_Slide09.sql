create database QLHANG_Slide09

use QLHANG_Slide09

create table VATTU (
	MaVT char(10) primary key,
	TenVT nvarchar(50),
	DVTinh nvarchar(50),
	SLCon int
)

create table HDBAN (
	MaHD char(10) primary key,
	NgayXuat datetime,
	HoTenKhach nvarchar(50)
)

create table HANGXUAT (
	MaHD char(10),
	MaVT char(10),
	DonGia money,
	SLBan int,
	constraint pk_HANGXUAT primary key (MaHD, MaVT),
	constraint first_fk_HANGXUAT foreign key (MaHD) references HDBAN(MaHD) on update cascade on delete cascade,
	constraint second_fk_HANGXUAT foreign key (MaVT) references VATTU(MaVT) on update cascade on delete cascade
)



insert into VATTU values ('VT01', 'Vat tu 01', 'cai', 15)
insert into VATTU values ('VT02', 'Vat tu 02', 'chiec', 20)

insert into HDBAN values ('HD01', '10/25/2020', 'Tinh Mercedes')
insert into HDBAN values ('HD02', '03/19/2021', 'Tinh Veigar')

insert into HANGXUAT values ('HD01', 'VT01', 15000, 6)
insert into HANGXUAT values ('HD01', 'VT02', 10000, 7)
insert into HANGXUAT values ('HD02', 'VT01', 12000, 10)
insert into HANGXUAT values ('HD02', 'VT02', 21000, 6)

select * from VATTU
select * from HDBAN
select * from HANGXUAT

--Câu 2 (2đ): Tạo view đưa ra hóa đơn có tổng tiền vật tư nhiều nhất gồm: MaHD, Tổng tiền
alter view cau02
as
	select top(1) HDBAN.MaHD, sum(DonGia * SLBan) as TongTien
	from HDBAN inner join HANGXUAT on HDBAN.MaHD = HANGXUAT.MaHD
	--order by sum(DonGia * SLBan) DESC
	group by HDBAN.MaHD
	order by sum(DonGia * SLBan) DESC


	
select * from VATTU
select * from HDBAN
select * from HANGXUAT
select * from cau02


--Câu 3 (2.5đ): Viết hàm với tham số truyền vào là MaHD, hàm trả về một bảng gồm 
--các thông tin:MaHD,NgayXuat, MaVT, DonGia, SLBan, NgayThu. Trong đó: Cột NgayThu 
--sẽ là: chủ nhật, thứ hai, ..., thứ bảy (dựa vào giá trị của cột NgayXuat)

--Tạo hàm trả về ngày trong tuần
alter function getDay(@NgayXuat datetime)
returns nvarchar(50)
as 
	begin
		declare @NgayTrongTuan int
		set @NgayTrongTuan = DATEPART(WEEKDAY, @NgayXuat)
		declare @thu nvarchar(50)
		
		if(@NgayTrongTuan = 2)
		begin
			set @thu = N'Thứ Hai'
		end
		if(@NgayTrongTuan = 3)
		begin
			set @thu = N'Thứ Ba'
		end
		if(@NgayTrongTuan = 4)
		begin
			set @thu = N'Thứ Tư'
		end
		if(@NgayTrongTuan = 5)
		begin
			set @thu = N'Thứ Năm'
		end
		if(@NgayTrongTuan = 6)
		begin
			set @thu = N'Thứ Sáu'
		end
		if(@NgayTrongTuan = 7)
		begin
			set @thu = N'Thứ Bảy'
		end
		if(@NgayTrongTuan = 1)
		begin
			set @thu = N'Chủ Nhật'
		end

		return @thu
	end




alter function cau03 (@MaHD char(10))
returns @ThongKe table (MaHD char(10), NgayXuat datetime, MaVT char(10), DonGia money, SLBan int, NgayThu nvarchar(50))
as
	begin
	insert into @ThongKe
		select HDBAN.MaHD, NgayXuat, VATTU.MaVT, DonGia, SLBan, case datepart(weekday, NgayXuat)
		when 1 then 'Sunday'
		when 2 then 'Monday'
		when 3 then 'Tuesday'
		when 4 then 'Wednesday'
		when 5 then 'Thurday'
		when 6 then 'Friday'
		when 7 then 'Saturday' end

		from HDBAN inner join HANGXUAT on HDBAN.MaHD = HANGXUAT.MaHD
		inner join VATTU on HANGXUAT.MaVT = VATTU.MaVT
		where HANGXUAT.MaHD = @MaHD
		return
	end

drop function cau03
select * from cau03('HD01')

-- cách 2:
create function cau03_cach2 (@MaHD char(10))
returns table
as
	return
		select HDBAN.MaHD, NgayXuat, VATTU.MaVT, DonGia, SLBan, dbo.getDay(NgayXuat) as NgayThu
		from HDBAN inner join HANGXUAT on HDBAN.MaHD = HANGXUAT.MaHD
		inner join VATTU on HANGXUAT.MaVT = VATTU.MaVT
		where HANGXUAT.MaHD = @MaHD

select * from VATTU
select * from HDBAN
select * from HANGXUAT
select * from cau03('HD01')
select * from cau03_cach2('HD01')
select * from cau03('HD02')
select * from cau03_cach2('HD02') -- Thứ Sáu

-- Câu 4 (2.5đ): Hãy tạo thủ tục lưu trữ in ra tổng tiền vật tư xuất theo 
--tháng và năm là bao nhiêu? (Với tham số vào là: Tháng và Năm). 

create procedure cau4(@thang int, @nam int)
as
	begin
		select SUM(SLBan * DonGia) as TongTien
		from HDBAN inner join HANGXUAT on HDBAN.MaHD = HANGXUAT.MaHD
		where @thang = MONTH(NgayXuat) and @nam = YEAR(NgayXuat)
	end

select * from VATTU
select * from HDBAN
select * from HANGXUAT
execute cau4 10, 2020
execute cau4 3, 2021








